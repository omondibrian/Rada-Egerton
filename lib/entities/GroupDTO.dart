import 'package:rada_egerton/utils/sqlite.dart';

class GroupDTO extends Model {
  String id = "";
  String title = "";
  String image = "";
  static String get tableName_ => "Forum";
  GroupDTO({id, title, image}) {
    this.id = id;
    this.title = title;
    this.image = image;
  }
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
  // TODO: implement getId
  int get getId => throw UnimplementedError();

  @override
  String get tableName => "Forum";
}
