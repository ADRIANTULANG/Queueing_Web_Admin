import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../Services/Sizer.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  final box = GetStorage();
  @override
  void initState() {
    navigatorMethod();
    super.initState();
  }

  navigatorMethod() async {
    Future.delayed(Duration(seconds: 3), () {
      if (box.read('id') == null) {
        Navigator.pushNamed(context, "/Loginpage");
      } else {
        Navigator.pushNamed(context, "/Homepage");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: Sizer.getHeight(height: 100, context: context),
        width: Sizer.getWidth(width: 100, context: context),
        child: Center(
          child: Image.asset("assets/image/logo1.png"),
        ));
  }
}
