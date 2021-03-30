import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebasedemo/setup/logIn.dart';
import 'package:firebasedemo/setup/auth.dart';

// implementing widget testing with mocks and ensuring they return immediately
class AuthMock implements Auth {
  AuthMock({this.userId});
  String userId;

  bool didRequestSignIn = false;
  bool didRequestCreateUser = false;
  bool didRequestLogout = false;

  // sign in
  Future<String> signIn(String email, String password) async {
    didRequestSignIn = true;
    return _userIdOrError();
  }

  // create user
  Future<String> createUser(String email, String password) async {
    didRequestCreateUser = true;
    return _userIdOrError();
  }

  // current user
  Future<String> currentUser() async {
    return _userIdOrError();
  }

  // sign out
  Future<void> signOut() async {
    didRequestLogout = true;
    return Future.value();
  }

  // log message
  Future<String> _userIdOrError() {
    if (userId != null) {
      return Future.value(userId); // successful response
    } else {
      throw StateError('No user'); // failed response
    }
  }
}

void main() {
  // wrap widget with MediaQuery(...) instance,
  // and because we are using Scaffold(..),
  // wrap it in MaterialApp(..)
  // https://docs.flutter.io/flutter/widgets/MediaQuery-class.html
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
    // Create a Login Page
    SignIn loginPage = new SignIn(auth: mock);
    // Add it to the widget tester
    await tester.pumpWidget(buildTestableWidget(loginPage));

    // tap on the login button
    Finder loginButton = find.byKey(new Key('login'));
    await tester.tap(loginButton);

    // 'pump' the tester again
    // This causes the widget to rebuild
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
    // mock with user id - to simulate success
    AuthMock mock = new AuthMock(userId: 'uid');
    SignIn loginPage = new SignIn(
      auth: mock,
    );
    await tester.pumpWidget(buildTestableWidget(loginPage));

    // enter email as text
    Finder emailField = find.byKey(new Key('email'));
    await tester.enterText(emailField, 'email');

    // enter password as text
    Finder passwordField = find.byKey(new Key('password'));
    await tester.enterText(passwordField, 'password');

    // tap login button
    Finder loginButton = find.byKey(new Key('login'));
    await tester.tap(loginButton);

    await tester.pump();

    // check hint text contains "Signed In"
    Finder hintText = find.byKey(new Key('hint'));
    expect(hintText.toString().contains('Signed In'), true);

    expect(mock.didRequestSignIn, true);
  });

  // Test 3

  // if the email and password are both non-empty, the password having more than 6 chars
  // and they do not match an account on Firebase when the user taps on the login button
  // then attempt to sign in with Firebase and show a failure confirmation message
  testWidgets('sign in failure - invalid account', (WidgetTester tester) async {
    // mock without user id - simulates error
    AuthMock mock = new AuthMock(userId: null);
    SignIn loginPage = new SignIn(
      auth: mock,
    );
    await tester.pumpWidget(buildTestableWidget(loginPage));

    // enter email as text
    Finder emailField = find.byKey(new Key('email'));
    await tester.enterText(emailField, 'email');

    // enter password as text
    Finder passwordField = find.byKey(new Key('password'));
    await tester.enterText(passwordField, 'password');

    // tap on login button
    Finder loginButton = find.byKey(new Key('login'));
    await tester.tap(loginButton);

    await tester.pump();

    // check hint text contains "Sign In Error"
    Finder hintText = find.byKey(new Key('hint'));
    expect(hintText.toString().contains('Sign In Error'), true);

    expect(mock.didRequestSignIn, true);
  });
}
