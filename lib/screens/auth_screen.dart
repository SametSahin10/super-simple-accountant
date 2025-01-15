import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_simple_accountant/extensions.dart';
import 'package:super_simple_accountant/repositories/auth/auth_repository.dart';
import 'package:super_simple_accountant/widgets/auth/custom_sign_in_with_apple_button.dart';
import 'package:super_simple_accountant/widgets/auth/sign_in_with_google_button.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Text(
                "Let's set up your account",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SvgPicture.asset(
                    'assets/illustrations/auth.svg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (Platform.isIOS) ...[
                CustomSignInWithAppleButton(
                  onPressed: () async {
                    final navigator = Navigator.of(context);
                    context.showProgressDialog(
                        text: 'Signing in with Apple...');
                    final authRepository = AuthRepository();
                    final result = await authRepository.signInWithApple();
                    navigator
                      ..pop() // Pop progress dialog
                      ..pop(result); // Pop auth screen with result
                  },
                ),
                const SizedBox(height: 16),
              ],
              SignInWithGoogleButton(
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  context.showProgressDialog(text: 'Signing in with Google...');
                  final authRepository = AuthRepository();
                  final result = await authRepository.signInWithGoogle();
                  navigator
                    ..pop() // Pop progress dialog
                    ..pop(result); // Pop auth screen with result
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
