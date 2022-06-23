import 'package:rada_egerton/data/database/sqlite.dart';
import 'package:rada_egerton/data/entities/UserDTO.dart';

class Counsellor with Model {
  User user;
  final double rating;
  final bool isOnline;
  final String expertise;
  final int counsellorId;

  Counsellor(
      {required this.user,
      required this.rating,
      required this.isOnline,
      required this.expertise,
      required this.counsellorId});
  @override
  int get getId {
    return counsellorId;
  }

  factory Counsellor.fromJson(Map<String, dynamic> json) {
    User user = User(
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
    return Counsellor(
        counsellorId: json['counsellorId'] is int
            ? json['counsellorId']
            : int.parse(json['counsellorId']),
        user: user,
        isOnline: json['status'] == "online",
        expertise: json['expertise'],
        rating: double.parse(
          json['rating'].toString(),
        ));
  }
  @override
  Map<String, dynamic> toMap() {
    return {
      "counsellorId": counsellorId,
      "rating": rating,
      "expertise": expertise,
      "_id": user.id,
      "status": isOnline
    };
  }
}
