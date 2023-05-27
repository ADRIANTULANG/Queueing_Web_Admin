import 'package:flutter/material.dart';

import '../Services/Sizer.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget(
      {super.key,
      required this.labelText,
      required this.onPressFunction,
      this.colors = Colors.lightBlue});
  final String labelText;
  final Function onPressFunction;
  final Color colors;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPressFunction();
      },
      child: Container(
        height: Sizer.getHeight(height: 5, context: context),
        width: Sizer.getWidth(width: 100, context: context),
        decoration: BoxDecoration(
            color: colors,
            border: Border.all(color: Colors.black, width: .5),
            borderRadius: BorderRadius.circular(12)),
        alignment: Alignment.center,
        child: Text(
          labelText,
          style: TextStyle(
              fontWeight: FontWeight.normal, color: Colors.white, fontSize: 13),
        ),
      ),
    );
  }
}
