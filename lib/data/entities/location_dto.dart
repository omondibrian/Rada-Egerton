import 'dart:convert';

import 'package:equatable/equatable.dart';

class Location extends Equatable {
  Location({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.campusesId,
    required this.universityId,
  });

  int id;
  String name;
  double latitude;
  double longitude;
  int campusesId;
  int universityId;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        id: json["_id"] as int,
        name: json["name"],
        latitude: json["latitude"] as double,
        longitude: json["longitude"] as double,
        campusesId: json["Campuses_id"] as int,
        universityId: json["University_id"] as int,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "latitude": latitude,
        "longitude": longitude,
        "Campuses_id": campusesId,
        "University_id": universityId,
      };

  @override
  List<Object?> get props => [
        latitude,
        longitude,
        campusesId,
        universityId,
      ];
}
