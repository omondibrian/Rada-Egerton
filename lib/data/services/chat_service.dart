
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
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
  static Future<Either<ChatPayload, ErrorMessage>> fetchUserMsgs() async {
    try {
      String token = GlobalConfig.instance.authToken;
      final result = await _httpClientConn.get(
        "$_hostUrl/rada/api/v1/counseling",
        options: Options(headers: {
          'Authorization': token,
        }, sendTimeout: 10000),
      );
      return Left(
        ChatPayload.fromJson(result.data),
      );
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
  Future<Either<ChatPayload, ErrorMessage>> peerCounseling(
      ChatPayload chatData, String userId) async {
    try {
      String token = GlobalConfig.instance.authToken;
      FormData formData = FormData.fromMap({
        'message': chatData.message,
        'sender_id': chatData.senderId,
        "receipient": chatData.reciepient,
        "reply": chatData.reply,
        "user_type": chatData.role,
        "status": "0"
      });
      //send the chat to the api server
      final result = await _httpClientConn.post(
        "$_hostUrl/rada/api/v1/counseling/peerToPeerCounseling",
        data: formData,
        options: Options(headers: {
          'Authorization': token,
        }, sendTimeout: 10000),
      );
      return Left(
        ChatPayload.fromJson(result.data),
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

  ///@description sends chat messages to usersin the same group or forum
  ///@params { Chat }  chatData contains the message payload to be deliverd to the  group
  ///@returns ChatPayload
  Future<Either<ChatPayload, ErrorMessage>?> groupCounseling(
      ChatPayload chatData, String userId) async {
    try {
      String token = GlobalConfig.instance.authToken;
      FormData formData = FormData.fromMap({
        'message': chatData.message,
        'sender_id': chatData.senderId,
        "receipient": chatData.reciepient,
        "groupId": chatData.groupsId,
        "reply": chatData.reply,
        "status": "0"
      });
      //send the chat to the api server
      final result = await _httpClientConn.post(
        "$_hostUrl/rada/api/v1/counseling/groupCounseling",
        data: formData,
        options: Options(headers: {
          'Authorization': token,
        }, sendTimeout: 10000),
      );

      return Left(
        ChatPayload.fromJson(result.data),
      );
    } catch (e, stackTrace) {
      _firebaseCrashlytics.recordError(
        e,
        stackTrace,
        reason: 'Error while fetching group counselling chat data',
      );
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }
}
