import 'package:flutter/cupertino.dart';

class Sizer {
  static getHeight({required double height, required BuildContext context}) {
    var tomultiply = height / 100;
    return MediaQuery.of(context).size.height * tomultiply;
  }

  static getWidth({required double width, required BuildContext context}) {
    var tomultiply = width / 100;
    return MediaQuery.of(context).size.width * tomultiply;
  }
}
