import 'package:flutter/material.dart';
import 'package:super_simple_accountant/assets.dart';
import 'package:super_simple_accountant/widgets/auth/social_login_button.dart';

class SignInWithGoogleButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SignInWithGoogleButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SocialLoginButton(
      onPressed: onPressed,
      text: 'Sign in with Google',
      iconAsset: Assets.googleLogo,
      iconHeight: 24,
      backgroundColor: Colors.white,
    );
  }
}
