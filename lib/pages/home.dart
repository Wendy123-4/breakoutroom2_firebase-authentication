import 'package:firebasedemo/setup/auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_button/sign_button.dart';

class HomePage extends StatefulWidget {
  // HomePage({this.auth});
  // final BaseAuth auth;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _buttonClick = "Click Sign In Button";

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
                height: 5.0,
              ),
              SignInButton(
                  buttonType: ButtonType.apple,
                  onPressed: () {
                    setState(() {
                      _buttonClick = "apple";
                    });
                  }),
              SignInButton(
                  buttonType: ButtonType.facebook,
                  onPressed: () {
                    setState(() {
                      _buttonClick = "facebook";
                    });
                  }),
              SignInButton(
                  buttonType: ButtonType.twitter,
                  onPressed: () {
                    setState(() {
                      _buttonClick = "twitter";
                    });
                  }),
              SignInButton(
                  buttonType: ButtonType.github,
                  onPressed: () {
                    setState(() {
                      _buttonClick = "github";
                    });
                  }),
              SignInButton(
                  buttonType: ButtonType.google,
                  onPressed: () {
                    setState(() {
                      _buttonClick = "google";
                    });
                  }),
              SignInButton(
                  buttonType: ButtonType.linkedin,
                  onPressed: () {
                    setState(() {
                      _buttonClick = "linkedIn";
                    });
                  }),
              SignInButton(
                  buttonType: ButtonType.youtube,
                  onPressed: () {
                    setState(() {
                      _buttonClick = "youtube";
                    });
                  }),
              SignInButton.mini(
                buttonType: ButtonType.github,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
