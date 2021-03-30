import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebasedemo/setup/auth.dart';

// building simple login form
class SignIn extends StatefulWidget {
  SignIn({Key key, this.auth, this.onSignIn}) : super(key: key);

  // used to inject Auth object when sign in page is created
  final BaseAuth auth;
  final VoidCallback onSignIn;

  @override
  _SignInState createState() => new _SignInState();
}

enum FormType { login, register }

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // User can enter email and password
  // _authhint informs user of the authentication result
  String _email, _password, _authHint = '';
  FormType _formType = FormType.login;

  // validates the fields inside the form,
  // and saves the email and password if they are valid
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true; // save email and password if valid
    }
    return false; // returns false if email and password is invalid
  }

  // submits inputs
  validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        // if both email and password is correct, sign in with firebase
        String userId = _formType == FormType.login
            ? await widget.auth.signIn(_email, _password) // sign in the user
            : await widget.auth
                .createUser(_email, _password); // create user, if new account
        // schedule rebuild of sign in page and update UI
        setState(() {
          // set success hint message
          _authHint = 'Signed In\n\nUser id: $userId';
        });
        // condition for widget testing: comment out when done testing
        if (widget.onSignIn == null) return true;
        // schedule rebuild of signin page widget and update UI
        // widget.onSignIn();
      } catch (e) {
        // if the email or password is invalid, display error message
        setState(() {
          // set sign in error message
          _authHint = 'Sign In Error\n\n${e.toString()}';
        });
        print(e);
      }
    } else {
      setState(() {
        _authHint =
            ''; // if both inputs are non-empty or insufficient chars, return empty string
      });
    }
  }

  // method to change form type to register/create account
  void moveToRegister() {
    _formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
      _authHint = '';
    });
  }

  // method to change form type to login/sign in
  void moveToLogin() {
    _formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
      _authHint = '';
    });
  }

  // build method to create a Form to hold two textform fields (for email and password)
  // and a raised button (login button)
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Flutter Login"),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(16.0),
                      // here is where we are creating a form that holds two input fields for email and password
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: usernameAndPassword() +
                              submitWidgets(), // create input fields and sign in button
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              buildHintText(), // authentication result
            ],
          ),
        ),
      ),
    );
  }

  // widget(s) for email and password input fields
  List<Widget> usernameAndPassword() {
    return [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: TextFormField(
          key: new Key('email'),
          // simple email validator
          // check is email is empty
          validator: (input) => input.isEmpty ? 'Email can\'t be empty.' : null,
          decoration: InputDecoration(labelText: 'Email'),
          onSaved: (input) => _email = input,
          autocorrect: false,
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: TextFormField(
          key: new Key('password'),
          // simple password validator
          // checks if password is less than 6 chars
          validator: (input) =>
              input.length < 6 ? 'Password must be at least 6 chars.' : null,
          decoration: InputDecoration(labelText: 'Password'),
          onSaved: (input) => _password = input,
          obscureText: true,
          autocorrect: false,
        ),
      ),
      SizedBox(
        height: 30.0,
      ),
    ];
  }

  // widget(s) for either login or creating an account
  List<Widget> submitWidgets() {
    switch (_formType) {
      case FormType.login:
        return [
          ConstrainedBox(
            constraints: BoxConstraints.expand(height: 44.0),
            child: new RaisedButton(
              key: new Key('login'),
              textColor: Colors.black87,
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(22.0),
                ),
              ),
              child: Text(
                "Sign In",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
              // call validateAndSubmit() if login button is tapped
              // this, in turn, calls validateAndSave()
              onPressed: validateAndSubmit,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          new FlatButton(
            key: new Key('need-account'),
            child: new Text(
              "Don't have an account? Sign Up!",
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
            onPressed: moveToRegister,
          ),
        ];
      case FormType.register:
        return [
          ConstrainedBox(
            constraints: BoxConstraints.expand(height: 44.0),
            child: new RaisedButton(
                key: new Key('register'),
                child: Text(
                  "Sign Up",
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
                textColor: Colors.black87,
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(22.0),
                  ),
                ),
                onPressed: validateAndSubmit),
          ),
          SizedBox(
            height: 10.0,
          ),
          new FlatButton(
              key: new Key('need-login'),
              child: new Text(
                "Already have an account? Sign In!",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
              onPressed: moveToLogin),
        ];
    }
    return null;
  }

  // widget for authentication result
  Widget buildHintText() {
    return Container(
      padding: EdgeInsets.all(32.0),
      child: new Text(_authHint,
          key: new Key('hint'),
          style: new TextStyle(fontSize: 12.0, color: Colors.grey),
          textAlign: TextAlign.center),
    );
  }
}
