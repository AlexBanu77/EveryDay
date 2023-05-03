import 'package:flutter/material.dart';
import 'package:hello_world/shared/bmi_screen.dart';
import 'package:hello_world/shared/events_screen.dart';
import 'package:hello_world/shared/intro_screen.dart';
import 'package:hello_world/shared/login_screen.dart';
import 'package:hello_world/shared/register_screen.dart';
void main() {
  runApp(const GlobeApp());
}

class GlobeApp extends StatelessWidget {
  const GlobeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.teal),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/events': (context) => const DisplayEvents(),
          // '/': (context) => HomePage(),
          '/register': (context) => RegisterScreen(),

        },
        // initialRoute: '/events',
        initialRoute: '/login',

        // home: IntroScreen()
    );
  }
}
