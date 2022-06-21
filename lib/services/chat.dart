import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:rada_egerton/entities/ChatDto.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/utils/main.dart';

class ChatRepository {
  static Dio _httpClientConn = GlobalConfig.httpClient;
  static String _hostUrl = GlobalConfig.baseUrl;

  ///@description sends chat messages between two users i.e from counsellor to client
  ///@params { Chat }  chatData contains the message payload to be deliverd to the  reciepient
  ///@returns ChatPayload
  Future<Either<ChatPayload, ErrorMessage>> peerCounseling(
      ChatPayload chatData, String userId) async {
    try {
      String token = await ServiceUtility.getAuthToken() as String;
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
    } on DioError catch (e) {
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
      String token = await ServiceUtility.getAuthToken() as String;
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
    } on DioError catch (e) {
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }

  Future<Either<InfoMessage, ErrorMessage>> rateCounsellor(
      String counsellorId, double rate) async {
    try {
      String token = await ServiceUtility.getAuthToken() as String;
      final result = await _httpClientConn.post(
          "$_hostUrl/api/v1/admin/user/counsellor/rate/$counsellorId",
          options: Options(headers: {
            'Authorization': token,
          }, sendTimeout: 10000),
          data: json.encode({"rate": rate}));
      print(result.data);
      return Left(InfoMessage("Rating sucessfuly", InfoMessage.success));
    } on DioError catch (e) {
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }
}
