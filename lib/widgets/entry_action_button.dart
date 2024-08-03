import 'package:flutter/material.dart';

class EntryActionButton extends StatelessWidget {
  final String iconPath;
  final Color color;
  final VoidCallback onTap;

  const EntryActionButton({
    super.key,
    required this.iconPath,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Image.asset(iconPath, scale: 3),
      ),
    );
  }
}
