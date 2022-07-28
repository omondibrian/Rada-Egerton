import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:rada_egerton/data/entities/chat_dto.dart';
import 'package:rada_egerton/data/providers/application_provider.dart';
import 'package:rada_egerton/data/services/chat_service.dart';
import 'package:rada_egerton/resources/audio_players.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/resources/utils/main.dart';

class ChatRepository {
  List<ChatPayload>? _groupchats;
  List<ChatPayload>? _privatechats;
  bool chatsInitialized = false;
  List<Channel> groupChannels = [];

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
    final res = await ChatService.fetchUserMsgs();
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
        final res = await ChatService.fetchUserMsgs();
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
    //chatStream
    final res = await ChatService.sendGroupChat(
      message: message,
      groupId: groupId,
      senderId: senderId,
      reply: reply,
      picture: picture,
      video: video,
      onRetry: retryLog,
    );
    late ChatPayload chat;
    ErrorMessage? info;
    res.fold(
      (chat_) {
        NotificationAudio.messageSend();
        chat = chat_;
      },
      (err) => info = err,
    );
    if (info != null) {
      return Right(info!);
    }
    _groupchats ??= [];
    _groupchats!.add(chat);
    return Left(chat);
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
    //chatStream
    final res = await ChatService.sendPrivateMessage(
      message: message,
      recipientId: recipientId,
      senderId: senderId,
      reply: reply,
      picture: picture,
      video: video,
      onRetry: retryLog,
    );
    late ChatPayload chat;
    ErrorMessage? info;
    res.fold(
      (chat_) {
        NotificationAudio.messageSend();
        chat = chat_;
      },
      (err) => info = err,
    );
    if (info != null) {
      return Right(info!);
    }
    _privatechats ??= [];
    _privatechats!.add(chat);
    return Left(chat);
  }

  _chatReceived(Map<String, dynamic> chatData) {
    try {
      ChatPayload chat = ChatPayload.fromJson(chatData);
      if (chat.groupsId != null && chat.groupsId.toString().isNotEmpty) {
        if (chat.senderId == GlobalConfig.instance.user.id.toString()) return;
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

  dispose() {
    _privateChatControler.close();
    _groupChatControler.close();
  }
}
