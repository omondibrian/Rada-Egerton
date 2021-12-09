import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:rada_egerton/constants.dart';
import 'package:rada_egerton/entities/ChatDto.dart';
import 'package:rada_egerton/entities/GroupsDTO.dart' as Groups;
import 'package:rada_egerton/entities/UserChatsDTO.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceUtility {
  // late final DataConnectionChecker connection;
  static Future<String?> getAuthToken() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final token = _prefs.getString("TOKEN");
    return token;
  }

  static Future<bool> isAuthenticated() async {
    var token = await getAuthToken();
    return token!.isNotEmpty;
  }

  static ErrorMessage handleDioExceptions(DioError e) {
    // The request was made and the server responded with a status code
    // that falls out of the range of 2xx and is also not 304.
    if (e.response != null) {
      return ErrorMessage(
          message: e.response!.data["message"] ?? "An error occured",
          status: e.response!.statusCode.toString());
    } else {
      // Something happened in setting up or sending the request that triggered an Error

    }
    return ErrorMessage(message: e.message, status: "400");
  }

  static List<Message> combinePeerMsgs(List<ChatPayload> msgs, String userId) {
    List<String> userIds = [];
    Message extractMsgs(String receipientId) {
      List<ChatPayload> msg = [];
      for (var i = 0; i < msgs.length; i++) {
        //check if message belongs to the user and the current reciepient the add it to list
        if (msgs[i].senderId == userId || msgs[i].senderId == receipientId) {
          if (msgs[i].reciepient == userId ||
              msgs[i].reciepient == receipientId) {
            msg.add(msgs[i]);
          }
        }
      }
      return Message(recipient: receipientId, msg: msg);
    }

    //get a list of receipients compared to the user id
    for (var i = 0; i < msgs.length; i++) {
      userIds.add(
          userId == msgs[i].senderId ? msgs[i].reciepient : msgs[i].senderId);
    }

    return userIds.toSet().toList().map(extractMsgs).toList();
  }

  static List<ForumPayload> parseForums(
      Groups.GroupsDto? forums, List<Msg> forumMsgs) {
    if (forums == null) return [];
    List<ForumPayload> finalForumList = [];
    for (var i = 0; i < forumMsgs.length; i++) {
      int subForumIndex = forums.data.payload
          .indexWhere((info) => info.id == forumMsgs[i].info.id);
      if (subForumIndex != -1) {
        finalForumList.insert(
          0,
          ForumPayload(
            isSubscribed: true,
            forum: forums.data.payload[subForumIndex],
          ),
        );
      } else {
        finalForumList.add(
          ForumPayload(
            isSubscribed: false,
            forum: forums.data.payload[subForumIndex],
          ),
        );
      }
    }
    return finalForumList;
  }
}

class Pusher {
  late PusherClient _pusher;

  Pusher({required String appKey, required String token}) {
    PusherOptions options = PusherOptions(
      // host: BASE_URL,
      cluster: "eu",
      // wsPort: 80,

      encrypted: false,
      auth: PusherAuth(
        "$BASE_URL/rada/api/v1/pusher/auth",
        headers: {
          'Authorization': "$token",
        },
      ),
    );

    this._pusher =
        PusherClient(appKey, options, autoConnect: true, enableLogging: false);
  }

  PusherClient getConnection() {
    return this._pusher;
  }

  disconnect() {
    this._pusher.disconnect();
  }
}

class ErrorMessage {
  String message;
  String status;
  ErrorMessage({required this.message, required this.status});
}

class Message {
  String recipient;
  List<ChatPayload> msg;
  Message({required this.recipient, required this.msg});
}

class ForumPayload {
  bool isSubscribed;
  Groups.Payload forum;
  ForumPayload({required this.isSubscribed, required this.forum});
}

class ChangeNotifierInfo {
  String message;
  Color messageTypeColor;
  ChangeNotifierInfo(this.message, this.messageTypeColor);
}
