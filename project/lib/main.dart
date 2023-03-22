import 'package:flutter/material.dart';
import 'package:hello_world/screens/bmi_screen.dart';
import 'package:hello_world/screens/intro_screen.dart';

void main() {
  runApp(GlobeApp());
}

class GlobeApp extends StatelessWidget {
  const GlobeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.teal),
        routes: {
          '/': (context) => IntroScreen(),
          '/bmi': (context) => BmiScreen()
        },
        initialRoute: '/',
        // home: IntroScreen()
    );
  }
}
