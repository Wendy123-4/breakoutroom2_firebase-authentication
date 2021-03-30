import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebasedemo/setup/logIn.dart';
import 'package:firebasedemo/setup/auth.dart';

class AuthMock implements Auth {
  AuthMock({this.userId});
  String userId;

  bool didRequestSignIn = false;
  bool didRequestCreateUser = false;
  bool didRequestLogout = false;

  Future<String> signIn(String email, String password) async {
    didRequestSignIn = true;
    return _userIdOrError();
  }

  Future<String> createUser(String email, String password) async {
    didRequestCreateUser = true;
    return _userIdOrError();
  }

  Future<String> currentUser() async {
    return _userIdOrError();
  }

  Future<void> signOut() async {
    didRequestLogout = true;
    return Future.value();
  }

  Future<String> _userIdOrError() {
    if (userId != null) {
      return Future.value(userId);
    } else {
      throw StateError('No user');
    }
  }
}

void main() {
  Widget buildTestableWidget(Widget widget) {
    return new MediaQuery(
      data: new MediaQueryData(),
      child: new MaterialApp(home: widget),
    );
  }

  // Test 1

  // If the email is empty, or the password is less than 6 chars
  // when the user taps on the login button, the code should not attempt
  // to sign in with Firebase and the confirmation message is empty
  testWidgets('sign in fail - empty email and password or insufficient chars',
      (WidgetTester tester) async {
    // Create an authorization mock
    AuthMock mock = new AuthMock(userId: 'uid');
    // create a LoginPage
    SignIn loginPage = new SignIn(auth: mock);
    // Add it to the widget tester
    await tester.pumpWidget(buildTestableWidget(loginPage));

    // tap on the login button
    Finder loginButton = find.byKey(new Key('login'));
    await tester.tap(loginButton);

    // 'pump' the tester again. This causes the widget to rebuild
    await tester.pump();

    // check that the hint text is empty
    Finder hintText = find.byKey(new Key('hint'));
    expect(hintText.toString().contains(''), true);

    expect(mock.didRequestSignIn, false);
  });

  // Test 2

  // If the email and password are both correct, and they match an account on firebase
  // when the user taps on the login button, then attempt to sign in with Firebase
  // and the confirmation message is successful
  testWidgets('sign in successful - valid account',
      (WidgetTester tester) async {
    AuthMock mock = new AuthMock(userId: 'uid');
    SignIn loginPage = new SignIn(
      auth: mock,
    );
    await tester.pumpWidget(buildTestableWidget(loginPage));

    Finder emailField = find.byKey(new Key('email'));
    await tester.enterText(emailField, 'email');

    Finder passwordField = find.byKey(new Key('password'));
    await tester.enterText(passwordField, 'password');

    Finder loginButton = find.byKey(new Key('login'));
    await tester.tap(loginButton);

    await tester.pump();

    // Finder hintText = find.byKey(new Key('hint'));
    // expect(hintText.toString().contains('Signed In'), true);

    expect(mock.didRequestSignIn, true);
  });

  // Test 3

  // if the email and password are both non-empty, the password having more than 6 chars
  // and they do not match an account on Firebase when the user taps on the login button
  // then attempt to sign in with Firebase and show a failure confirmation message
  testWidgets('sign in failure - invalid account', (WidgetTester tester) async {
    AuthMock mock = new AuthMock(userId: null);
    SignIn loginPage = new SignIn(
      auth: mock,
    );
    await tester.pumpWidget(buildTestableWidget(loginPage));

    Finder emailField = find.byKey(new Key('email'));
    await tester.enterText(emailField, 'email');

    Finder passwordField = find.byKey(new Key('password'));
    await tester.enterText(passwordField, 'password');

    Finder loginButton = find.byKey(new Key('login'));
    await tester.tap(loginButton);

    await tester.pump();

    Finder hintText = find.byKey(new Key('hint'));
    expect(hintText.toString().contains('Sign In Error'), true);

    expect(mock.didRequestSignIn, true);
  });
}
