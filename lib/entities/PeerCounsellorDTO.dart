import 'dart:convert';

PeerCounsellorDto peerCounsellorDtoFromJson(String str) => PeerCounsellorDto.fromJson(json.decode(str));

String peerCounsellorDtoToJson(PeerCounsellorDto data) => json.encode(data.toJson());

class PeerCounsellorDto {
    PeerCounsellorDto({
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
        required this.regNo,
        required this.studentId,
        required this.peerCounsellorId,
        required this.expertise,
        required this.campusesId,
    });

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
    String regNo;
    int studentId;
    int peerCounsellorId;
    String expertise;
    int campusesId;

    factory PeerCounsellorDto.fromJson(Map<String, dynamic> json) => PeerCounsellorDto(
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
        regNo: json["regNo"],
        studentId: json["student_id"],
        peerCounsellorId: json["peer_counsellorId"],
        expertise: json["expertise"],
        campusesId: json["Campuses_id"],
    );

    Map<String, dynamic> toJson() => {
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
        "regNo": regNo,
        "student_id": studentId,
        "peer_counsellorId": peerCounsellorId,
        "expertise": expertise,
        "Campuses_id": campusesId,
    };
}
