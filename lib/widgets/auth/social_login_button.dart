import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialLoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final String iconAsset;
  final Color? backgroundColor;
  final Color? textColor;
  final double? iconHeight;

  const SocialLoginButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.iconAsset,
    this.backgroundColor,
    this.textColor,
    this.iconHeight,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: SvgPicture.asset(iconAsset, height: iconHeight ?? 18),
        ),
        label: Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Text(
            text,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: textColor ?? Colors.black,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
            side: BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
