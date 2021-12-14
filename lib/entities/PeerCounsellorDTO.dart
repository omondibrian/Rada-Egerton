import 'dart:convert';

import 'package:rada_egerton/entities/UserDTO.dart';


PeerCounsellorDto peerCounsellorDtoFromJson(String str) =>
    PeerCounsellorDto.fromJson(json.decode(str));

String peerCounsellorDtoToJson(PeerCounsellorDto data) =>
    json.encode(data.toJson());

class PeerCounsellorDto {
  PeerCounsellorDto({
    required this.user,
    required this.regNo,
    required this.studentId,
    required this.peerCounsellorId,
    required this.expertise,
    required this.campusesId,
  });

  String regNo;
  int studentId;
  int peerCounsellorId;
  String expertise;
  int campusesId;
  User user;
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
    return PeerCounsellorDto(
      user: _user,
      regNo: json["regNo"],
      studentId: json["student_id"],
      peerCounsellorId: json["peer_counsellorId"],
      expertise: json["expertise"],
      campusesId: json["Campuses_id"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": user.id,
        "name": this.user.name,
        "email": this.user.email,
        "profilePic": this.user.profilePic,
        "gender": this.user.gender,
        "phone": this.user.phone,
        "dob": this.user.dob,
        "status": this.user.status,
        "account_status": this.user.accountStatus,
        "synced": this.user.synced,
        "joined": this.user.joined,
        "regNo": regNo,
        "student_id": studentId,
        "peer_counsellorId": peerCounsellorId,
        "expertise": expertise,
        "Campuses_id": campusesId,
      };
}
