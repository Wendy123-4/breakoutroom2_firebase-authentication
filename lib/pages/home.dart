

import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Text("Below is an example of using the flutter packages \n(signin button package)"),

               SignInButton(Buttons.Facebook,
                onPressed: () {},
                mini: true,
              ),

            ]
        ),

      ),
    );
  }
}
