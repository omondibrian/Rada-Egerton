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
