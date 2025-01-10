import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:super_simple_accountant/models/receipt/receipt_analysis_result.dart';
import 'package:cloud_functions/cloud_functions.dart';

class ReceiptScannerService {
  final _picker = ImagePicker();

  Future<XFile?> captureReceipt() {
    return _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
    );
  }

  Future<ReceiptAnalysisResult?> processReceipt(XFile image) async {
    final bytes = await image.readAsBytes();
    final base64Image = base64Encode(bytes);

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
      // Handle error
      return null;
    }
  }
}
