import 'dart:convert';

class LocationsDto {
  LocationsDto({
    required this.locations,
  });

  LocationsDto locationsDtoFromJson(String str) =>
      LocationsDto.fromJson(json.decode(str));

  String locationsDtoToJson(LocationsDto data) => json.encode(data.toJson());

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
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.campusesId,
    required this.universityId,
  });

  String id;
  String name;
  String latitude;
  String longitude;
  String campusesId;
  String universityId;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        id: json["_id"],
        name: json["name"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        campusesId: json["Campuses_id"],
        universityId: json["University_id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "latitude": latitude,
        "longitude": longitude,
        "Campuses_id": campusesId,
        "University_id": universityId,
      };
}
