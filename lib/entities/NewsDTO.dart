import 'dart:convert';

NewsDto newsDtoFromJson(String str) => NewsDto.fromJson(json.decode(str));

String newsDtoToJson(NewsDto data) => json.encode(data.toJson());

class NewsDto {
    NewsDto({
      required  this.news,
    });

    List<News> news;

    factory NewsDto.fromJson(Map<String, dynamic> json) => NewsDto(
        news: List<News>.from(json["news"].map((x) => News.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "news": List<dynamic>.from(news.map((x) => x.toJson())),
    };
}

class News {
    News({
       required this.id,
       required this.title,
       required this.content,
       required this.image,
       required this.newsCategoriesId,
       required this.adminUsersId,
       required this.status,
       required this.universityId,
    });

    int id;
    String title;
    String content;
    String image;
    String newsCategoriesId;
    String adminUsersId;
    String status;
    String universityId;

    factory News.fromJson(Map<String, dynamic> json) => News(
        id: json["_id"],
        title: json["title"],
        content: json["content"],
        image: json["image"],
        newsCategoriesId: json["NewsCategories_id"],
        adminUsersId: json["Admin_Users_id"],
        status: json["status"],
        universityId: json["University_id"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "content": content,
        "image": image,
        "NewsCategories_id": newsCategoriesId,
        "Admin_Users_id": adminUsersId,
        "status": status,
        "University_id": universityId,
    };
}
