import 'package:rada_egerton/entities/UserDTO.dart';
import 'package:rada_egerton/utils/sqlite.dart';

class Counsellor extends Model {
  User user;
  final double rating;
  final bool isOnline;
  final String expertise;
  final int counsellorId;
  static String tableName_ = "Counsellor";
  Counsellor(
      {required this.user,
      required this.rating,
      required this.isOnline,
      required this.expertise,
      required this.counsellorId});
  @override
  int get getId {
    return this.counsellorId;
  }

  @override
  String get tableName {
    return Counsellor.tableName_;
  }

  factory Counsellor.fromJson(Map<String, dynamic> json) {
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
    return Counsellor(
        counsellorId: json['counsellorId'] is int
            ? json['counsellorId']
            : int.parse(json['counsellorId']),
        user: _user,
        isOnline: json['status'] == "online",
        expertise: json['expertise'],
        rating: double.parse(
          json['rating'].toString(),
        ));
  }
  Map<String, dynamic> toMap() {
    return {
      "counsellorId": this.counsellorId,
      "rating": this.rating,
      "expertise": this.expertise,
      "_id": this.user.id,
      "status": isOnline
    };
  }
}
