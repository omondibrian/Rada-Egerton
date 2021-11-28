

import 'dart:convert';

UserChatDto userChatDtoFromJson(String str) =>
    UserChatDto.fromJson(json.decode(str));

String userChatDtoToJson(UserChatDto data) => json.encode(data.toJson());

class UserChatDto {
  UserChatDto({
    required this.data,
  });

  Data data;

  factory UserChatDto.fromJson(Map<String, dynamic> json) => UserChatDto(
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
    required this.peerMsgs,
    required this.groupMsgs,
    required this.forumMsgs,
  });

  List<PeerMsg> peerMsgs;
  List<Msg> groupMsgs;
  List<Msg> forumMsgs;

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        peerMsgs: List<PeerMsg>.from(
            json["peerMsgs"].map((x) => PeerMsg.fromJson(x))),
        groupMsgs:
            List<Msg>.from(json["groupMsgs"].map((x) => Msg.fromJson(x))),
        forumMsgs:
            List<Msg>.from(json["forumMsgs"].map((x) => Msg.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "peerMsgs": List<dynamic>.from(peerMsgs.map((x) => x.toJson())),
        "groupMsgs": List<dynamic>.from(groupMsgs.map((x) => x.toJson())),
        "forumMsgs": List<dynamic>.from(forumMsgs.map((x) => x.toJson())),
      };
}

class Msg {
  Msg({
    required this.info,
    required this.messages,
  });

  Info info;
  List<PeerMsg> messages;

  factory Msg.fromJson(Map<String, dynamic> json) => Msg(
        info: Info.fromJson(json["info"]),
        messages: List<PeerMsg>.from(
            json["messages"].map((x) => PeerMsg.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "info": info.toJson(),
        "messages": List<dynamic>.from(messages.map((x) => x.toJson())),
      };
}

class Info {
  Info({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.forum,
  });

  int id;
  String title;
  String description;
  String image;
  bool forum;

  factory Info.fromJson(Map<String, dynamic> json) => Info(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        image: json["image"],
        forum: json["forum"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "image": image,
        "forum": forum,
      };
}

class PeerMsg {
  PeerMsg({
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
  String groupsId;
  dynamic reply;
  String status;
  String reciepient;

  factory PeerMsg.fromJson(Map<String, dynamic> json) => PeerMsg(
        id: json["_id"],
        message: json["message"],
        imageUrl: json["imageUrl"],
        senderId: json["sender_id"],
        groupsId: json["Groups_id"] == null ? null : json["Groups_id"],
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
