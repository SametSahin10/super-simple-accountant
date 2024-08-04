import 'package:flutter/material.dart';
import 'package:super_simple_accountant/screens/home_screen.dart';
import 'package:super_simple_accountant/widgets/text_with_top_padding.dart';

class AddEntryButton extends StatelessWidget {
  const AddEntryButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
            padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 36, vertical: 12),
            ),
          ),
      onPressed: () => pushAddEntryScreen(context),
      child: const TextWithTopPadding(
        text: Text(
          "Add Entry",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
      ),
    );
  }
}
