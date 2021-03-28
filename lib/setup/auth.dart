import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<String> currentUser();
  Future<String> signIn(String email, String password);
  Future<String> createUser(String email, String password);
  Future<void> signOut();
}

class Auth implements BaseAuth {
  // Before using Firebase Auth, you must first have ensured you have initialized FlutterFire.
  // To create a new Firebase Auth instance, call the instance getter on FirebaseAuth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // email/password sign in
  Future<String> signIn(String email, String password) async {
    FirebaseUser user = (await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
    return user.uid;
  }

  // email/password registration
  Future<String> createUser(String email, String password) async {
    FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    return user.uid;
  }

  // checking current user
  Future<String> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user != null ? user.uid : null;
  }

  // sign out
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}
