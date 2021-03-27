import 'package:firebasedemo/setup/logIn.dart';
import 'package:firebasedemo/setup/root.dart';
import 'package:flutter/material.dart';
import 'package:firebasedemo/setup/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Login',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: RootPage(auth: new Auth()),
      home: SignIn(),
    );
  }
}
