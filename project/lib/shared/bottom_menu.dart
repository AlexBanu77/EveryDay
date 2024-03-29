import 'package:flutter/material.dart';

class CustomBottomMenu extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const CustomBottomMenu({
    Key? key,
    required this.currentIndex,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/login'); 
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/register'); 
            break;
        }
        onTabSelected(index);
      },
      selectedItemColor: Colors.blue, // highlight color
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.login),
          label: 'Login',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.accessibility_new_sharp),
          label: 'Register',
        ),
      ],
    );
  }
}
