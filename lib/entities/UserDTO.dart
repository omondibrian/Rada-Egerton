import 'dart:convert';

import 'package:rada_egerton/utils/sqlite.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));
String userToJson(User data) => json.encode(data.toMap());

class User extends Model {
  static String tableName_ = "user";
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.profilePic,
    required this.gender,
    required this.phone,
    required this.dob,
    required this.status,
    required this.accountStatus,
    required this.synced,
    required this.joined,
  });
  @override
  int get getId {
    return this.id;
  }

  @override
  String get tableName {
    return User.tableName_;
  }

  int id;
  String name;
  String email;
  String profilePic;
  String gender;
  String phone;
  String dob;
  String status;
  String accountStatus;
  String synced;
  String joined;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"] is int ? json["_id"] : int.parse(json["_id"]),
        name: json["name"],
        email: json["email"],
        profilePic: json["profilePic"],
        gender: json["gender"],
        phone: json["phone"],
        dob: json["dob"],
        status: json["status"],
        accountStatus: json["account_status"],
        synced: json["synced"],
        joined: json["joined"],
      );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "name": name,
        "email": email,
        "profilePic": profilePic,
        "gender": gender,
        "phone": phone,
        "dob": dob,
        "status": status,
        "account_status": accountStatus,
        "synced": synced,
        "joined": joined,
      };
}

User userfromMap(Map<String, dynamic> _user) {
  return User.fromJson(_user);
}
