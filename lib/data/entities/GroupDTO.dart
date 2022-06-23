import 'package:rada_egerton/data/database/sqlite.dart';

class GroupDTO with Model {
  String id;
  String title;
  String image;
  static String get tableName_ => "Forum";
  GroupDTO({
    required this.id,
    required this.title,
    required this.image,
  });
  factory GroupDTO.fromJson(Map<String, dynamic> json) => GroupDTO(
        id: json["id"].toString(),
        title: json["title"],
        image: json["image"],
      );

  @override
  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "image": image,
      };

  @override
  int get getId => int.parse(id);
}
