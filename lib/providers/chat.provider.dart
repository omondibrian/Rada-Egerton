import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:rada_egerton/config.dart';
import 'package:rada_egerton/constants.dart';
import 'package:rada_egerton/entities/ChatDto.dart';
import 'package:rada_egerton/utils/main.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:rada_egerton/entities/ChatDto.dart' as chats;
import 'package:rada_egerton/services/auth/main.dart';
import 'package:rada_egerton/entities/UserChatsDTO.dart';
import 'package:rada_egerton/services/counseling/main.dart';

class ChatProvider with ChangeNotifier {
  late Channel channel;
  late String _userId;
  late PusherClient _pusher;

  List<chats.ChatPayload> _privateMsgs = [];
  List<Msg> _groupMsgs = [];
  List<Msg> _forumMsgs = [];
  String _channelName = "radaComms";

  CounselingServiceProvider _service = CounselingServiceProvider();

  ChatProvider() {
    init();
    getConversations();
  }
  void init() async {
    String? _autoken = await ServiceUtility.getAuthToken();
    _pusher =
        Pusher(appKey: pusherApiKey, token: _autoken ?? "").getConnection();
    var result = await AuthServiceProvider().getProfile();
    result!.fold((user) => {this._userId = user.id}, (error) => print(error));
    privateChannel();
  }

  void privateChannel() {
    this.channel = _pusher.subscribe("$_channelName$_userId");
    channel.bind(ChatEvent.CHAT, (PusherEvent? event) {
      appendNewChat(
        chats.ChatDto(
          data: chats.Data(
            msg: "",
            payload: chats.Payload.fromJson(
              jsonDecode(
                event!.data as String,
              )["chat"],
            ),
          ),
        ),
      );
      notifyListeners();
    });
  }

  List<ChatPayload> get privateMessages {
    return [...this._privateMsgs];
  }

  List<Msg> get groupMessages {
    return [...this._groupMsgs];
  }

  List<Msg> get forumMessages {
    return [...this._forumMsgs];
  }

  void getConversations() async {
    var results = await _service.fetchUserMsgs();
    results!.fold(
      (userChats) {
        this._privateMsgs =
            userChats.data.payload.peerMsgs.map(convertToChatPayload).toList();
        this._groupMsgs = userChats.data.payload.groupMsgs;
        this._forumMsgs = userChats.data.payload.forumMsgs;
      },
      (error) => print('Error from fetchChats() :${error.message}'),
    );
    notifyListeners();
  }

  ChatPayload convertToChatPayload(PeerMsg msg) => ChatPayload(
      id: msg.id,
      message: msg.message,
      imageUrl: msg.imageUrl,
      senderId: msg.senderId,
      groupsId: msg.groupsId,
      reply: msg.reply,
      status: msg.status,
      reciepient: msg.reciepient);

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    channel.unbind(ChatEvent.CHAT);
  }

  sendPeerCounselingMessage(ChatPayload chat, String userId) async {
    var service = CounselingServiceProvider();
    final result = await service.peerCounseling(chat, userId);
    result!.fold((chat) {
      appendNewChat(chat);
    }, (r) => null);
    notifyListeners();
  }

  void appendNewChat(
    ChatDto chat,
  ) {
    this._privateMsgs.add(
          ChatPayload(
            id: chat.data.payload.id,
            message: chat.data.payload.message,
            imageUrl: chat.data.payload.imageUrl,
            senderId: chat.data.payload.senderId,
            groupsId: chat.data.payload.groupsId ?? "",
            reply: chat.data.payload.reply ?? "",
            status: chat.data.payload.status,
            reciepient: chat.data.payload.reciepient,
          ),
        );
  }

  sendGroupMessage(ChatPayload chat, String userId) async {
    var service = CounselingServiceProvider();
    var result = await service.groupCounseling(chat, userId);
    result!.fold((chat) {
      this._groupMsgs.forEach(
        (group) {
          if (group.info.id == chat.data.payload.groupsId) {
            appendToGroupMessages(group, chat);
          }
        },
      );
    }, (error) => print(error.message));
  }

  void appendToGroupMessages(Msg group, ChatDto chat) {
    group.messages.add(
      PeerMsg(
        id: chat.data.payload.id,
        message: chat.data.payload.message,
        imageUrl: chat.data.payload.imageUrl,
        senderId: chat.data.payload.senderId,
        groupsId: chat.data.payload.groupsId ?? "",
        reply: chat.data.payload.reply ?? "",
        status: chat.data.payload.status,
        reciepient: chat.data.payload.reciepient,
      ),
    );
  }
}
