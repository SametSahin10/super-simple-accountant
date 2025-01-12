import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:super_simple_accountant/exceptions.dart';

class AuthRepository {
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
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

  Future<UserCredential> signInWithApple() async {
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

      return await FirebaseAuth.instance.signInWithCredential(appleCredential);
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
