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
  List<ChatPayload>? _forumchats;
  List<ChatPayload>? _groupchats;
  List<ChatPayload>? _privatechats;
  late Channel privateChannel;
  late PusherClient _pusher;
  final String _privateChannelName = "radaComms";
  final _forumChatControler = StreamController<ChatPayload>.broadcast();
  final _groupChatControler = StreamController<ChatPayload>.broadcast();
  final _privateChatControler = StreamController<ChatPayload>.broadcast();

  ChatRepository() {
    //TODO: create group and forum channels
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

  Stream<ChatPayload> get forumChatStream async* {
    yield* _forumChatControler.stream.asBroadcastStream();
  }

  Stream<ChatPayload> get privateChatStream async* {
    yield* _privateChatControler.stream.asBroadcastStream();
  }

  List<ChatPayload> get forumchat => _forumchats ?? [];
  List<ChatPayload> get groupchat => _groupchats ?? [];
  List<ChatPayload> get privatechat => _privatechats ?? [];

  Future<Either<InfoMessage, ErrorMessage>> initChats() async {
    if (_forumchats != null) {
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

  Future<Either<ChatPayload, InfoMessage>> sendForumChat(
      ChatPayload chat) async {
    //TODO:call send forumchat service, update forum chats and event to forum
    //chatStream
    throw UnimplementedError();
  }

  Future<Either<ChatPayload, InfoMessage>> sendGroupChat(
      ChatPayload chat) async {
    //TODO:call send groupchat service, update forum chats and event to group
    //chatStream
    throw UnimplementedError();
  }

  Future<Either<ChatPayload, InfoMessage>> sendPrivateChat(
      ChatPayload chat) async {
    //TODO:call send forumchat  service, update forum chats and event to forum
    //chatStream
    throw UnimplementedError();
  }

  void _forumChatReceived(ChatPayload chat) {
    _forumchats ??= [];
    _forumchats!.add(chat);
    _forumChatControler.add(chat);
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

  

  void dispose() {
    _forumChatControler.close();
    _privateChatControler.close();
    _groupChatControler.close();
  }
}
