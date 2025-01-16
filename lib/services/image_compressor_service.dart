import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageCompressorService {
  Future<Uint8List> compressFile(Uint8List list) async {
    return FlutterImageCompress.compressWithList(
      list,
      minHeight: 720,
      minWidth: 480,
      quality: 96,
    );
  }
}