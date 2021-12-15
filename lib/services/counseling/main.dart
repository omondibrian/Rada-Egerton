import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:rada_egerton/constants.dart';
import 'package:rada_egerton/entities/UserDTO.dart';
import 'package:rada_egerton/utils/main.dart';
import 'package:rada_egerton/entities/ChatDto.dart';
import 'package:rada_egerton/entities/GroupDTO.dart';
import 'package:rada_egerton/entities/GroupsDTO.dart';
import 'package:rada_egerton/entities/StudentDTO.dart';
import 'package:rada_egerton/entities/UserChatsDTO.dart';
import 'package:rada_egerton/entities/CounsellorsDTO.dart';
import 'package:rada_egerton/entities/PeerCounsellorDTO.dart';

class CounselingServiceProvider {
  String _hostUrl = BASE_URL;
  Dio _httpClientConn = Dio();

  ///fetch a  list of  counsellors with their details
  Future<Either<List<Counselor>, ErrorMessage>> fetchCounsellors() async {
    String token = await ServiceUtility.getAuthToken() as String;
    try {
      final result = await this._httpClientConn.get(
            "${this._hostUrl}/api/v1/admin/user/counsellors",
            options: Options(headers: {
              'Authorization': token,
            }, sendTimeout: 10000),
          );
      List payload = result.data["counsellors"];
      return Left(
        List<Counselor>.from(
          payload.map(
            (_counselor) => Counselor.fromJson(_counselor),
          ),
        ),
      );
    } on DioError catch (e) {
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }

  ///fetch a specific counsellor details
  Future<Either<CounsellorsDTO, ErrorMessage>> fetchCounsellor(
      String id) async {
    dynamic payload;
    try {
      String token = await ServiceUtility.getAuthToken() as String;
      final result = await this._httpClientConn.get(
            "${this._hostUrl}/api/v1/admin/user/counsellor/$id",
            options: Options(headers: {
              'Authorization': token,
            }, sendTimeout: 10000),
          );
      payload = result.data["counsellor"];
    } on DioError catch (e) {
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }

    return Left(
      CounsellorsDTO(
        name: payload['name'],
        rating: double.parse(payload['rating'].toString()),
        isOnline: payload['status'] == "online",
        expertise: payload['expertise'],
        imgUrl: payload['profilePic'],
        id: payload["_id"],
      ),
    );
  }

  ///fetch peer counsellors
  Future<Either<List<PeerCounsellorDto>, ErrorMessage>>
      fetchPeerCounsellors() async {
    List<PeerCounsellorDto> peerCounsellors = [];
    try {
      String token = await ServiceUtility.getAuthToken() as String;
      final result = await this._httpClientConn.get(
            "${this._hostUrl}/api/v1/admin/user/peercounsellors",
            options: Options(headers: {
              'Authorization': token,
            }, sendTimeout: 10000),
          );
      List payload = result.data["counsellors"];

      for (var i = 0; i < payload.length; i++) {
        peerCounsellors.add(PeerCounsellorDto.fromJson(payload[i]));
      }
    } on DioError catch (e) {
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }

    return Left(peerCounsellors);
  }

  ///fetch student profile
  Future<Either<StudentDto, ErrorMessage>?> fetchStudentData(
      String studentId) async {
    try {
      String token = await ServiceUtility.getAuthToken() as String;
      final result = await this._httpClientConn.get(
            "${this._hostUrl}/api/v1/admin/user/studentprofile/$studentId",
            options: Options(headers: {
              'Authorization': token,
            }, sendTimeout: 10000),
          );

      return Left(StudentDto.fromJson(result.data));
    } on DioError catch (e) {
      Right(ServiceUtility.handleDioExceptions(e));
    }
  }

  ///fetch student forums
  Future<Either<GroupsDto, ErrorMessage>?> fetchStudentForums() async {
    try {
      String token = await ServiceUtility.getAuthToken() as String;
      final result = await this._httpClientConn.get(
            "${this._hostUrl}/rada/api/v1/counseling/forums",
            options: Options(headers: {
              'Authorization': token,
            }, sendTimeout: 10000),
          );
      print(result.data);
      return Left(GroupsDto.fromJson(result.data));
    } on DioError catch (e) {
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }

  ///fetch student groups
  Future<Either<GroupsDto, ErrorMessage>?> fetchStudentGroups() async {
    try {
      String token = await ServiceUtility.getAuthToken() as String;
      final result = await this._httpClientConn.get(
            "${this._hostUrl}/rada/api/v1/counseling/grps",
            options: Options(headers: {
              'Authorization': token,
            }, sendTimeout: 10000),
          );
      return Left(
        GroupsDto.fromJson(result.data),
      );
    } on DioError catch (e) {
      return Right(ServiceUtility.handleDioExceptions(e));
    }
  }

  ///subscribeToGroup
  Future<Either<GroupDTO, ErrorMessage>?> subToNewGroup(
      String userId, String groupId) async {
    try {
      String token = await ServiceUtility.getAuthToken() as String;
      final result = await this._httpClientConn.get(
            "${this._hostUrl}/rada/api/v1/counseling/subscribe/$userId/$groupId",
            options: Options(headers: {
              'Authorization': token,
            }, sendTimeout: 10000),
          );

      return Left(
        GroupDTO(
          id: result.data['data']['payload']['id'].toString(),
          title: result.data['data']['payload']['title'],
          image: result.data['data']['payload']['image'],
        ),
      );
    } on DioError catch (e) {
      return Right(ServiceUtility.handleDioExceptions(e));
    }
  }

  Future<Either<UserChatDto, ErrorMessage>?> fetchUserMsgs() async {
    try {
      String token = await ServiceUtility.getAuthToken() as String;
      final result = await this._httpClientConn.get(
            "${this._hostUrl}/rada/api/v1/counseling",
            options: Options(headers: {
              'Authorization': token,
            }, sendTimeout: 10000),
          );
      return Left(
        UserChatDto.fromJson(result.data),
      );
    } on DioError catch (e) {
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }

  /// create new  group
  Future<Either<GroupDTO, ErrorMessage>?> createGroup(
      String name, String desc, File? imageFile) async {
    try {
      String token = await ServiceUtility.getAuthToken() as String;
      String imageFileName = imageFile!.path.split('/').last;
      FormData formData = FormData.fromMap(
        {
          "profilePic": await MultipartFile.fromFile(imageFile.path,
              filename: imageFileName),
          "title": name,
          "description": desc,
        },
      );
      final result = await this._httpClientConn.post(
            "${this._hostUrl}/rada/api/v1/counseling",
            data: formData,
            options: Options(headers: {
              'Authorization': token,
              "Content-type": "multipart/form-data",
            }, sendTimeout: 10000),
          );
      return Left(
        GroupDTO.fromJson(result.data['data']['payload']),
      );
    } on DioError catch (e) {
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }

  /// exit group
  Future<Either<GroupDTO, ErrorMessage>?> exitGroup(String groupId) async {
    try {
      String token = await ServiceUtility.getAuthToken() as String;
      final result = await this._httpClientConn.put(
            "${this._hostUrl}/rada/api/v1/counseling/$groupId",
            options: Options(headers: {
              'Authorization': token,
            }, sendTimeout: 10000),
          );
      return Left(
        GroupDTO(
            id: result.data["data"]["payload"]['id'].toString(),
            title: result.data["data"]["payload"]['title'],
            image: result.data["data"]["payload"]['image']),
      );
    } on DioError catch (e) {
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }

  /// query user data
  Future<Either<User, ErrorMessage>?> queryUserData(String queryString) async {
    try {
      String token = await ServiceUtility.getAuthToken() as String;
      final result = await this._httpClientConn.get(
            "${this._hostUrl}/api/v1/admin/user/queryUserInfo/$queryString",
            options: Options(headers: {
              'Authorization': token,
            }, sendTimeout: 10000),
          );
      return Left(User.fromJson(result.data["user"]));
    } on DioError catch (e) {
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }

  ///delete group
  Future<Either<GroupDTO, ErrorMessage>> deleteGroup(String groupId) async {
    try {
      String token = await ServiceUtility.getAuthToken() as String;
      final result = await this._httpClientConn.delete(
            "${this._hostUrl}/rada/api/v1/counseling/$groupId",
            options: Options(headers: {
              'Authorization': token,
            }, sendTimeout: 10000),
          );
      return Left(
        GroupDTO(
            id: result.data['id'],
            title: result.data['title'],
            image: result.data['image']),
      );
    } on DioError catch (e) {
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }

  ///@description sends chat messages between two users i.e from counsellor to client
  ///@params { Chat }  chatData contains the message payload to be deliverd to the  reciepient
  ///@returns chatDTO
  Future<Either<ChatDto, ErrorMessage>> peerCounseling(
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
      final result = await this._httpClientConn.post(
            "${this._hostUrl}/rada/api/v1/counseling/peerToPeerCounseling",
            data: formData,
            options: Options(headers: {
              'Authorization': token,
            }, sendTimeout: 10000),
          );
      return Left(
        ChatDto.fromJson(result.data),
      );
    } on DioError catch (e) {
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }

  ///@description sends chat messages to usersin the same group or forum
  ///@params { Chat }  chatData contains the message payload to be deliverd to the  group
  ///@returns chatDTO
  Future<Either<ChatDto, ErrorMessage>?> groupCounseling(
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
      final result = await this._httpClientConn.post(
            "${this._hostUrl}/rada/api/v1/counseling/groupCounseling",
            data: formData,
            options: Options(headers: {
              'Authorization': token,
            }, sendTimeout: 10000),
          );

      return Left(
        ChatDto.fromJson(result.data),
      );
    } on DioError catch (e) {
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }

  Future<Either<InfoMessage, ErrorMessage>> rateCounselor(
      String counselorId, double rate) async {
    try {
      String token = await ServiceUtility.getAuthToken() as String;
      final result = await this._httpClientConn.post(
          "${this._hostUrl}/api/v1/admin/user/counsellor/rate/$counselorId",
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
