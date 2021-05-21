// Flutter: Existing Libraries
import 'package:flutter/material.dart';

// SplashPage StatelessWidget Class
class SplashPage extends StatelessWidget {
  // Build Method
  @override
  Widget build(BuildContext context) {
    // Returning Widgets
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              "assets/images/logos/MOLIP_Logo.jpg",
              width: 100,
              height: 100,
            ),
            Image.asset(
              "assets/images/logos/NSSA_Logo.jpg",
              width: 300,
              height: 300,
            ),
            Image.asset(
              "assets/images/logos/GIZ_Logo.jpg",
              width: 200,
              height: 200,
            ),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
