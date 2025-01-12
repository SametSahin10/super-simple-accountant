import 'dart:io';
import 'package:flutter/material.dart';
import 'package:super_simple_accountant/extensions.dart';
import 'package:super_simple_accountant/repositories/auth/auth_repository.dart';
import 'package:super_simple_accountant/widgets/auth/custom_sign_in_with_apple_button.dart';
import 'package:super_simple_accountant/widgets/auth/sign_in_with_google_button.dart';

class AuthBottomSheet extends StatelessWidget {
  const AuthBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (Platform.isIOS) ...[
            CustomSignInWithAppleButton(
              onPressed: () async {
                final navigator = Navigator.of(context);

                context.showProgressDialog(text: 'Signing in with Apple...');
                final authRepository = AuthRepository();
                await authRepository.signInWithApple();

                navigator.pop();
              },
            ),
            const SizedBox(height: 16),
          ],
          SignInWithGoogleButton(
            onPressed: () async {
              final navigator = Navigator.of(context);

              context.showProgressDialog(text: 'Signing in with Google...');
              final authRepository = AuthRepository();
              await authRepository.signInWithGoogle();

              navigator.pop();
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
