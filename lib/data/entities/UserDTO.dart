import 'dart:convert';

import 'package:rada_egerton/data/database/sqlite.dart';
import 'package:rada_egerton/resources/config.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));
String userToJson(User data) => json.encode(data.toMap());

class User with Model {
  User({
    required this.id,
    required this.name,
    required this.email,
    String profileImage = "",
    this.gender,
    this.phone,
    this.dob,
    this.status,
    this.accountStatus,
    this.synced,
    this.joined,
  }) : _profileImage = profileImage;
  @override
  int get getId {
    return id;
  }

  int id;
  String name;
  String email;
  String _profileImage;
  String? gender;
  String? phone;
  String? dob;
  String? status;
  String? accountStatus;
  String? synced;
  String? joined;

  String get profilePic {
    if (profilePic.isNotEmpty) {
      return _profileImage;
    }
    return GlobalConfig.userAvi;
  }

  factory User.empty() =>
      User(email: "", id: -1, profileImage: "", name: "");

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"] is int ? json["_id"] : int.parse(json["_id"]),
        name: json["name"],
        email: json["email"],
        profileImage: json["profilePic"],
        gender: json["gender"],
        phone: json["phone"],
        dob: json["dob"],
        status: json["status"],
        accountStatus: json["account_status"],
        synced: json["synced"],
        joined: json["joined"],
      );

  @override
  Map<String, dynamic> toMap() => {
        "_id": id,
        "name": name,
        "email": email,
        "profileImage": _profileImage,
        "gender": gender,
        "phone": phone,
        "dob": dob,
        "status": status,
        "account_status": accountStatus,
        "synced": synced,
        "joined": joined,
      };
}

User userfromMap(Map<String, dynamic> user) {
  return User.fromJson(user);
}
