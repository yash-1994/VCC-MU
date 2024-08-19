import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vcc_app/Screens/HomePage/MenuScreen.dart';
import 'dart:convert';

import '../../global.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _downloadLink =
      "https://www.google.co.in/"; // Replace with actual link
  bool _isLoggedIn = false;
  String _errorMessage = '';

  void _login() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    pri("---- USERNAME: ${username} PASSWORD: ${password} ------------");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );

    // // Replace with your API endpoint
    // final String apiUrl = 'http://your-api-endpoint.com/login';
    //
    // try {
    //   final response = await http.post(
    //     Uri.parse(apiUrl),
    //     headers: <String, String>{
    //       'Content-Type': 'application/json; charset=UTF-8',
    //     },
    //     body: jsonEncode(<String, String>{
    //       'username': username,
    //       'password': password,
    //     }),
    //   );
    //
    //   if (response.statusCode == 200) {
    //     // Successful login
    //     Map<String, dynamic> responseData = jsonDecode(response.body);
    //     String loginPermission = responseData['loginPermission'];
    //
    //     if (loginPermission == 'Yes') {
    //       setState(() {
    //         _isLoggedIn = true;
    //         _errorMessage = '';
    //       });
    //
    //       // Navigate to menu screen or perform actions accordingly
    //       Navigator.pushReplacementNamed(
    //           context, '/menu'); // Replace with actual route
    //     } else {
    //       setState(() {
    //         _isLoggedIn = false;
    //         _errorMessage = 'You are not authorized.';
    //       });
    //     }
    //   } else {
    //     // Failed to login
    //     setState(() {
    //       _isLoggedIn = false;
    //       _errorMessage = 'Failed to login.';
    //     });
    //   }
    // } catch (e) {
    //   print('Error: $e');
    //   setState(() {
    //     _isLoggedIn = false;
    //     _errorMessage = 'Error occurred. Please try again.';
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            SizedBox(height: 8.0),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: 24.0),
            GestureDetector(
              onTap: () {
                // Open download link in browser
                //launch(_downloadLink); // Ensure to import 'package:url_launcher/url_launcher.dart';
                pri("------------- LUNCH URL ---------------");
              },
              child: Text(
                'Download App',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
