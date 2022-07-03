import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:rada_egerton/data/database/sqlite.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));
String userToJson(User data) => json.encode(data.toMap());

class User extends Equatable {
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.profilePic,
    this.gender,
    this.phone,
    this.dob,
    this.status,
    this.accountStatus,
    this.synced,
    this.joined,
  });
  @override
  int get getId {
    return this.id;
  }

  int id;
  String name;
  String email;
  String profilePic;
  String? gender;
  String? phone;
  String? dob;
  String? status;
  String? accountStatus;
  String? synced;
  String? joined;

  factory User.empty() => User(email: "", id: 100001, profilePic: "", name: "");

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

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        profilePic,
        gender,
        phone,
        dob,
        status,
        accountStatus,
        synced,
        joined,
      ];
}

User userfromMap(Map<String, dynamic> user) {
  return User.fromJson(user);
}
