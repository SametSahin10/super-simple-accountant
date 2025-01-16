import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:super_simple_accountant/exceptions.dart';

class AuthRepository {
  /// Signs in anonymously and returns the user ID.
  /// If the user is already signed in, it will return the current user ID.
  Future<String?> signInAnonymously() async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        final userCredential = await FirebaseAuth.instance.signInAnonymously();
        userId = userCredential.user?.uid;
      }

      return userId;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          debugPrint("Anonymous auth hasn't been enabled for this project.");
          return null;
        default:
          debugPrint("Unknown error.");
          return null;
      }
    }
  }

  Future<String?> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Check if current user is anonymous
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser?.isAnonymous ?? false) {
        final userCredential =
            await currentUser?.linkWithCredential(credential);
        return userCredential?.user?.uid;
      }

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      return userCredential.user?.uid;
    } on FirebaseAuthException catch (e, s) {
      if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseException();
      }

      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: 'Error signing in with Google',
      );

      rethrow;
    }
  }

  Future<String?> signInWithApple() async {
    try {
      final rawNonce = generateNonce();
      final sha256Nonce = sha256OfString(rawNonce);

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: sha256Nonce,
      );

      final idToken = credential.identityToken;

      if (idToken == null) {
        throw Exception(
          'An error occurred while signing in with Apple.',
        );
      }

      final appleFullPersonName = AppleFullPersonName(
        givenName: credential.givenName,
        familyName: credential.familyName,
      );

      final appleCredential = AppleAuthProvider.credentialWithIDToken(
        idToken,
        rawNonce,
        appleFullPersonName,
      );

      // Check if current user is anonymous
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser?.isAnonymous ?? false) {
        final userCredential =
            await currentUser?.linkWithCredential(appleCredential);
        return userCredential?.user?.uid;
      }

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(appleCredential);

      return userCredential.user?.uid;
    } on FirebaseAuthException catch (e, s) {
      if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseException();
      }

      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: 'Error signing in with Apple',
      );
      rethrow;
    } on SignInWithAppleAuthorizationException catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: 'Apple sign in was cancelled or failed',
      );
      rethrow;
    }
  }

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    final randomNumber = random.nextInt(charset.length);
    return List.generate(length, (_) => charset[randomNumber]).join();
  }

  String sha256OfString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
