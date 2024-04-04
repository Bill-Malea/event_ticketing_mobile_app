import 'package:event_ticketing_mobile_app/main.dart';
import 'package:event_ticketing_mobile_app/utilities/toast_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FbAuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign up with email and password
  Future<User?> signUp(
      {required String email, required String password}) async {
    try {
      UserCredential user = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return user.user;
    } catch (error) {
      errortoast(error.toString());
      return null;
    }
  }

  // Sign in with email and password
  Future<User?> signIn(
      {required String email, required String password}) async {
    try {
      UserCredential user = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return user.user;
    } catch (error) {
      errortoast(error.toString());

      return null;
    }
  }

  // Sign out
  signOut() async {
    try {
      await _auth.signOut();

      return HomeScreen();
    } catch (error) {
      errortoast(error.toString());

      return null;
    }
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Check if user is signed in
  bool isUserSignedIn() {
    return _auth.currentUser != null;
  }
}
