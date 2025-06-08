
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:vibe_link/main.dart';
class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Setup fade animation
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    // Start 2 second timer
    Timer(const Duration(milliseconds: 2000), () {
      _controller.forward().then((_) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 400),
            pageBuilder: (_, __, ___) => MyApp(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FadeTransition(
        opacity: Tween(begin: 1.0, end: 0.0).animate(_animation),
        child: Center(
          child: Image.asset(
            'assets/logo.jpeg', // your splash logo
            width: 200,
            height: 200,
          ),
        ),
      ),
    );
  }
}







// import 'package:flutter/material.dart';
// import 'dart:async';

// import 'package:vibe_link/main.dart';

// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Timer(Duration(seconds: 2), () {
//       Navigator.of(context).pushReplacement(
//         PageRouteBuilder(
//         pageBuilder: (context, animation, secondaryAnimation) => MyApp(),
//         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//           return FadeTransition(
//             opacity: animation,
//             child: child,
//           );
//         },
//         transitionDuration: const Duration(milliseconds: 400),
//       ),
//         // MaterialPageRoute(builder: (_) => MyApp()),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black, // Or your theme color
//       body: Center(
//         child: Image.asset(
//           'assets/logo.jpeg',
//           width: 150,
          
//         ),
//       ),
//     );
//   }
// }
