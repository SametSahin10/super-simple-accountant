import 'package:flutter/material.dart';
import 'package:super_simple_accountant/assets.dart';
import 'package:super_simple_accountant/widgets/auth/social_login_button.dart';

class CustomSignInWithAppleButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CustomSignInWithAppleButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SocialLoginButton(
      onPressed: onPressed,
      text: 'Sign in with Apple',
      iconAsset: Assets.appleLogo,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      iconHeight: 20,
    );
  }
}
