import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:rada_egerton/data/database/sqlite.dart';
import 'package:rada_egerton/resources/config.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));
String userToJson(User data) => json.encode(data.toMap());

class User extends Equatable {
  const User({
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

  final int id;
  final String name;
  final String email;
  final String _profileImage;
  final String? gender;
  final String? phone;
  final String? dob;
  final String? status;
  final String? accountStatus;
  final String? synced;
  final String? joined;

  ///absolute path
  String get profilePic {
    if (_profileImage.isNotEmpty) {
      return imageUrl(_profileImage);
    }
    return GlobalConfig.userAvi;
  }

  factory User.empty() => User(email: "", id: -1, profileImage: "", name: "");

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

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? gender,
    String? phone,
    String? dob,
    String? profilePic,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      accountStatus: accountStatus,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      phone: phone ?? this.phone,
      joined: joined,
      profileImage: profilePic ?? this.profilePic,
      status: status,
      synced: synced,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        _profileImage,
        gender,
        phone,
        dob,
        joined,
      ];
}
