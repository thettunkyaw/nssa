// Flutter: Existing Libraries
import 'package:flutter/material.dart';

// Pages
import './pages/home.page.dart';

// Main Function
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MyApp(),
  );
}

// MyApp StatelessWidget Class
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "National Skills Standards Authority",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (_) => HomePage(),
      },
    );
  }
}
