import 'package:rada_egerton/services/constants.dart';

class News {
  News({
    required this.id,
    required this.title,
    required this.content,
    required this.imageName,
    required this.newsCategoriesId,
    required this.adminUsersId,
    required this.status,
    required this.universityId,
  });

  int id;
  String title;
  String content;
  String imageName;
  String newsCategoriesId;
  String adminUsersId;
  String status;
  String universityId;

  factory News.fromJson(Map<String, dynamic> json) => News(
        id: json["_id"],
        title: json["title"],
        content: json["content"],
        imageName: json["image"],
        newsCategoriesId: json["NewsCategories_id"],
        adminUsersId: json["Admin_Users_id"],
        status: json["status"],
        universityId: json["University_id"],
      );
  String get imageUrl {
    return "$BASE_URL/api/v1/uploads/$imageName";
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "content": content,
        "image": imageName,
        "NewsCategories_id": newsCategoriesId,
        "Admin_Users_id": adminUsersId,
        "status": status,
        "University_id": universityId,
      };
}
