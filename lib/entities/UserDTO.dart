
import 'dart:convert';

UserDTO userDtoFromJson(String str) => UserDTO.fromJson(json.decode(str));

String userDtoToJson(UserDTO data) => json.encode(data.toJson());

class UserDTO {
  String email = "";
  String userName = "";
  String phone = "";
  String profilePic = "";
  String dob = "";
  String id = "";
  String gender = "";
  String status;
  String accountStatus;
  String synced;
  String joined;

  UserDTO({
    required this.id,
    required name,
    required this.email,
    required this.profilePic,
    required this.gender,
    required this.phone,
    required this.dob,
    required this.status,
    required this.accountStatus,
    required this.synced,
    required this.joined,
  }) {
    this.userName = name;
  }

  // factory UserDTO.defaultDTO() {
  //   return UserDTO(
  //     email: '',
  //     dob: '',
  //     id: '',
  //     userName: '',
  //     phone: '',
  //     profilePic: '',
  //     gender: '',
  //       this.phone,
  //    this.dob,
  //    this.status,
  //    this.accountStatus,
  //    this.synced,
  //    this.joined,
  //   );
  // }

  factory UserDTO.fromJson(Map<String, dynamic> json) => UserDTO(
       
        id: json["_id"].toString(),
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

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": userName,
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


