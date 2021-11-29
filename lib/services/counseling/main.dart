import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:rada_egerton/services/utils.dart';
import 'package:rada_egerton/entities/ChatDto.dart';
import 'package:rada_egerton/entities/GroupDTO.dart';
import 'package:rada_egerton/services/constants.dart';
import 'package:rada_egerton/entities/GroupsDTO.dart';
import 'package:rada_egerton/entities/StudentDTO.dart';
import 'package:rada_egerton/entities/UserChatsDTO.dart';
import 'package:rada_egerton/entities/CounsellorsDTO.dart';
import 'package:rada_egerton/entities/PeerCounsellorDTO.dart';

class CounselingServiceProvider {
  String _hostUrl = BASE_URL;
  Dio _httpClientConn = Dio();

  ///fetch a  list of  counsellors with their details
  Future<Either<List<CounsellorsDTO>, ErrorMessage>> fetchCounsellors() async {
    List<dynamic> counsellors = [];
    try {
      final result = await this._httpClientConn.get(
            "${this._hostUrl}/api/v1/admin/user/counsellors",
            options: Options(
                headers: {'Authorization': ServiceUtility.getAuthToken()},
                sendTimeout: 10000),
          );
      List payload = result.data["counsellors"];
      for (var i = 0; i < payload.length; i++) {
        counsellors.add(CounsellorsDTO(
            name: payload[i]['name'],
            rating: payload[i]['rating'],
            isOnline: payload[i]['status'],
            expertise: payload[i]['expertise'],
            imgUrl: payload[i]['profilePic']));
      }
      print(counsellors);
    } on DioError catch (e) {
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
    return Left(counsellors as List<CounsellorsDTO>);
  }

  ///fetch a specific counsellor details
  Future<Either<CounsellorsDTO, ErrorMessage>> fetchCounsellor(
      String id) async {
    dynamic payload;
    try {
      final result = await this._httpClientConn.get(
            "${this._hostUrl}/api/v1/admin/user/counsellor/$id",
            options: Options(
                headers: {'Authorization': ServiceUtility.getAuthToken()},
                sendTimeout: 10000),
          );
      payload = result.data["counsellor"];
    } on DioError catch (e) {
      Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
    return Left(
      CounsellorsDTO(
          name: payload['name'],
          rating: payload['rating'],
          isOnline: payload['status'],
          expertise: payload['expertise'],
          imgUrl: payload['profilePic']),
    );
  }

  ///fetch peer counsellors
  Future<Either<List<PeerCounsellorDto>, ErrorMessage>>
      fetchPeerCounsellors() async {
    List<dynamic> peerCounsellors = [];

    try {
      final result = await this._httpClientConn.get(
            "${this._hostUrl}/api/v1/admin/user/peercounsellors",
            options: Options(
                headers: {'Authorization': ServiceUtility.getAuthToken()},
                sendTimeout: 10000),
          );
      List payload = result.data["counsellors"];

      for (var i = 0; i < payload.length; i++) {
        peerCounsellors.add(PeerCounsellorDto.fromJson(payload[1]));
      }
      print(peerCounsellors);
    } on DioError catch (e) {
      Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }

    return Left(peerCounsellors as List<PeerCounsellorDto>);
  }

  ///fetch student profile
  Future<Either<StudentDto, ErrorMessage>?> fetchStudentData(
      String studentId) async {
    try {
      final result = await this._httpClientConn.get(
            "${this._hostUrl}/api/v1/admin/user/studentprofile/$studentId",
            options: Options(
                headers: {'Authorization': ServiceUtility.getAuthToken()},
                sendTimeout: 10000),
          );

      return Left(StudentDto.fromJson(result.data));
    } on DioError catch (e) {
      Right(ServiceUtility.handleDioExceptions(e));
    }
  }

  ///fetch student forums
  Future<Either<GroupsDto, ErrorMessage>?> fetchStudentForums() async {
    try {
      final result = await this._httpClientConn.get(
            "${this._hostUrl}/rada/api/v1/counseling/forums",
            options: Options(
                headers: {'Authorization': ServiceUtility.getAuthToken()},
                sendTimeout: 10000),
          );
      return Left(GroupsDto.fromJson(result.data));
    } on DioError catch (e) {
      Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }

  ///fetch student groups
  Future<Either<GroupsDto, ErrorMessage>?> fetchStudentGroups() async {
    try {
      final result = await this._httpClientConn.get(
            "${this._hostUrl}/rada/api/v1/counseling/grps",
            options: Options(
                headers: {'Authorization': ServiceUtility.getAuthToken()},
                sendTimeout: 10000),
          );
      return Left(
        GroupsDto.fromJson(result.data),
      );
    } on DioError catch (e) {
      Right(ServiceUtility.handleDioExceptions(e));
    }
  }

  ///subscribeToGroup
  Future<Either<GroupDTO, ErrorMessage>?> subToNewGroup(
      String userId, String groupId) async {
    try {
      final result = await this._httpClientConn.get(
            "${this._hostUrl}/rada/api/v1/counseling/subscribe/$userId/$groupId",
            options: Options(
                headers: {'Authorization': ServiceUtility.getAuthToken()},
                sendTimeout: 10000),
          );

      return Left(
        GroupDTO(
          id: result.data['id'],
          title: result.data['title'],
          image: result.data['image'],
        ),
      );
    } on DioError catch (e) {
      Right(ServiceUtility.handleDioExceptions(e));
    }
  }

  Future<Either<UserChatDto, ErrorMessage>?> fetchUserMsgs() async {
    try {
      final result = await this._httpClientConn.get(
            "${this._hostUrl}/rada/api/v1/counseling",
            options: Options(
                headers: {'Authorization': ServiceUtility.getAuthToken()},
                sendTimeout: 10000),
          );
      return Left(
        UserChatDto.fromJson(result.data),
      );
    } on DioError catch (e) {
      Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }

  /// exit group
  Future<Either<GroupDTO, ErrorMessage>?> exitGroup(String groupId) async {
    try {
      final result = await this._httpClientConn.put(
            "${this._hostUrl}/rada/api/v1/counseling/$groupId",
            options: Options(
                headers: {'Authorization': ServiceUtility.getAuthToken()},
                sendTimeout: 10000),
          );
      return Left(
        GroupDTO(
            id: result.data['id'],
            title: result.data['title'],
            image: result.data['image']),
      );
    } on DioError catch (e) {
      Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }

  ///delete group
  Future<Either<GroupDTO, ErrorMessage>?> deleteGroup(String groupId) async {
    try {
      final result = await this._httpClientConn.delete(
            "${this._hostUrl}/rada/api/v1/counseling/$groupId",
            options: Options(
                headers: {'Authorization': ServiceUtility.getAuthToken()},
                sendTimeout: 10000),
          );
      return Left(
        GroupDTO(
            id: result.data['id'],
            title: result.data['title'],
            image: result.data['image']),
      );
    } on DioError catch (e) {
      Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }

  ///@description sends chat messages between two users i.e from counsellor to client
  ///@params { Chat }  chatData contains the message payload to be deliverd to the  reciepient
  ///@returns chatDTO
  Future<Either<ChatDto, ErrorMessage>?> peerCounseling(
      ChatPayload chatData, String userId) async {
    try {
      FormData formData = FormData.fromMap({
        'message': chatData.message,
        'sender_id': chatData.senderId,
        "receipient": chatData.reciepient,
        "status": "0"
      });
      //send the chat to the api server
      final result = await this._httpClientConn.post(
            "${this._hostUrl}/rada/api/v1/counseling/peerToPeerCounseling",
            data: formData,
            options: Options(
                headers: {'Authorization': ServiceUtility.getAuthToken()},
                sendTimeout: 10000),
          );
      return Left(
        ChatDto.fromJson(result.data),
      );
    } on DioError catch (e) {
      Right(
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
      FormData formData = FormData.fromMap({
        'message': chatData.message,
        'sender_id': chatData.senderId,
        "receipient": chatData.reciepient,
        "groupId": chatData.groupsId,
        "status": "0"
      });
      //send the chat to the api server
      final result = await this._httpClientConn.post(
            "${this._hostUrl}/rada/api/v1/counseling/groupCounseling",
            data: formData,
            options: Options(
                headers: {'Authorization': ServiceUtility.getAuthToken()},
                sendTimeout: 10000),
          );
      return Left(
        ChatDto.fromJson(result.data),
      );
    } on DioError catch (e) {
      Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }
}