import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hello_world/shared/menu_bottom.dart';
import 'package:hello_world/shared/menu_drawer.dart';
import 'package:http/http.dart' as http;
import 'login_menu_bottom.dart';


var client = http.Client();

Future<bool> checkPass(username, password) async {
  var response = await client.post(
    'http://192.168.172.24:5001/users/', body:
    {
      "username": username,
      "password": password
    });
  var decodedData = jsonDecode(response.body);
  return decodedData;
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<LoginScreen> {
  // Create a text controller. Later, use it to retrieve the
  // current value of the TextField.
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
      appBar: AppBar(title: Center(child: Text('EveryDay')), automaticallyImplyLeading: false),
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
            child: Form(
                key: _formKey,
                child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: userController,
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Enter your username',
                            fillColor: Colors.white,
                            filled: true
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        style: const TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Enter your password',
                            fillColor: Colors.white,
                            filled: true
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        style: const TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          // Respond to button press
                          if (_formKey.currentState!.validate()){
                            if(await checkPass(userController.text, passwordController.text)){
                              Navigator.pushNamed(context, '/events');
                            }
                          }
                        },
                        child: const Text('Log in'),
                      )
                    ]
                )
            ),
          )
        ),
      ),
    );
  }
}

