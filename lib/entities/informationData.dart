class InformationCategory {
  String name;
  String id;
  InformationCategory(this.id, this.name);
}

class InformationData {
  InformationMetadata metadata;
  List<InformationContent> content;
  InformationData({
    required this.metadata,
    required this.content,
  });
  factory InformationData.fromJson(Map<String, dynamic> json) {
    Iterable content = json["content"];
    List<InformationContent> informationContent = List<InformationContent>.from(
        content.map((item) => InformationContent.fromJson(item)));
    InformationMetadata metadata =
        InformationMetadata.fromJson(json["metadata"]);
    return InformationData(
      metadata: metadata,
      content: informationContent,
    );
  }
}

class InformationMetadata {
  String title;
  String category;
  String thumbnail;
  InformationMetadata({
    required this.title,
    required this.category,
    required this.thumbnail,
  });
  factory InformationMetadata.fromJson(Map<String, dynamic> json) {
    return InformationMetadata(
        title: json["title"],
        category: json["category"],
        thumbnail: json["thumbnail"]);
  }
}

class InformationContent {
  String? subtitle;
  List<String> bodyContent;
  String type;
  InformationContent({
    required this.subtitle,
    required this.type,
    required this.bodyContent,
  });
  factory InformationContent.fromJson(Map<String, dynamic> json) {
    return InformationContent(
        bodyContent: List<String>.from(json["bodyContent"]),
        type: json["type"],
        subtitle: json["subtitle"]);
  }
  //information type
  static String list = "0";
  static String image = "1";
  static String text = "2";
  static String title = "3";
}
