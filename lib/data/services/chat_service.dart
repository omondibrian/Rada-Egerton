import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:rada_egerton/data/entities/chat_dto.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/resources/utils/main.dart';

/// Send Chats
class ChatService {
  static final Dio _httpClientConn = httpClient;
  static final String _hostUrl = GlobalConfig.baseUrl;
  static final FirebaseCrashlytics _firebaseCrashlytics =
      FirebaseCrashlytics.instance;

  /// Returns a map with keys groupChats, privateChats
  static Future<Either<Map<String, List<ChatPayload>>, ErrorMessage>>
      fetchUserMsgs() async {
    try {
      String token = GlobalConfig.instance.authToken;
      final result = await _httpClientConn.get(
        "$_hostUrl/rada/api/v1/counseling",
        options: Options(headers: {
          'Authorization': token,
          "Content-type": "multipart/form-data",
        }),
      );
      Iterable groupChats = result.data["data"]["payload"]["groupMsgs"];
      Iterable privateChats = result.data["data"]["payload"]["peerMsgs"];

      Map<String, List<ChatPayload>> chats = {
        "groupChats": List<ChatPayload>.from(
          groupChats.map((c) => ChatPayload.fromJson(c)),
        ),
        "privateChats": List<ChatPayload>.from(
          privateChats.map((c) => ChatPayload.fromJson(c)),
        )
      };
      return Left(chats);
    } catch (e, stackTrace) {
      _firebaseCrashlytics.recordError(
        e,
        stackTrace,
        reason: 'Error while fetching user counselling messages',
      );
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }

  ///@description sends chat messages between two users i.e from counsellor to client
  ///@params { Chat }  chatData contains the message payload to be deliverd to the  reciepient
  ///@returns ChatPayload
  static Future<Either<ChatPayload, ErrorMessage>> sendPrivateMessage({
    required String message,
    required String recipientId,
    String? reply,
    required String senderId,
    File? picture,
    File? video,
    Function(String)? onRetry,
  }) async {
    Dio dio = Dio();
    try {
      String token = GlobalConfig.instance.authToken;
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
      //TODO:implement video uploads
      // if (video != null) {
      //   data["video"] = await MultipartFile.fromFile(
      //     video.path,
      //     filename: video.path.split("/").last,
      //   );
      // }

      FormData formData = FormData.fromMap(data);
      //send the chat to the api server
      dio.interceptors.add(
        RetryInterceptor(
          dio: dio,
          logPrint: onRetry,
        ),
      );
      final result = await dio.post(
        "$_hostUrl/rada/api/v1/counseling/peerToPeerCounseling",
        data: formData,
        options: Options(
          headers: {
            'Authorization': token,
            "Content-type": "multipart/form-data",
          },
          //send timeout to 3 minutes
          sendTimeout: 3 * 60000,
        ),
      );
      return Left(
        ChatPayload.fromJson(result.data["data"]["payload"]),
      );
    } catch (e, stackTrace) {
      _firebaseCrashlytics.recordError(
        e,
        stackTrace,
        reason: 'Error while fetching peer counselling chatpayload',
      );
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }

  ///@description sends chat messages to users in the same group or forum
  ///@params { Chat }  chatData contains the message payload to be deliverd to the  group
  ///@returns ChatPayload
  static Future<Either<ChatPayload, ErrorMessage>> sendGroupChat({
    required String message,
    required String groupId,
    String? reply,
    required String senderId,
    File? picture,
    File? video,
    Function(String)? onRetry,
  }) async {
    Dio dio = Dio();
    try {
      String token = GlobalConfig.instance.authToken;
      Map<String, dynamic> data = {
        'message': message,
        'sender_id': senderId,
        "groupId": groupId,
        "reply": reply,
        "status": "0",
        "receipient": "",
      };

      if (picture != null) {
        data["image"] = await MultipartFile.fromFile(
          picture.path,
          filename: picture.path.split("/").last,
        );
      }
      //TODO:implement video uploads
      // if (video != null) {
      //   data["video"] = await MultipartFile.fromFile(
      //     video.path,
      //     filename: video.path.split("/").last,
      //   );
      // }

      FormData formData = FormData.fromMap(data);
      dio.interceptors.add(
        RetryInterceptor(
          dio: dio,
          logPrint: onRetry,
        ),
      );
      final result = await dio.post(
        "$_hostUrl/rada/api/v1/counseling/groupCounseling",
        data: formData,
        options: Options(
          headers: {
            'Authorization': token,
            "Content-type": "multipart/form-data",
          },
          //send timeout to 3 minutes
          sendTimeout: 3 * 60000,
        ),
      );
      return Left(
        ChatPayload.fromJson(result.data["data"]["payload"]),
      );
    } catch (e, stackTrace) {
      print(e);
      _firebaseCrashlytics.recordError(
        e,
        stackTrace,
        reason: 'Error while fetching peer counselling chatpayload',
      );
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }
}
