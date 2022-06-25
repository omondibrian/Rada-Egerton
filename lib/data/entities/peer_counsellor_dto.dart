import 'dart:convert';

import 'package:rada_egerton/data/database/sqlite.dart';
import 'package:rada_egerton/data/entities/user_dto.dart';

PeerCounsellorDto peerCounsellorDtoFromJson(String str) =>
    PeerCounsellorDto.fromJson(json.decode(str));

class PeerCounsellorDto with Model {
  PeerCounsellorDto({
    required this.user,
    required this.regNo,
    required this.peerCounsellorId,
    required this.expertise,
  });
  String? regNo;
  int? studentId;
  int peerCounsellorId;
  String expertise;
  int? campusesId;
  User user;
  @override
  int get getId {
    return peerCounsellorId;
  }

  factory PeerCounsellorDto.fromJson(Map<String, dynamic> json) {
    User user = User(
      id: json["_id"],
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

    return PeerCounsellorDto(
      user: user,
      regNo: json["regNo"],
      peerCounsellorId: json["peer_counsellorId"] is int
          ? json["peer_counsellorId"]
          : int.parse(json["peer_counsellorId"]),
      expertise: json["expertise"],
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        "_id": user.id,
        "regNo": regNo,
        "student_id": studentId,
        "peer_counsellorId": peerCounsellorId,
        "expertise": expertise,
        "Campuses_id": campusesId,
      };
}
