import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasedemo/pages/home.dart';
import 'package:firebasedemo/setup/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignIn extends StatefulWidget {
//   SignIn({Key key, this.auth, this.onSignIn}) : super(key: key);

//   final BaseAuth auth;
//   final VoidCallback onSignIn;
  @override
  _SignInState createState() => new _SignInState();
}

// enum FormType { login, register }

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password, _authHint = '';
//   FormType _formType = FormType.login;

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

//   void validateAndSubmit() async {
//     if (validateAndSave()) {
//       try {
//         String userId = _formType == FormType.login
//             ? await widget.auth.signIn(_email, _password)
//             : await widget.auth.createUser(_email, _password);
//         setState(() {
//           _authHint = 'Signed In\n\nUser id: $userId';
//         });
//         widget.onSignIn();
//       } catch (e) {
//         setState(() {
//           _authHint = 'Sign In Error\n\n${e.toString()}';
//         });
//         print(e);
//       }
//     } else {
//       setState(() {
//         _authHint = '';
//       });
//     }
//   }

//   void moveToRegister() {
//     _formKey.currentState.reset();
//     setState(() {
//       _formType = FormType.register;
//       _authHint = '';
//     });
//   }

//   void moveToLogin() {
//     _formKey.currentState.reset();
//     setState(() {
//       _formType = FormType.login;
//       _authHint = '';
//     });
//   }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Sign In"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                key: new Key('email'),
                validator: (input) =>
                    input.isEmpty ? 'Email can\'t be empty.' : null,
                decoration: InputDecoration(labelText: 'Email'),
                onSaved: (input) => _email = input,
              ),
              TextFormField(
                key: new Key('password'),
                validator: (input) => input.length < 6
                    ? 'Password must be at least 6 chars.'
                    : null,
                decoration: InputDecoration(labelText: 'Password'),
                onSaved: (input) => _password = input,
                obscureText: true,
              ),
              SizedBox(
                height: 20.0,
              ),
              RaisedButton(
                key: new Key('login'),
                onPressed: signIn,
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              // submitWidgets(),
              Container(
                height: 80.0,
                padding: const EdgeInsets.all(32.0),
                child: buildHintText(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHintText() {
    return new Text(_authHint,
        key: new Key('hint'),
        style: new TextStyle(fontSize: 14.0, color: Colors.grey),
        textAlign: TextAlign.center);
  }

  Future<void> signIn() async {
    if (validateAndSave()) {
      try {
        AuthResult user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } catch (e) {
        setState(() {
          _authHint = 'Sign In Error\n\n${e.toString()}';
        });
        print(e.message);
      }
    } else {
      setState(() {
        _authHint = '';
      });
    }
  }

  // List<Widget> submitWidgets() {
  //   switch (_formType) {
  //     case FormType.login:
  //       return [
  //         new RaisedButton(
  //             key: new Key('login'),
  //             child: Text("Login"),
  //             onPressed: validateAndSubmit),
  //         new FlatButton(
  //             key: new Key('need-account'),
  //             child: new Text("Need an account? Register"),
  //             onPressed: moveToRegister),
  //       ];
  //     case FormType.register:
  //       return [
  //         new RaisedButton(
  //             key: new Key('register'),
  //             child: Text("Create an account?"),
  //             // height: 44.0,
  //             onPressed: validateAndSubmit),
  //         new FlatButton(
  //             key: new Key('need-login'),
  //             child: new Text("Have an account? Login"),
  //             onPressed: moveToLogin),
  //       ];
  //   }
  // }
}
