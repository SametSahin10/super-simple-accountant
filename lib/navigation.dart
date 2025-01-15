import 'package:flutter/material.dart';
import 'package:super_simple_accountant/screens/auth_screen.dart';

/// Pushes the auth screen and returns the user ID if the user is signed in.
Future<String?> pushAuthScreen(NavigatorState navigator) {
  return navigator.push<String>(
    MaterialPageRoute(
      builder: (context) => const AuthScreen(),
    ),
  );
}