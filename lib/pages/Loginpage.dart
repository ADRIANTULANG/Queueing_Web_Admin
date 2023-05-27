import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:queueing_system_web/widgets/ButttonWidget.dart';
import 'package:queueing_system_web/widgets/TextFieldWidget.dart';
import 'package:http/http.dart' as http;
import '../Models/Usermodel.dart';
import '../Services/Sizer.dart';
import '../config/Endpoint.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  final box = GetStorage();

  login() async {
    List<Usermodel> userModel = <Usermodel>[];
    try {
      var url = Uri.parse("${AppEndpoint.endPointDomain}/login-web.php");
      var response = await http.post(url,
          body: {'username': username.text, 'password': password.text});

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['data'];

        if (data.length == 0 || data.isEmpty) {
        } else {
          print(jsonEncode(data));
        }
        var modeledData = await usermodelFromJson(jsonEncode(data));
        userModel = modeledData;
        box.write("id", userModel[0].adminId);
        box.write("username", userModel[0].username);
        box.write("password", userModel[0].password);
        box.write("firstname", userModel[0].firstname);
        box.write("lastname", userModel[0].lastname);

        Navigator.pushNamedAndRemoveUntil(
            context, "/Homepage", (route) => false);
      } else {}
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          SizedBox(
            height: Sizer.getHeight(height: 15, context: context),
          ),
          Container(
            padding: EdgeInsets.only(
                left: Sizer.getWidth(width: 35, context: context),
                right: Sizer.getWidth(width: 35, context: context)),
            child: Image.asset("assets/image/logo1.png"),
          ),
          SizedBox(
            height: Sizer.getHeight(height: 5, context: context),
          ),
          Container(
              padding: EdgeInsets.only(
                  left: Sizer.getWidth(width: 35, context: context),
                  right: Sizer.getWidth(width: 35, context: context)),
              child: TextFieldWidget(controller: username, label: "Username")),
          SizedBox(
            height: Sizer.getHeight(height: 4, context: context),
          ),
          Container(
              padding: EdgeInsets.only(
                  left: Sizer.getWidth(width: 35, context: context),
                  right: Sizer.getWidth(width: 35, context: context)),
              child: TextFieldWidget(
                controller: password,
                label: "Password",
                isObscure: true,
              )),
          SizedBox(
            height: Sizer.getHeight(height: 4, context: context),
          ),
          Container(
            padding: EdgeInsets.only(
                left: Sizer.getWidth(width: 35, context: context),
                right: Sizer.getWidth(width: 35, context: context)),
            child: ButtonWidget(labelText: "LOGIN", onPressFunction: login),
          )
        ],
      )),
    );
  }
}
