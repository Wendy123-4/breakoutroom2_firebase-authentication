import 'package:flutter/material.dart';
import 'package:firebasedemo/setup/auth.dart';
import 'package:firebasedemo/setup/logIn.dart';
import 'package:firebasedemo/pages/home.dart';

// this class helps us check if a user is signed in or not
// so we can confirm request to sign out
class RootPage extends StatefulWidget {
  RootPage({Key key, this.auth}) : super(key: key);
  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus {
  notSignedIn,
  signedIn,
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.notSignedIn; // status of user

  initState() {
    super.initState();
    widget.auth.currentUser().then((userId) {
      // if current user has user id, then the user is signed in
      setState(() {
        authStatus =
            userId != null ? AuthStatus.signedIn : AuthStatus.notSignedIn;
      });
    });
  }

  // update sign in status
  void _updateAuthStatus(AuthStatus status) {
    setState(() {
      authStatus = status;
    });
  }

  // build switch cases for user sign in or out
  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notSignedIn:
        return SignIn(
          auth: widget.auth,
          onSignIn: () => _updateAuthStatus(AuthStatus.signedIn),
        );
      case AuthStatus.signedIn:
        return HomePage(
            auth: widget.auth,
            onSignOut: () => _updateAuthStatus(AuthStatus.notSignedIn));
    }
    return null;
  }
}
