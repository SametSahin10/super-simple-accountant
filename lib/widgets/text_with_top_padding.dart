import 'package:flutter/material.dart';

class TextWithTopPadding extends StatelessWidget {
  final Text text;

  const TextWithTopPadding({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(top: 4), child: text);
  }
}
