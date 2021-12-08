class GroupDTO {
  String id = "";
  String title = "";
  String image = "";
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

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
      };
}
