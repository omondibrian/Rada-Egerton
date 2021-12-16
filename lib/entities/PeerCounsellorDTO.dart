import 'dart:convert';

import 'package:rada_egerton/entities/UserDTO.dart';
import 'package:rada_egerton/utils/sqlite.dart';

PeerCounsellorDto peerCounsellorDtoFromJson(String str) =>
    PeerCounsellorDto.fromJson(json.decode(str));

class PeerCounsellorDto extends Model {
  PeerCounsellorDto({
    required this.user,
    required this.regNo,
    required this.peerCounsellorId,
    required this.expertise,
  });
  static String tableName_ = "PeerCounsellor";
  String? regNo;
  int? studentId;
  int peerCounsellorId;
  String expertise;
  int? campusesId;
  User user;
  @override
  int get getId {
    return this.peerCounsellorId;
  }

  @override
  String get tableName {
    return PeerCounsellorDto.tableName_;
  }

  factory PeerCounsellorDto.fromJson(Map<String, dynamic> json) {
    User _user = User(
      id: json["_id"],
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
    print(json);
    print("\n\n\n");
    return PeerCounsellorDto(
      user: _user,
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
