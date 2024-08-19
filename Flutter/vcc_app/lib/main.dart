import 'package:flutter/material.dart';
import 'package:vcc_app/Screens/HomePage/MenuScreen.dart';
import 'dart:io' show Platform;

import 'package:vcc_app/Screens/LoginScreen/login_screen.dart';
import 'package:vcc_app/Screens/Monitoring%20Page/TempMoni.dart';

import 'Screens/VccSetup/vcc_set.dart';

bool isWindows() {
  return Platform.isWindows;
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: ResponsiveWrapper(
          child: TemperaturePage(),
        ));
  }
}

class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  ResponsiveWrapper({required this.child, this.maxWidth = 600.0});
  @override
  Widget build(BuildContext context) {
    bool isValid(BoxConstraints con) {
      if (con.maxHeight > con.maxWidth) {
        return true;
      } else {
        return con.maxHeight > 450;
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (isValid(constraints)) {
            return Center(
              child: Container(
                width: maxWidth,
                color: Colors.white,
                child: child,
              ),
            );
          } else {
            return child;
          }
        },
      ),
    );
  }
}
