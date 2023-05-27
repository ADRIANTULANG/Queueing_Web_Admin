// To parse this JSON data, do
//
//     final usermodel = usermodelFromJson(jsonString);

import 'dart:convert';

List<Usermodel> usermodelFromJson(String str) =>
    List<Usermodel>.from(json.decode(str).map((x) => Usermodel.fromJson(x)));

String usermodelToJson(List<Usermodel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Usermodel {
  Usermodel({
    required this.adminId,
    required this.username,
    required this.password,
    required this.firstname,
    required this.lastname,
  });

  String adminId;
  String username;
  String password;
  String firstname;
  String lastname;

  factory Usermodel.fromJson(Map<String, dynamic> json) => Usermodel(
        adminId: json["admin_id"],
        username: json["username"],
        password: json["password"],
        firstname: json["firstname"],
        lastname: json["lastname"],
      );

  Map<String, dynamic> toJson() => {
        "admin_id": adminId,
        "username": username,
        "password": password,
        "firstname": firstname,
        "lastname": lastname,
      };
}
