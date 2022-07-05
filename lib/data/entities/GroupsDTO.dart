import 'dart:convert';

import 'package:equatable/equatable.dart';

GroupsDto groupsDtoFromJson(String str) => GroupsDto.fromJson(json.decode(str));

String groupsDtoToJson(GroupsDto data) => json.encode(data.toJson());

class GroupsDto extends Equatable {
  GroupsDto({
    required this.data,
  });

  Data data;

  factory GroupsDto.fromJson(Map<String, dynamic> json) => GroupsDto(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };

  @override
  List<Object?> get props => [data];
}

class Data extends Equatable {
  Data({
    required this.payload,
    required this.msg,
  });

  List<Payload> payload;
  String msg;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        payload:
            List<Payload>.from(json["payload"].map((x) => Payload.fromJson(x))),
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "payload": List<dynamic>.from(payload.map((x) => x.toJson())),
        "msg": msg,
      };

  @override
  List<Object?> get props => [msg];
}

class Payload extends Equatable {
  Payload({
    required this.id,
    required this.title,
    required this.image,
  });

  int id;
  String title;
  String image;

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        id: json["id"],
        title: json["title"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
      };

  @override
  List<Object?> get props => [
        id,
        title,
        image,
      ];
}
