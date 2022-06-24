import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:rada_egerton/data/entities/chat_dto.dart';
import 'package:rada_egerton/data/services/chat_service.dart';
import 'package:rada_egerton/data/services/counseling_service.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/resources/constants.dart';
import 'package:rada_egerton/resources/utils/main.dart';

class ChatRepository {
  List<ChatPayload>? _forumnchats;
  List<ChatPayload>? _groupchats;
  List<ChatPayload>? _privatechats;
  late Channel privateChannel;
  late PusherClient _pusher;
  final String _privateChannelName = "radaComms";
  final _forumnChatControler = StreamController<ChatPayload>.broadcast();
  final _groupChatControler = StreamController<ChatPayload>.broadcast();
  final _privateChatControler = StreamController<ChatPayload>.broadcast();

  ChatRepository() {
    //TODO: create group and forumn channels
    initChats();
    _pusher = Pusher(
      appKey: GlobalConfig.instance.pusherApiKey,
      token: GlobalConfig.instance.authToken,
    ).getConnection();

    privateChannel = _pusher.subscribe(
      "$_privateChannelName${GlobalConfig.instance.user.id}",
    );

    privateChannel.bind(ChatEvent.CHAT, (PusherEvent? event) {
      //TODO:to do call _privateChatReceived
    });
  }

  Stream<ChatPayload> get groupChatStream async* {
    yield* _groupChatControler.stream.asBroadcastStream();
  }

  Stream<ChatPayload> get forumnChatStream async* {
    yield* _forumnChatControler.stream.asBroadcastStream();
  }

  Stream<ChatPayload> get privateChatStream async* {
    yield* _privateChatControler.stream.asBroadcastStream();
  }

  List<ChatPayload> get forumnchat => _forumnchats ?? [];
  List<ChatPayload> get groupchat => _groupchats ?? [];
  List<ChatPayload> get privatechat => _privatechats ?? [];

  Future<Either<InfoMessage, ErrorMessage>> initChats() async {
    if (_forumnchats != null) {
      try {
        final res = await ChatService.fetchUserMsgs();
        res.fold(
          (chats) {
            //TODO initialize
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

  Future<Either<ChatPayload, InfoMessage>> sendForumnChat(
      ChatPayload chat) async {
    //TODO:call send forumnchat service, update forumn chats and event to forumn
    //chatStream
    throw UnimplementedError();
  }

  Future<Either<ChatPayload, InfoMessage>> sendGroupChat(
      ChatPayload chat) async {
    //TODO:call send groupchat service, update forumn chats and event to group
    //chatStream
    throw UnimplementedError();
  }

  Future<Either<ChatPayload, InfoMessage>> sendPrivateChat(
      ChatPayload chat) async {
    //TODO:call send forumnchat  service, update forumn chats and event to forumn
    //chatStream
    throw UnimplementedError();
  }

  void _forumnChatReceived(ChatPayload chat) {
    _forumnchats ??= [];
    _forumnchats!.add(chat);
    _forumnChatControler.add(chat);
  }

  void _groupChatReceived(ChatPayload chat) {
    _groupchats ??= [];
    _groupchats!.add(chat);
    _groupChatControler.add(chat);
  }

  void _privateChatReceived(ChatPayload chat) {
    _privatechats ??= [];
    _privatechats!.add(chat);
    _privateChatControler.add(chat);
  }

  Future<Either<InfoMessage, ErrorMessage>> leaveForumn(String forumnId) async {
    return await leaveGroup(forumnId);
  }

  Future<Either<InfoMessage, ErrorMessage>> leaveGroup(String groupId) async {
    try {
      final result = await CounselingService.exitGroup(groupId);
      result.fold(
        (_) {},
        (error) => throw (error),
      );
      return Left(
        InfoMessage("You have left the group", MessageType.success),
      );
    } on ErrorMessage catch (e) {
      return Right(e);
    }
  }

  void dispose() {
    _forumnChatControler.close();
    _privateChatControler.close();
    _groupChatControler.close();
  }
}
