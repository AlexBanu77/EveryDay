import 'package:flutter/material.dart';

class LoginMenuBottom extends StatelessWidget {
  const LoginMenuBottom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (int index) {
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/login');
            break;
          case 1:
            Navigator.pushNamed(context, '/register');
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: 'Login'),
        BottomNavigationBarItem(
            icon: Icon(Icons.accessibility_new_sharp),
            label: 'Register')
      ],
    );
  }
}
