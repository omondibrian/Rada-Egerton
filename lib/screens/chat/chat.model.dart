import 'dart:convert';

import 'dart:io';

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
      {required this.authorName,
      required this.content,
      this.id,
      this.media,
      this.picture,
      this.video});

  String? id;
  String authorName;
  String content;
  String? media;
  //formdata
  final File? picture;
  final File? video;
  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        id: json["_id"],
        authorName: json["authorName"],
        content: json["content"],
        media: json["media"],
      );

  Map<String, dynamic> toJson() => {
        
        "authorName": authorName,
        "content": content,
       
      };
}