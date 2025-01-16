import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:image_picker/image_picker.dart';
import 'package:super_simple_accountant/models/receipt/receipt_analysis_result.dart';
import 'package:cloud_functions/cloud_functions.dart';

class ReceiptScannerService {
  final _picker = ImagePicker();

  Future<XFile?> captureReceipt(ImageSource source) {
    return _picker.pickImage(
      source: source,
      preferredCameraDevice: CameraDevice.rear,
    );
  }

  Future<ReceiptAnalysisResult?> processReceipt(Uint8List image) async {
    final base64Image = base64Encode(image);

    try {
      final result = await FirebaseFunctions.instance
          .httpsCallable('analyzeReceipt')
          .call({
        'imageBase64': base64Image,
      });

      String analysis = result.data;
      analysis = analysis.replaceAll('```json', '');
      analysis = analysis.replaceAll('```', '');

      final json = jsonDecode(analysis);

      return ReceiptAnalysisResult.fromJson(json);
    } catch (e) {
      FirebaseCrashlytics.instance.recordError(
        Exception(
          "Failed to analyze receipt. Error: $e",
        ),
        StackTrace.current,
      );

      return null;
    }
  }
}
