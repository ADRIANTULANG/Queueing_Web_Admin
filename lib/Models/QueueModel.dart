// To parse this JSON data, do
//
//     final queueModel = queueModelFromJson(jsonString);

import 'dart:convert';

List<QueueModel> queueModelFromJson(String str) =>
    List<QueueModel>.from(json.decode(str).map((x) => QueueModel.fromJson(x)));

String queueModelToJson(List<QueueModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class QueueModel {
  QueueModel({
    required this.id,
    required this.customerId,
    required this.queueType,
    required this.dateCreated,
    required this.status,
    required this.firstname,
    required this.lastname,
    required this.age,
    required this.address,
    required this.image,
    required this.phoneno,
  });

  String id;
  String customerId;
  String queueType;
  DateTime dateCreated;
  String status;
  String firstname;
  String lastname;
  String age;
  String address;
  String image;
  String phoneno;

  factory QueueModel.fromJson(Map<String, dynamic> json) => QueueModel(
        id: json["id"],
        customerId: json["customer_id"],
        queueType: json["queue_type"],
        dateCreated: DateTime.parse(json["date_created"]),
        status: json["status"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        age: json["age"],
        address: json["address"],
        image: json["image"],
        phoneno: json["phoneno"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "queue_type": queueType,
        "date_created": dateCreated.toIso8601String(),
        "status": status,
        "firstname": firstname,
        "lastname": lastname,
        "age": age,
        "address": address,
        "image": image,
        "phoneno": phoneno,
      };
}
