import 'package:flutter/material.dart';
import 'package:hello_world/shared/bmi_screen.dart';
import 'package:hello_world/shared/intro_screen.dart';

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
          '/': (context) => const IntroScreen(),
          '/bmi': (context) => const BmiScreen(),
        },
        initialRoute: '/',
        // home: IntroScreen()
    );
  }
}
