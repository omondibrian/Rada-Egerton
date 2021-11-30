import 'dart:convert';

ContactsDto contactsDtoFromJson(String str) => ContactsDto.fromJson(json.decode(str));

String contactsDtoToJson(ContactsDto data) => json.encode(data.toJson());

class ContactsDto {
    ContactsDto({
        required this.contacts,
    });

    List<Contact> contacts;

    factory ContactsDto.fromJson(Map<String, dynamic> json) => ContactsDto(
        contacts: List<Contact>.from(json["contacts"].map((x) => Contact.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "contacts": List<dynamic>.from(contacts.map((x) => x.toJson())),
    };
}

class Contact {
    Contact({
        required this.id,
        required this.name,
        required this.email,
        required this.phone,
        required this.campusesId,
        required this.universityId,
    });

    int id;
    String name;
    String email;
    String phone;
    String campusesId;
    String universityId;

    factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        campusesId: json["Campuses_id"],
        universityId: json["University_id"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "Campuses_id": campusesId,
        "University_id": universityId,
    };
}
