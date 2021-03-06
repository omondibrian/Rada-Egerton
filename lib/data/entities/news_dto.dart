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
  });

  int id;
  String title;
  String content;
  String imageName;
  String newsCategoriesId;
  String adminUsersId;
  String status;

  factory News.fromJson(Map<String, dynamic> json) => News(
        id: json["_id"],
        title: json["title"],
        content: json["content"],
        imageName: json["image"],
        newsCategoriesId: json["NewsCategories_id"],
        adminUsersId: json["Admin_Users_id"],
        status: json["status"],
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
