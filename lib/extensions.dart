import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  double get width => MediaQuery.of(this).size.width;

  double get height => MediaQuery.of(this).size.height;

  bool get largerThanMobile {
    return width > 450;
  }
}
