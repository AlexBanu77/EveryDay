import 'package:flutter/material.dart';
import 'package:fronty/screen/login_signup.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // the dumb ribbon in the top right corner
      title: "Login",
      home: LoginSignupScreen(),
    );
  }
}
