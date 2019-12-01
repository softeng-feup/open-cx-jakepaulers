import 'dart:async';
import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static Future<String> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  static Future<String> signUp(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;
    result.user.sendEmailVerification();
    return user.uid;
  }

  static Future<String> reauthenticate(String password) async {
    FirebaseUser user = await getCurrentUser();
    AuthCredential credential = EmailAuthProvider.getCredential(email: user.email, password: password);
    AuthResult result = await user.reauthenticateWithCredential(credential);
    //return result.user.uid;
    return "";
  }

  static Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  static Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  static Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  static Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  static Future<void> sendForgotPassword(String email) async {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}