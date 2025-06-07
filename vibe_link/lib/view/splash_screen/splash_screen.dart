import 'package:flutter/material.dart';
import 'dart:async';

import 'package:vibe_link/main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => MyApp()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Or your theme color
      body: Center(
        child: Image.asset(
          'assets/logo.jpeg',
          width: 150,
          
        ),
      ),
    );
  }
}
