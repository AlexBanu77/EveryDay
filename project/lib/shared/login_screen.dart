import 'dart:convert';
import 'bottom_menu.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

// import 'login_menu_bottom.dart';

var client = http.Client();




Future<bool> checkPass(username, password) async {
  var response = await client.post('http://192.168.172.24:5001/users/',
      body: {"username": username, "password": password});
  var decodedData = jsonDecode(response.body);
  return decodedData;
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _animation;
  int currentIndex = 0;

void onTabSelected(int index) {
  setState(() {
    currentIndex = index;
  });
}

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation =
        Tween<double>(begin: 1, end: 0.9).animate(_animationController);
  }

  @override
  void dispose() {
    userController.dispose();
    passwordController.dispose();
    client.close();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _onPressed() async {
    if (await checkPass(userController.text, passwordController.text)) {
      Navigator.pushNamed(context, '/events');
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login Failed'),
            content: Text('Credentials not valid.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'EveryDay',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      // bottomNavigationBar: LoginMenuBottom(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade800,
              Colors.blue.shade300,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: userController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: 'Username',
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: 'Password',
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTapDown: (_) {
                    _animationController.forward();
                  },
                  onTapUp: (TapUpDetails details) async {
                    _animationController.reverse();
                    await _onPressed();
                  },
                  onTapCancel: () {
                    _animationController.reverse();
                  },
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _animation.value,
                        child: Container(
                          width: 150,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.blue.shade800,
                          ),
                          child: Center(
                            child: Text(
                              'LOGIN',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomMenu(
        currentIndex: currentIndex,
        onTabSelected: onTabSelected,
      ),
    );
  }
}
