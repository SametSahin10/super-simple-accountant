import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FileStorageRepository {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadFile({
    required String userId,
    required Uint8List file,
  }) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final destination = 'uploads/$userId/$fileName';
      final ref = _storage.ref(destination);

      await ref.putData(file);

      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      debugPrint('Error uploading file: $e');
      rethrow;
    }
  }
}
