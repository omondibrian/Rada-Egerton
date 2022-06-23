import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:rada_egerton/data/entities/UserDTO.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/resources/utils/main.dart';
import 'package:rada_egerton/data/entities/chat_dto.dart';
import 'package:rada_egerton/data/entities/GroupDTO.dart';
import 'package:rada_egerton/data/entities/GroupsDTO.dart';
import 'package:rada_egerton/data/entities/StudentDTO.dart';
import 'package:rada_egerton/data/entities/CounsellorsDTO.dart';
import 'package:rada_egerton/data/entities/PeerCounsellorDTO.dart';

class CounselingServiceProvider {
  final String _hostUrl = GlobalConfig.baseUrl;
  final Dio _httpClientConn = httpClient;
  static final FirebaseCrashlytics _firebaseCrashlytics =
      FirebaseCrashlytics.instance;

  ///fetch a  list of  counsellors with their details
  Future<Either<List<Counsellor>, ErrorMessage>> fetchCounsellors() async {
    String token = await ServiceUtility.getAuthToken() as String;
    try {
      final result = await _httpClientConn.get(
        "$_hostUrl/api/v1/admin/user/counsellors",
        options: Options(headers: {
          'Authorization': token,
        }, sendTimeout: 10000),
      );
      List payload = result.data["counsellors"];
      return Left(
        List<Counsellor>.from(
          payload.map(
            (counsellor) => Counsellor.fromJson(counsellor),
          ),
        ),
      );
    } on DioError catch (e, stackTrace) {
      _firebaseCrashlytics.recordError(
        e,
        stackTrace,
        reason: 'Error while fetching counsellors and their details',
      );
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }

  ///fetch a specific counsellor details
  Future<Either<Counsellor, ErrorMessage>> fetchCounsellor(String id) async {
    dynamic payload;
    try {
      String token = await ServiceUtility.getAuthToken() as String;
      final result = await _httpClientConn.get(
        "$_hostUrl/api/v1/admin/user/counsellor/$id",
        options: Options(headers: {
          'Authorization': token,
        }, sendTimeout: 10000),
      );
      payload = result.data["counsellor"];
    } on DioError catch (e, stackTrace) {
      _firebaseCrashlytics.recordError(
        e,
        stackTrace,
        reason: 'Error while fetching a peer counsellor\'s details',
      );
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }

    return Left(Counsellor.fromJson(payload));
  }

  ///fetch peer counsellors
  Future<Either<List<PeerCounsellorDto>, ErrorMessage>>
      fetchPeerCounsellors() async {
    List<PeerCounsellorDto> peerCounsellors = [];
    try {
      String token = await ServiceUtility.getAuthToken() as String;
      final result = await _httpClientConn.get(
        "$_hostUrl/api/v1/admin/user/peercounsellors",
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
      final result = await _httpClientConn.get(
        "$_hostUrl/api/v1/admin/user/studentprofile/$studentId",
        options: Options(headers: {
          'Authorization': token,
        }, sendTimeout: 10000),
      );

      return Left(StudentDto.fromJson(result.data));
    } on DioError catch (e, stackTrace) {
      _firebaseCrashlytics.recordError(
        e,
        stackTrace,
        reason: 'Error while fetching a student\'s details',
      );
      Right(ServiceUtility.handleDioExceptions(e));
    }
    return null;
  }

  ///fetch student forums
  Future<Either<GroupsDto, ErrorMessage>?> fetchStudentForums() async {
    try {
      String token = await ServiceUtility.getAuthToken() as String;
      final result = await _httpClientConn.get(
        "$_hostUrl/rada/api/v1/counseling/forums",
        options: Options(headers: {
          'Authorization': token,
        }, sendTimeout: 10000),
      );
      print(result.data);
      return Left(GroupsDto.fromJson(result.data));
    } on DioError catch (e, stackTrace) {
      _firebaseCrashlytics.recordError(
        e,
        stackTrace,
        reason: 'Error while fetching messages for student forums',
      );
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }

  ///fetch student groups
  Future<Either<GroupsDto, ErrorMessage>?> fetchStudentGroups() async {
    try {
      String token = await ServiceUtility.getAuthToken() as String;
      final result = await _httpClientConn.get(
        "$_hostUrl/rada/api/v1/counseling/grps",
        options: Options(headers: {
          'Authorization': token,
        }, sendTimeout: 10000),
      );
      return Left(
        GroupsDto.fromJson(result.data),
      );
    } on DioError catch (e, stackTrace) {
      _firebaseCrashlytics.recordError(
        e,
        stackTrace,
        reason: 'Error while fetching student groups',
      );
      return Right(ServiceUtility.handleDioExceptions(e));
    }
  }

  ///subscribeToGroup
  Future<Either<GroupDTO, ErrorMessage>?> subToNewGroup(
      String userId, String groupId) async {
    try {
      String token = await ServiceUtility.getAuthToken() as String;
      final result = await _httpClientConn.get(
        "$_hostUrl/rada/api/v1/counseling/subscribe/$userId/$groupId",
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
    } on DioError catch (e, stackTrace) {
      _firebaseCrashlytics.recordError(
        e,
        stackTrace,
        reason: 'Error while subscribing to a new group',
      );
      return Right(ServiceUtility.handleDioExceptions(e));
    }
  }

  Future<Either<ChatPayload, ErrorMessage>?> fetchUserMsgs() async {
    try {
      String token = await ServiceUtility.getAuthToken() as String;
      final result = await _httpClientConn.get(
        "$_hostUrl/rada/api/v1/counseling",
        options: Options(headers: {
          'Authorization': token,
        }, sendTimeout: 10000),
      );
      return Left(
        ChatPayload.fromJson(result.data),
      );
    } on DioError catch (e, stackTrace) {
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
      final result = await _httpClientConn.post(
        "$_hostUrl/rada/api/v1/counseling",
        data: formData,
        options: Options(headers: {
          'Authorization': token,
          "Content-type": "multipart/form-data",
        }, sendTimeout: 10000),
      );
      return Left(
        GroupDTO.fromJson(result.data['data']['payload']),
      );
    } on DioError catch (e, stackTrace) {
      _firebaseCrashlytics.recordError(
        e,
        stackTrace,
        reason: 'Error while atempting to create a new group',
      );
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }

  /// exit group
  Future<Either<GroupDTO, ErrorMessage>?> exitGroup(String groupId) async {
    try {
      String token = await ServiceUtility.getAuthToken() as String;
      final result = await _httpClientConn.put(
        "$_hostUrl/rada/api/v1/counseling/$groupId",
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
    } on DioError catch (e, stackTrace) {
      _firebaseCrashlytics.recordError(
        e,
        stackTrace,
        reason: 'Error while attempting to leave a group',
      );
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }

  /// query user data
  Future<Either<User, ErrorMessage>?> queryUserData(String queryString) async {
    try {
      String token = await ServiceUtility.getAuthToken() as String;
      final result = await _httpClientConn.get(
        "$_hostUrl/api/v1/admin/user/queryUserInfo/$queryString",
        options: Options(headers: {
          'Authorization': token,
        }, sendTimeout: 10000),
      );
      return Left(User.fromJson(result.data["user"]));
    } on DioError catch (e, stackTrace) {
      _firebaseCrashlytics.recordError(
        e,
        stackTrace,
        reason: 'Error while querying user data',
      );
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }

  ///delete group
  Future<Either<GroupDTO, ErrorMessage>> deleteGroup(String groupId) async {
    try {
      String token = await ServiceUtility.getAuthToken() as String;
      final result = await _httpClientConn.delete(
        "$_hostUrl/rada/api/v1/counseling/$groupId",
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
    } on DioError catch (e, stackTrace) {
      _firebaseCrashlytics.recordError(
        e,
        stackTrace,
        reason: 'Error while attempting to delete a group',
      );
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
      return Left(InfoMessage("Rating sucessfuly", MessageType.success));
    } on DioError catch (e, stackTrace) {
      _firebaseCrashlytics.recordError(
        e,
        stackTrace,
        reason:
            'Error while atempting to rate a counsellor from CounsellingServiceProvider',
      );
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }

  peerCounseling(ChatPayload chatData, String userId) {}
}
