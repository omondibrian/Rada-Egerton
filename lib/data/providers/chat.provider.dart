import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rada_egerton/data/database/sqlite.dart';
import 'package:rada_egerton/data/entities/chat_dto.dart';
import 'package:rada_egerton/data/entities/CounsellorsDTO.dart';
import 'package:rada_egerton/data/entities/StudentDTO.dart';
import 'package:rada_egerton/data/entities/UserDTO.dart';
import 'package:rada_egerton/data/entities/userRoles.dart';
import 'package:rada_egerton/data/services/counseling_service.dart';
import 'package:rada_egerton/resources/constants.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:rada_egerton/resources/utils/main.dart';

class ChatProvider with ChangeNotifier {
  late Channel channel;
  InfoMessage? info;
  final List<ChatPayload> _groupMsgs = [];
  final List<ChatPayload> _forumMsgs = [];
  UserRole userRole = UserRole([]);
  final List<StudentDto> _students = [];
  final CounselingServiceProvider _service = CounselingServiceProvider();
  DBManager dbManager = DBManager.instance;

  ChatProvider();

  List<ChatPayload> get groupMessages {
    return [..._groupMsgs];
  }

  List<ChatPayload> get forumMessages {
    return [..._forumMsgs];
  }

  List<StudentDto> get students {
    return [..._students];
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
      _info = InfoMessage("message sent", MessageType.success);
    }, (error) {
      _info = InfoMessage(error.message, MessageType.error);
    });
    notifyListeners();
    return _info;
  }

  ChatPayload finalChatPayload(ChatPayload chat) {
    var role = userRole.isCounsellor
        ? "counsellor"
        : userRole.isPeerCounsellor
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
    final query = await dbManager.getItem(TableNames.user, userId);
    if (query != null) {
      return User.fromJson(query);
    }
    //check if user is counsellor and fetch his/her profile details from server
    if (userType == 'counsellor') {
      final res = await _service.fetchCounsellor(userId.toString());
      Counsellor? counsellor;
      res.fold((l) {
        counsellor = l;
        //save user to local database
        dbManager.insertItem(l.user, tableName: TableNames.user);
        dbManager.insertItem(l, tableName: TableNames.counsellor);
      }, (r) => null);
      return counsellor?.user;
    }
    //Else fetch the profile from student
    else {}
    return null;
  }
}
