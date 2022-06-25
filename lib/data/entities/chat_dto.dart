import 'dart:io';

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
    this.reciepient,
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
  final String status;
  final String? reciepient;
  final String? role;
  // final String? media;
  //formdata
  final File? picture;
  final File? video;

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
  ChatPayload copyWith(
      {int? id,
      String? message,
      String? imageUrl,
      String? senderId,
      dynamic groupsId,
      String? reply,
      String? status,
      String? reciepient,
      String? role,
      File? video,
      File? picture}) {
    return ChatPayload(
      id: id ?? this.id,
      message: message ?? this.message,
      imageUrl: imageUrl ?? this.imageUrl,
      senderId: senderId ?? this.senderId,
      groupsId: groupsId,
      reply: reply ?? this.reply,
      status: status ?? this.status,
      reciepient: reciepient ?? this.reciepient,
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
        "reciepient": reciepient,
        "user_type": role,
      };

  @override
  List<Object?> get props => [
        id,
        message,
        imageUrl,
        senderId,
        groupsId,
        reciepient,
        role,
        reply,
        status
      ];
}

class Chats extends Equatable {
  final List<ChatPayload> peerMsgs;
  final List<ChatPayload> forumMsgs;
  final List<ChatPayload> groupMsgs;
  @override
  List<Object?> get props => [peerMsgs, forumMsgs, groupMsgs];

  const Chats({
    this.peerMsgs = const [],
    this.groupMsgs = const [],
    this.forumMsgs = const [],
  });

  Chats copyWith({
    List<ChatPayload>? peerMsgs,
    List<ChatPayload>? forumMsgs,
    List<ChatPayload>? groupMsgs,
  }) {
    return Chats(
      forumMsgs: forumMsgs ?? this.forumMsgs,
      peerMsgs: peerMsgs ?? this.peerMsgs,
      groupMsgs: groupMsgs ?? this.peerMsgs,
    );
  }
}
