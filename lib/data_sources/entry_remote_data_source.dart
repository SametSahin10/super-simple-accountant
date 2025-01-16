import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/entry.dart';

class EntryRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'entries';

  Future<String> createEntry(Entry entry) async {
    try {
      final docRef = _firestore.collection(_collection).doc(entry.id);
      final entryJson = entry.toJson();
      await docRef.set(entryJson);
      debugPrint('Entry created with ID: ${entry.id}');
      return entry.id;
    } catch (e) {
      debugPrint('Error creating entry: $e');
      rethrow;
    }
  }

  Future<Entry?> getEntry(String entryId) async {
    try {
      final docSnapshot =
          await _firestore.collection(_collection).doc(entryId).get();
      if (docSnapshot.exists) {
        final entry = Entry.fromJson(docSnapshot.data()!);
        debugPrint('Entry retrieved: ${entry.description}');
        return entry;
      } else {
        debugPrint('Entry not found');
        return null;
      }
    } catch (e) {
      debugPrint('Error getting entry: $e');
      rethrow;
    }
  }

  Future<List<Entry>> getAllEntries({required String userId}) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .get();

      final entries =
          querySnapshot.docs.map((doc) => Entry.fromJson(doc.data())).toList();

      debugPrint('Retrieved ${entries.length} entries');

      return entries;
    } catch (e) {
      debugPrint('Error getting all entries: $e');
      rethrow;
    }
  }

  Future<void> deleteEntry(Entry entry) async {
    await _firestore.collection(_collection).doc(entry.id).delete();
  }
}
