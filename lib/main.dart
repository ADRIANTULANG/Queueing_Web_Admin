import 'package:flutter/material.dart';
import 'package:queueing_system_web/pages/Homepage.dart';
import 'package:queueing_system_web/pages/Splashscreenpage.dart';
import 'package:queueing_system_web/pages/Loginpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Queueing Sytem',
      initialRoute: "/",
      routes: {
        "/": (context) => SplashScreenPage(),
        "/Loginpage": (context) => Loginpage(),
        "/Homepage": (context) => Homepage(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
