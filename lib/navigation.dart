import 'package:flutter/material.dart';
import 'package:super_simple_accountant/screens/auth_screen.dart';

/// Pushes the auth screen and returns the user ID if the user is signed in.
Future<String?> pushAuthScreen(BuildContext context) {
  return Navigator.of(context).push<String>(
    MaterialPageRoute(
      builder: (context) => const AuthScreen(),
    ),
  );
}