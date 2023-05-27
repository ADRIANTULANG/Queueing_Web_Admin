// To parse this JSON data, do
//
//     final usertypeModel = usertypeModelFromJson(jsonString);

import 'dart:convert';

List<UsertypeModel> usertypeModelFromJson(String str) =>
    List<UsertypeModel>.from(
        json.decode(str).map((x) => UsertypeModel.fromJson(x)));

String usertypeModelToJson(List<UsertypeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UsertypeModel {
  UsertypeModel({
    required this.id,
    required this.username,
    required this.password,
    required this.firstname,
    required this.lastname,
    required this.age,
    required this.address,
    required this.phoneno,
    required this.image,
    required this.usertype,
    required this.fcmToken,
  });

  String id;
  String username;
  String password;
  String firstname;
  String lastname;
  String age;
  String address;
  String phoneno;
  String image;
  String usertype;
  String fcmToken;

  factory UsertypeModel.fromJson(Map<String, dynamic> json) => UsertypeModel(
        id: json["id"],
        username: json["username"],
        password: json["password"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        age: json["age"],
        address: json["address"],
        phoneno: json["phoneno"],
        image: json["image"],
        usertype: json["usertype"],
        fcmToken: json["fcmToken"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "password": password,
        "firstname": firstname,
        "lastname": lastname,
        "age": age,
        "address": address,
        "phoneno": phoneno,
        "image": image,
        "usertype": usertype,
        "fcmToken": fcmToken,
      };
}
