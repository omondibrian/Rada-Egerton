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

  ChatProvider() {}

  List<Msg> get groupMessages {
    return [...this._groupMsgs];
  }

  List<Msg> get forumMessages {
    return [...this._forumMsgs];
  }

  List<StudentDto> get students {
    return [...this._students];
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
