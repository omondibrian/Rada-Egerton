import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rada_egerton/data/entities/chat_dto.dart';
import 'package:rada_egerton/data/providers/authentication_provider.dart';
import 'package:rada_egerton/data/rest/client.dart';
import 'package:rada_egerton/resources/audio_players.dart';
import 'package:rada_egerton/resources/utils/main.dart';

class ChatRepository {
  List<ChatPayload>? _groupchats;
  List<ChatPayload>? _privatechats;
  bool chatsInitialized = false;

  final _groupChatControler = StreamController<ChatPayload>.broadcast();
  final _privateChatControler = StreamController<ChatPayload>.broadcast();

  ChatRepository() {
    initChats();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _chatReceived(message.data);
    });
    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
      _chatReceived(message.data);
    });
  }

  Stream<ChatPayload> get groupChatStream async* {
    yield* _groupChatControler.stream.asBroadcastStream();
  }

  Stream<ChatPayload> get privateChatStream async* {
    yield* _privateChatControler.stream.asBroadcastStream();
  }

  // List<ChatPayload> get forumchat => _forumchats ?? [];
  List<ChatPayload> get groupchat => _groupchats ?? [];
  List<ChatPayload> get privatechat => _privatechats ?? [];

  Future refresh() async {
    final res = await Client.chat.chats();
    res.fold(
      (chats) {
        _privatechats = chats["privateChats"];
        _groupchats = chats["groupChats"];
        chatsInitialized = true;
      },
      (errorMessage) => null,
    );
  }

  Future<Either<InfoMessage, ErrorMessage>> initChats() async {
    if (!chatsInitialized) {
      try {
        final res = await Client.chat.chats();
        res.fold(
          (chats) {
            _privatechats = chats["privateChats"];
            _groupchats = chats["groupChats"];
            chatsInitialized = true;
          },
          (errorMessage) => throw (errorMessage),
        );
      } on ErrorMessage catch (e) {
        return Right(e);
      }
    }
    return Left(
      InfoMessage("Chats already fetched", MessageType.success),
    );
  }

  Future<Either<ChatPayload, ErrorMessage>> sendGroupChat({
    required String message,
    required String groupId,
    String? reply,
    required String senderId,
    File? picture,
    File? video,
    Function(String)? retryLog,
  }) async {
    Map<String, dynamic> data = {
      'message': message,
      'sender_id': senderId,
      "groupId": groupId,
      "reply": reply,
      "status": "0",
      // "receipient": "",
    };

    if (picture != null) {
      data["image"] = await MultipartFile.fromFile(
        picture.path,
        filename: picture.path.split("/").last,
      );
    }
    final res = await Client.chat.sendGroupChat(
      FormData.fromMap(data),
      retryLog,
    );
    res.fold(
      (chat_) {
        NotificationAudio.messageSend();
        _groupchats ??= [];
        _groupchats!.add(chat_);
      },
      (err) => {},
    );
    return res;
  }

  Future<Either<ChatPayload, ErrorMessage>> sendPrivateChat({
    required String message,
    required String recipientId,
    String? reply,
    required String senderId,
    File? picture,
    File? video,
    Function(String)? retryLog,
  }) async {
    Map<String, dynamic> data = {
      'message': message,
      'sender_id': senderId,
      "receipient": recipientId,
      "reply": reply,
      "status": "0",
      //TODO:Remove userType
      "user_type": "counsellor"
    };

    if (picture != null) {
      data["image"] = await MultipartFile.fromFile(
        picture.path,
        filename: picture.path.split("/").last,
      );
    }

    FormData formData = FormData.fromMap(data);
    final res = await Client.chat.sendPrivateChat(formData, retryLog);
    res.fold(
      (chat_) {
        NotificationAudio.messageSend();
        _privatechats ??= [];
        _privatechats!.add(chat_);
      },
      (err) => null,
    );
    return res;
  }

  _chatReceived(Map<String, dynamic> chatData) {
    try {
      ChatPayload chat = ChatPayload(
        id: int.parse(chatData["_id"].toString()),
        message: chatData["message"],
        imageUrl: chatData["imageUrl"]?.isEmpty ? null : chatData["imageUrl"],
        senderId: chatData["sender_id"],
        groupsId: chatData["Groups_id"],
        reply: chatData["reply"],
        status: chatData["status"],
        recipient: chatData["reciepient"],
        role: chatData["user_type"],
        createdAt: DateTime.parse(chatData["created_at"]),
      );
      if (chat.groupsId != null && chat.groupsId.toString().isNotEmpty) {
        if (chat.senderId ==
            AuthenticationProvider.instance.user.id.toString()) {
          return;
        }
        _groupchats ??= [];
        _groupchats!.add(chat);
        _groupChatControler.add(chat);
      } else {
        _privatechats ??= [];
        _privatechats!.add(chat);
        _privateChatControler.add(chat);
      }
    } catch (e) {
      print(e);
    }
  }

  ChatPayload? lastPrivateChat(String userId) {
    for (var i = privatechat.length - 1; i >= 0; --i) {
      if (privatechat[i].recipient == userId ||
          privatechat[i].senderId == userId) {
        return privatechat[i];
      }
    }
    return null;
  }

  ChatPayload? lastGroupChat(String groupId) {
    for (var i = groupchat.length - 1; i >= 0; --i) {
      if (groupchat[i].groupsId == groupId) {
        return groupchat[i];
      }
    }
    return null;
  }

  dispose() {
    _privateChatControler.close();
    _groupChatControler.close();
  }
}
