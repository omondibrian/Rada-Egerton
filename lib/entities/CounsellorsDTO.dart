import 'package:rada_egerton/entities/StudentDTO.dart';
import 'package:rada_egerton/entities/UserDTO.dart';

class CounsellorsDTO {
  final String name;
  final double rating;
  final bool isOnline;
  final String expertise;
  final String imgUrl;
  final String? id;

  CounsellorsDTO({
    required this.name,
    required this.rating,
    required this.isOnline,
    required this.expertise,
    required this.imgUrl,
    this.id,
  });
}

class Counselor {
  User user;
  final double rating;
  final bool isOnline;
  final String expertise;
  Counselor({
    required this.user,
    required this.rating,
    required this.isOnline,
    required this.expertise,
  });
  factory Counselor.fromJson(Map<String, dynamic> json) {
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
    return Counselor(
        user: _user,
        isOnline: json['status'] == "online",
        expertise: json['expertise'],
        rating: double.parse(
          json['rating'].toString(),
        ));
  }
}
