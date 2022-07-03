import 'package:equatable/equatable.dart';

class Contact extends Equatable {
  int id;
  String name;
  String email;
  String phone;
  int? campusId;
  int? universityId;
  Contact(
      {required this.id,
      required this.name,
      required this.phone,
      required this.campusId,
      required this.universityId,
      required this.email});
  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
        campusId: int.parse(json["Campuses_id"]),
        id: json["_id"],
        name: json['name'],
        email: json["email"],
        phone: json["phone"],
        universityId: int.parse(json["University_id"]));
  }

  @override
  List<Object?> get props => [
        id,
        name,
        phone,
        campusId,
        universityId,
        email,
      ];
}
