import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget(
      {super.key,
      required this.controller,
      required this.label,
      this.isObscure = false});
  final TextEditingController controller;
  final String label;
  final bool isObscure;
  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isObscure,
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: label,
      ),
    );
  }
}
