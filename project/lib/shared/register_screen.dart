import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hello_world/shared/menu_bottom.dart';
import 'package:hello_world/shared/menu_drawer.dart';
import 'package:http/http.dart' as http;
import 'login_menu_bottom.dart';


var client = http.Client();

Future<bool> registerUser(username, password) async {
  var response = await client.post(
      'http://192.168.172.24:5001/users/register', body:
  {
    "username": username,
    "password": password
  });
  var decodedData = jsonDecode(response.body);
  return decodedData;
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<RegisterScreen> {
  // Create a text controller. Later, use it to retrieve the
  // current value of the TextField.
  final userController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    userController.dispose();
    passwordController.dispose();
    client.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('Register')), automaticallyImplyLeading: false),
      bottomNavigationBar: LoginMenuBottom(),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background_image.jpg'),
              fit: BoxFit.cover,
            )),
        child: Center(
          child: Container(
              padding: EdgeInsets.all(15),
              child: Column(
                  children: <Widget>[
                    TextField(
                      controller: userController,
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Enter your username',
                          fillColor: Colors.white,
                          filled: true
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Enter your password',
                          fillColor: Colors.white,
                          filled: true
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        // Respond to button press
                        if(await registerUser(userController.text, passwordController.text)){
                          Navigator.pushNamed(context, '/events');
                        }

                      },
                      child: const Text('Register'),
                    )
                  ]
              )
          ),
        ),
      ),
    );
  }
}

