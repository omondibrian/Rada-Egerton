import 'package:equatable/equatable.dart';
import 'package:rada_egerton/resources/config.dart' as config;

class News extends Equatable {
  News({
    required this.id,
    required this.title,
    required this.content,
    required this.imageName,
    required this.newsCategoriesId,
    required this.adminUsersId,
    required this.status,
    required this.createdAt,
  });
  String get date {
    String m = createdAt.month.toString().padLeft(2, "0");
    String day = createdAt.day.toString().padLeft(2, "0");
    String h = createdAt.hour.toString().padLeft(2, "0");
    String min = createdAt.minute.toString().padLeft(2, "0");
    return "${createdAt.year}-$m-$day $h:$min";
  }

  int id;
  String title;
  String content;
  String imageName;
  String newsCategoriesId;
  String adminUsersId;
  String status;
  DateTime createdAt;

  factory News.fromJson(Map<String, dynamic> json) => News(
        id: json["_id"],
        title: json["title"],
        content: json["content"],
        imageName: json["image"],
        newsCategoriesId: json["NewsCategories_id"],
        adminUsersId: json["Admin_Users_id"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  ///absulute url
  String get imageUrl => config.imageUrl(imageName);

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "content": content,
        "image": imageName,
        "NewsCategories_id": newsCategoriesId,
        "Admin_Users_id": adminUsersId,
        "status": status,
        "created_at": createdAt.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        imageName,
        newsCategoriesId,
        adminUsersId,
        status,
      ];
}
