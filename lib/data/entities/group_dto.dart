import 'package:equatable/equatable.dart';

class GroupDTO extends Equatable {
  @override
  List<Object?> get props => [id, title, image, isForum];
  final String id;
  final String title;
  final String image;
  final bool isForum;
  const GroupDTO({
    required this.id,
    required this.title,
    required this.image,
    this.isForum = false,
  });
  factory GroupDTO.fromJson(Map<String, dynamic> json) => GroupDTO(
        id: json["id"].toString(),
        title: json["title"],
        image: json["image"],
        isForum: json["forum"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "image": image,
        "forum": isForum,
      };
}
