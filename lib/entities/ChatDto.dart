import 'dart:convert';

ChatDto chatDtoFromJson(String str) => ChatDto.fromJson(json.decode(str));

String chatDtoToJson(ChatDto data) => json.encode(data.toJson());

class ChatDto {
  ChatDto({
    required this.data,
  });

  Data data;

  factory ChatDto.fromJson(Map<String, dynamic> json) => ChatDto(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.payload,
    required this.msg,
  });

  Payload payload;
  String msg;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        payload: Payload.fromJson(json["payload"]),
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "payload": payload.toJson(),
        "msg": msg,
      };
}

class Payload {
  Payload({
    required this.id,
    required this.message,
    required this.imageUrl,
    required this.senderId,
    required this.groupsId,
    required this.reply,
    required this.status,
    required this.reciepient,
  });

  int id;
  String message;
  String imageUrl;
  String senderId;
  dynamic groupsId;
  dynamic reply;
  String status;
  String reciepient;

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        id: json["_id"],
        message: json["message"],
        imageUrl: json["imageUrl"],
        senderId: json["sender_id"],
        groupsId: json["Groups_id"],
        reply: json["reply"],
        status: json["status"],
        reciepient: json["reciepient"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "message": message,
        "imageUrl": imageUrl,
        "sender_id": senderId,
        "Groups_id": groupsId,
        "reply": reply,
        "status": status,
        "reciepient": reciepient,
      };
}

class ChatPayload {
  ChatPayload({
    required this.id,
    required this.message,
    required this.imageUrl,
    required this.senderId,
    required this.groupsId,
    required this.reply,
    required this.status,
    required this.reciepient,
    this.role,
  });

  int id;
  String message;
  String imageUrl;
  String senderId;
  dynamic groupsId;
  String? reply;
  String status;
  String reciepient;
  String? role;
  factory ChatPayload.fromJson(Map<String, dynamic> json) => ChatPayload(
        id: json["_id"],
        message: json["message"],
        imageUrl: json["imageUrl"],
        senderId: json["sender_id"],
        groupsId: json["Groups_id"],
        reply: json["reply"],
        status: json["status"],
        reciepient: json["reciepient"],
        role: json["user_type"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "message": message,
        "imageUrl": imageUrl,
        "sender_id": senderId,
        "Groups_id": groupsId,
        "reply": reply,
        "status": status,
        "reciepient": reciepient,
        "user_type":role,
      };
}
