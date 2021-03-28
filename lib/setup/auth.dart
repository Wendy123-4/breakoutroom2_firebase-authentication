import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<String> currentUser();
  Future<String> signIn(String email, String password);
  Future<String> createUser(String email, String password);
  Future<void> signOut();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    AuthResult user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return "Signed In";
  }

  Future<String> createUser(String email, String password) async {
    AuthResult user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return "Signed Up";
  }

  Future<String> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user != null ? user.uid : null;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}
