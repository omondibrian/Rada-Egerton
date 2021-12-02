import 'dart:convert';

import 'dart:io';

import 'package:rada_egerton/entities/UserChatsDTO.dart';

ChatModel chatModelFromJson(String str) => ChatModel.fromJson(json.decode(str));

String chatModelToJson(ChatModel data) => json.encode(data.toJson());

class ChatModel {
  ChatModel({
    required this.chat,
  });

  Chat chat;

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        chat: Chat.fromJson(json["chat"]),
      );

  Map<String, dynamic> toJson() => {
        "chat": chat.toJson(),
      };
}

class Chat {
  Chat(
      {required this.authorId,
      required this.content,
      this.id,
      this.media,
      this.picture,
      this.video});

  String? id;
  String authorId;
  String content;
  String? media;
  //formdata
  final File? picture;
  final File? video;
  factory Chat.fromJson(PeerMsg json ) => Chat(
        id: json.id.toString(),
        authorId: json.senderId,
        content: json.message,
        media: json.imageUrl,
      );

  Map<String, dynamic> toJson() => {
        
        "sender_id": authorId,
        "message": content,
       
      };
}