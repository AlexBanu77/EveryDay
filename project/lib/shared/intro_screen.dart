import 'package:flutter/material.dart';
import 'package:hello_world/shared/menu_bottom.dart';
import 'package:hello_world/shared/menu_drawer.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('EveryDay'))),
      drawer: MenuDrawer(),
      bottomNavigationBar: MenuBottom(),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/background_image.jpg'),
          fit: BoxFit.cover,
        )),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(15),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.white70,
            ),
            child: const Text(
              'Surf through the upcoming events and save your spot!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, shadows: [
                Shadow(
                    offset: Offset(1.0, 1.0),
                    blurRadius: 2.0,
                    color: Colors.greenAccent)
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
