import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:rada_egerton/data/entities/user_dto.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/resources/utils/main.dart';
import 'package:rada_egerton/data/entities/group_dto.dart';
import 'package:rada_egerton/data/entities/counsellors_dto.dart';
import 'package:rada_egerton/data/entities/peer_counsellor_dto.dart';

class CounselingService {
  static final String _hostUrl = GlobalConfig.baseUrl;
  static final Dio _httpClientConn = httpClient;
  static final FirebaseCrashlytics _firebaseCrashlytics =
      FirebaseCrashlytics.instance;

  ///fetch a  list of  counsellors with their details
  static Future<Either<List<Counsellor>, ErrorMessage>>
      fetchCounsellors() async {
    String token = GlobalConfig.instance.authToken;
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
    } catch (e, stackTrace) {
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
  static Future<Either<Counsellor, ErrorMessage>> fetchCounsellor(
      String id) async {
    dynamic payload;
    try {
      String token = GlobalConfig.instance.authToken;
      final result = await _httpClientConn.get(
        "$_hostUrl/api/v1/admin/user/counsellor/$id",
        options: Options(headers: {
          'Authorization': token,
        }, sendTimeout: 10000),
      );
      payload = result.data["counsellor"];
    } catch (e, stackTrace) {
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
  static Future<Either<List<PeerCounsellorDto>, ErrorMessage>>
      fetchPeerCounsellors() async {
    List<PeerCounsellorDto> peerCounsellors = [];
    try {
      String token = GlobalConfig.instance.authToken;
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
    } catch (e) {
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }

    return Left(peerCounsellors);
  }

  ///fetch student forums
  static Future<Either<List<GroupDTO>, ErrorMessage>> userForums() async {
    try {
      String token = GlobalConfig.instance.authToken;
      final result = await _httpClientConn.get(
        "$_hostUrl/rada/api/v1/counseling/forums",
        options: Options(headers: {
          'Authorization': token,
        }, sendTimeout: 10000),
      );
      print(result);
      Iterable forums = result.data["data"]["payload"];
      return Left(
        List<GroupDTO>.from(
          forums.map(
            (json) => GroupDTO.fromJson(json),
          ),
        ),
      );
    } catch (e, stackTrace) {
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
  static Future<Either<List<GroupDTO>, ErrorMessage>> fetchGroups() async {
    try {
      String token = GlobalConfig.instance.authToken;
      final result = await _httpClientConn.get(
        "$_hostUrl/rada/api/v1/counseling/grps",
        options: Options(headers: {
          'Authorization': token,
        }, sendTimeout: 10000),
      );
      Iterable groups = result.data["data"]["payload"];
      return Left(
        List<GroupDTO>.from(
          groups.map(
            (json) => GroupDTO.fromJson(json),
          ),
        ),
      );
    } catch (e, stackTrace) {
      _firebaseCrashlytics.recordError(
        e,
        stackTrace,
        reason: 'Error while fetching student groups',
      );
      return Right(ServiceUtility.handleDioExceptions(e));
    }
  }

  ///subscribeToGroup
  static Future<Either<GroupDTO, ErrorMessage>> subToNewGroup(
      String userId, String groupId) async {
    try {
      String token = GlobalConfig.instance.authToken;
      final result = await _httpClientConn.get(
        "$_hostUrl/rada/api/v1/counseling/subscribe/$userId/$groupId",
        options: Options(
          headers: {
            'Authorization': token,
          },
          sendTimeout: 10000,
        ),
      );

      return Left(
        GroupDTO.fromJson(
          result.data["data"]["payload"],
        ),
      );
    } catch (e, stackTrace) {
      _firebaseCrashlytics.recordError(
        e,
        stackTrace,
        reason: 'Error while subscribing to a new group',
      );
      return Right(ServiceUtility.handleDioExceptions(e));
    }
  }

  /// create new  group
  static Future<Either<GroupDTO, ErrorMessage>> createGroup(
      String name, String desc, File? imageFile) async {
    try {
      String token = GlobalConfig.instance.authToken;
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
    } catch (e, stackTrace) {
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
  static Future<Either<GroupDTO, ErrorMessage>> exitGroup(
      String groupId) async {
    try {
      String token = GlobalConfig.instance.authToken;
      final result = await _httpClientConn.put(
        "$_hostUrl/rada/api/v1/counseling/$groupId",
        options: Options(headers: {
          'Authorization': token,
        }, sendTimeout: 10000),
      );
      return Left(
        GroupDTO.fromJson(
          result.data["data"]["payload"],
        ),
      );
    } catch (e, stackTrace) {
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
  static Future<Either<User, ErrorMessage>> queryUserData(
      String queryString) async {
    try {
      String token = GlobalConfig.instance.authToken;
      final result = await _httpClientConn.get(
        "$_hostUrl/api/v1/admin/user/queryUserInfo/$queryString",
        options: Options(headers: {
          'Authorization': token,
        }, sendTimeout: 10000),
      );
      return Left(User.fromJson(result.data["user"]));
    } catch (e, stackTrace) {
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

  /// query user data
  static Future<Either<User, ErrorMessage>> getUser(int userId) async {
    try {
      String token = GlobalConfig.instance.authToken;
      //TODO: call get user by id route
      final result = await _httpClientConn.get(
        "$_hostUrl/api/v1/admin/user/queryUserInfo/$userId",
        options: Options(headers: {
          'Authorization': token,
        }, sendTimeout: 10000),
      );
      return Left(User.fromJson(result.data["user"]));
    } catch (e) {
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }

  ///delete group
  static Future<Either<GroupDTO, ErrorMessage>> deleteGroup(
      String groupId) async {
    try {
      String token = GlobalConfig.instance.authToken;
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
          image: result.data['image'],
        ),
      );
    } catch (e, stackTrace) {
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

  static Future<Either<InfoMessage, ErrorMessage>> rateCounsellor(
      String counsellorId, double rate) async {
    try {
      String token = GlobalConfig.instance.authToken;
      await _httpClientConn.post(
        "$_hostUrl/api/v1/admin/user/counsellor/rate/$counsellorId",
        options: Options(headers: {
          'Authorization': token,
        }, sendTimeout: 10000),
        data: json.encode(
          {"rate": rate},
        ),
      );
      return Left(
        InfoMessage("Rating sucessfuly", MessageType.success),
      );
    } catch (e, stackTrace) {
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
}
