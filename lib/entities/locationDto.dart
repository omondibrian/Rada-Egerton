import 'dart:convert';

LocationsDto locationsDtoFromJson(String str) =>
    LocationsDto.fromJson(json.decode(str));

String locationsDtoToJson(LocationsDto data) => json.encode(data.toJson());

class LocationsDto {
  LocationsDto({
    required this.locations,
  });

  List<Location> locations;

  factory LocationsDto.fromJson(Map<String, dynamic> json) => LocationsDto(
        locations: List<Location>.from(
            json["locations"].map((x) => Location.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "locations": List<dynamic>.from(locations.map((x) => x.toJson())),
      };
}

class Location {
  Location({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.campusesId,
    required this.universityId,
  });

  String id;
  String latitude;
  String longitude;
  String campusesId;
  String universityId;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        id: json["_id"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        campusesId: json["Campuses_id"],
        universityId: json["University_id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "latitude": latitude,
        "longitude": longitude,
        "Campuses_id": campusesId,
        "University_id": universityId,
      };
}

class Contact {
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
}
