import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rada_egerton/entities/ChatDto.dart';
import 'package:rada_egerton/entities/CounsellorsDTO.dart';
import 'package:rada_egerton/entities/StudentDTO.dart';
import 'package:rada_egerton/entities/UserDTO.dart';
import 'package:rada_egerton/entities/userRoles.dart';
import 'package:rada_egerton/resources/constants.dart';
import 'package:rada_egerton/utils/main.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:rada_egerton/entities/ChatDto.dart' as chats;
import 'package:rada_egerton/services/auth/main.dart';
import 'package:rada_egerton/entities/UserChatsDTO.dart';
import 'package:rada_egerton/services/counseling/main.dart';
import 'package:rada_egerton/utils/sqlite.dart';

class ChatProvider with ChangeNotifier {
  late Channel channel;
  late String _userId;
  late PusherClient _pusher;
  InfoMessage? info;
  List<chats.ChatPayload>? _privateMsgs;
  List<Msg> _groupMsgs = [];
  List<Msg> _forumMsgs = [];
  String _channelName = "radaComms";
  UserRole userRole = UserRole([]);
  List<StudentDto> _students = [];
  CounselingServiceProvider _service = CounselingServiceProvider();
  DBManager dbManager = DBManager();

  ChatProvider() {
    init();
    getConversations();
  }
  
  get pusherApiKey => null;
  void init() async {
    String? _autoken = await ServiceUtility.getAuthToken();
    _pusher =
        Pusher(appKey: pusherApiKey, token: _autoken ?? "").getConnection();
    var result = await AuthServiceProvider().getProfile();
    result!.fold((user) async {
      this._userId = user.id.toString();
      var role = await AuthServiceProvider().getUserRoles(user.id.toString());
      role.fold((_userRole) => {userRole = _userRole}, (r) => {});
    }, (error) => print(error));
    privateChannel();
  }

  void privateChannel() {
    this.channel = _pusher.subscribe("$_channelName$_userId");
    channel.bind(ChatEvent.CHAT, (PusherEvent? event) {
      addNewPrivateChat(
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

  List<ChatPayload>? get privateMessages {
    //get chatpayload from local database
    if (_privateMsgs == null) {
      dbManager.getItems(ChatPayload.tableName_ + "Private").then(
        (result) {
          this._privateMsgs = List<ChatPayload>.from(
            result.map((item) => ChatPayload.fromJson(item)),
          );
          notifyListeners();
        },
      );
    }
    return this._privateMsgs;
  }

  List<Msg> get groupMessages {
    return [...this._groupMsgs];
  }

  List<Msg> get forumMessages {
    return [...this._forumMsgs];
  }

  List<StudentDto> get students {
    return [...this._students];
  }

  void getConversations() async {
    final results = await _service.fetchUserMsgs();
    results!.fold(
      (userChats) {
        this._privateMsgs =
            userChats.data.payload.peerMsgs.map(convertToChatPayload).toList();
        userChats.data.payload.peerMsgs.forEach((userChat) async {
          //check if the user profile exist in the database, if not then fetch it from api
          // for(int i = 0;i<_pri)
          if (userChat.userType == "student") {
            var student = await _service.fetchStudentData(userChat.senderId);
            student!.fold((std) {
              _students.add(std);
            }, (error) => print("error"));
          }
        });
        //store privateMessages
        _privateMsgs!.map(
          (message) => dbManager.insertItem(message,
              tableName: ChatPayload.tableName_ + "Private"),
        );
        this._groupMsgs = userChats.data.payload.groupMsgs;
        //TODO  store group Messages,forum messages

        this._forumMsgs = userChats.data.payload.forumMsgs;
      },
      (error) => print('Error from fetchChats() :${error.message}'),
    );
    notifyListeners();
  }

  ChatPayload convertToChatPayload(PeerMsg msg) {
    return ChatPayload(
      id: msg.id,
      message: msg.message,
      imageUrl: msg.imageUrl,
      senderId: msg.senderId,
      groupsId: msg.groupsId,
      reply: msg.reply,
      status: msg.status,
      reciepient: msg.reciepient,
      role: msg.userType,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    channel.unbind(ChatEvent.CHAT);
  }

  Future<InfoMessage> sendPrivateCounselingMessage(
      ChatPayload chat, String userId) async {
    var service = CounselingServiceProvider();
    late InfoMessage _info;
    ChatPayload chatData = finalChatPayload(chat);
    final result = await service.peerCounseling(chatData, userId);
    result.fold((chat) {
      addNewPrivateChat(chat);
      _info = InfoMessage("message sent", InfoMessage.success);
    }, (error) {
      _info = InfoMessage(error.message, InfoMessage.error);
    });
    notifyListeners();
    return _info;
  }

  ChatPayload finalChatPayload(ChatPayload chat) {
    var role = this.userRole.isCounsellor
        ? "counsellor"
        : this.userRole.isPeerCounsellor
            ? 'peerCounsellor'
            : 'student';

    final chatData = ChatPayload(
      id: chat.id,
      message: chat.message,
      imageUrl: chat.imageUrl,
      senderId: chat.senderId,
      groupsId: chat.groupsId ?? "",
      reply: chat.reply ?? "",
      status: chat.status,
      reciepient: chat.reciepient,
      role: role,
    );
    return chatData;
  }

  void addNewPrivateChat(
    ChatDto chat,
  ) {
    if (this.privateMessages == null) {
      this._privateMsgs = [];
    }
    ChatPayload _privateChat = ChatPayload(
      id: chat.data.payload.id,
      message: chat.data.payload.message,
      imageUrl: chat.data.payload.imageUrl,
      senderId: chat.data.payload.senderId,
      groupsId: chat.data.payload.groupsId ?? "",
      reply: chat.data.payload.reply ?? "",
      status: chat.data.payload.status,
      reciepient: chat.data.payload.reciepient,
      role: chat.data.payload.reciepient,
    );
    this._privateMsgs!.add(_privateChat);
    //store the chat to local database
    dbManager.insertItem(_privateChat,
        tableName: ChatPayload.tableName_ + "Private");
  }

  Future<InfoMessage> sendGroupMessage(ChatPayload chat, String userId) async {
    var service = CounselingServiceProvider();
    ChatPayload chatData = finalChatPayload(chat);
    var result = await service.groupCounseling(chatData, userId);
    late InfoMessage _info;
    result!.fold((chat) {
      this._groupMsgs.forEach(
        (group) {
          if (group.info.id == chat.data.payload.groupsId) {
            appendToGroupMessages(group, chat);
          }
        },
      );
      _info = InfoMessage("message sent", InfoMessage.success);
    }, (error) {
      info = InfoMessage(error.message, InfoMessage.error);
    });
    notifyListeners();
    return _info;
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
        userType: chat.data.payload.userType,
      ),
    );
  }

  Future<User?> getUserProfile(String userType, int userId) async {
    //check if user exist in database
    final query = await dbManager.getItem(User.tableName_, userId);
    if (query != null) {
      return User.fromJson(query);
    }
    //check if user is counsellor and fetch his/her profile details from server
    if (userType == 'counsellor') {
      final res = await _service.fetchCounsellor(userId.toString());
      Counsellor? _counsellor;
      res.fold((l) {
        _counsellor = l;
        //save user to local database
        dbManager.insertItem(l.user);
        dbManager.insertItem(l);
      }, (r) => null);
      return _counsellor?.user;
    }
    //Else fetch the profile from student
    else {}
  }
}
