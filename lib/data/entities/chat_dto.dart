import 'dart:convert';

import 'package:equatable/equatable.dart';

enum ChatType { peer, group, forum }

class ChatPayload extends Equatable {
  const ChatPayload({
    this.id,
    required this.message,
    this.imageUrl,
    required this.senderId,
    this.groupsId,
    this.reply,
    this.status = "",
    this.recipient,
    this.role,
    this.picture,
    this.video,
  });

  final int? id;
  final String message;
  final String? imageUrl;
  final String? senderId;
  final dynamic groupsId;
  final String? reply;
  final String? status;
  final String? recipient;
  final String? role;
  // final String? media;
  //formdata
  final String? picture;
  final String? video;

  factory ChatPayload.fromJson(Map<String, dynamic> json) => ChatPayload(
        id: json["_id"],
        message: json["message"],
        imageUrl: json["imageUrl"]?.isEmpty ? null : json["imageUrl"],
        senderId: json["sender_id"],
        groupsId: json["Groups_id"],
        reply: json["reply"],
        status: json["status"],
        recipient: json["reciepient"],
        role: json["user_type"],
      );
  ChatPayload copyWith(
      {int? id,
      String? message,
      String? imageUrl,
      String? senderId,
      dynamic groupsId,
      String? reply,
      String? status,
      String? recipient,
      String? role,
      String? video,
      String? picture}) {
    return ChatPayload(
      id: id ?? this.id,
      message: message ?? this.message,
      imageUrl: imageUrl ?? this.imageUrl,
      senderId: senderId ?? this.senderId,
      groupsId: groupsId,
      reply: reply ?? this.reply,
      status: status ?? this.status,
      recipient: recipient ?? this.recipient,
      video: video ?? this.video,
      picture: picture ?? this.picture,
    );
  }

  Map<String, dynamic> toMap() => {
        "_id": id,
        "message": message,
        "imageUrl": imageUrl,
        "sender_id": senderId,
        "Groups_id": groupsId,
        "reply": reply,
        "status": status,
        "reciepient": recipient,
        "user_type": role,
      };
  @override
  String toString() {
    return jsonEncode(toMap());
  }
  @override
  List<Object?> get props => [
        id,
        message,
        imageUrl,
        senderId,
        groupsId,
        recipient,
        role,
        reply,
        status,
        picture,
        video
      ];
}
