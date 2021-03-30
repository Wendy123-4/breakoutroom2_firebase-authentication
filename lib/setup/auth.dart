import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

// inject dependencies as abstract class into our widgets
// helps to make all code inside our tests synchronous
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
  // warp inside 'Future' because sign in is asynchronous
  Future<String> signIn(String email, String password) async {
    FirebaseUser user = (await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
    return user.uid; // returns user id as string
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
