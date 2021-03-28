import 'dart:ui';

import 'package:firebasedemo/setup/auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_button/sign_button.dart';

class HomePage extends StatefulWidget {
  HomePage({this.auth, this.onSignOut});
  final BaseAuth auth;
  final VoidCallback onSignOut;

  void _signOut() async {
    try {
      await auth.signOut();
      onSignOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _buttonClick = "Click Button";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In Buttons"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '$_buttonClick',
                style: Theme.of(context).textTheme.headline4,
              ),
              SizedBox(
                height: 20.0,
              ),
              SignInButton(
                  buttonType: ButtonType.apple,
                  width: MediaQuery.of(context).size.width / 1.5,
                  onPressed: () {
                    setState(() {
                      _buttonClick = "Apple";
                    });
                  }),
              SignInButton(
                  buttonType: ButtonType.facebook,
                  width: MediaQuery.of(context).size.width / 1.5,
                  onPressed: () {
                    setState(() {
                      _buttonClick = "Facebook";
                    });
                  }),
              SignInButton(
                  buttonType: ButtonType.twitter,
                  width: MediaQuery.of(context).size.width / 1.5,
                  onPressed: () {
                    setState(() {
                      _buttonClick = "Twitter";
                    });
                  }),
              SignInButton(
                  buttonType: ButtonType.github,
                  width: MediaQuery.of(context).size.width / 1.5,
                  onPressed: () {
                    setState(() {
                      _buttonClick = "Github";
                    });
                  }),
              SignInButton(
                  buttonType: ButtonType.google,
                  width: MediaQuery.of(context).size.width / 1.5,
                  onPressed: () {
                    setState(() {
                      _buttonClick = "Google";
                    });
                  }),
              SignInButton(
                  buttonType: ButtonType.linkedin,
                  width: MediaQuery.of(context).size.width / 1.5,
                  onPressed: () {
                    setState(() {
                      _buttonClick = "LinkedIn";
                    });
                  }),
              SizedBox(
                height: 20.0,
              ),
              RaisedButton(
                onPressed: widget._signOut,
                color: Colors.blue,
                child: new Text(
                  'Logout',
                  style: new TextStyle(fontSize: 16.0, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
