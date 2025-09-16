import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign Up
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      if (kDebugMode) {
        print("Sign Up Error: $e");
      }
      return null;
    }
  }

  // Sign In
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      if (kDebugMode) {
        print("Login Error: $e");
      }
      return null;
    }
  }

  // Sign In
  Future<User?> forgetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("Forget Password Error: $e");
      }
      return null;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      if (kDebugMode) {
        print("User Signed Out");
      }
    }
  }
}
