import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:rada_egerton/data/entities/UserDTO.dart';
import 'package:rada_egerton/data/entities/userRoles.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/resources/utils/main.dart';
import 'package:rada_egerton/data/entities/auth_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class AuthService {
  static String _hostUrl = GlobalConfig.baseUrl;
  static Dio _httpClientConn = httpClient;

  static Future<bool> isConnected() =>
      InternetConnectionChecker().hasConnection;

  static Future<Either<void, ErrorMessage>> registerNewUser(
      AuthDTO user) async {
    try {
      await _httpClientConn.post("${_hostUrl}/api/v1/admin/user/register",
          data: user.toJson());
    } on DioError catch (e) {
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
    return left(null);
  }

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("TOKEN");
    prefs.remove("user");
  }

  static Future<Either<void, ErrorMessage>> logInUser(
      String email, String password) async {
    try {
      final result = await _httpClientConn.post(
          "${_hostUrl}/api/v1/admin/user/login",
          data: {'email': email, 'password': password});

      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString('TOKEN', result.data["payload"]["token"]);
    } on DioError catch (e) {
      Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
    return left(null);
  }

  static Future<Either<User, ErrorMessage>> updateProfile(User data) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    try {
      String authToken = await ServiceUtility.getAuthToken() as String;
      var _profile = await _httpClientConn.put(
          "${_hostUrl}/api/v1/admin/user/profile",
          options: Options(
              headers: {'Authorization': authToken}, sendTimeout: 10000),
          data: json.encode({
            'name': data.name,
            "phone": data.phone,
          }));

      User user = User.fromJson(_profile.data["user"]);
      _prefs.setString("user", userToJson(user));
      return Left(user);
    } on DioError catch (e) {
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }

  static Future<Either<UserRole, ErrorMessage>> getUserRoles(String userId) async {
    try {
      String authToken = await ServiceUtility.getAuthToken() as String;
      var _result = await _httpClientConn.get(
        "${_hostUrl}/api/v1/admin/role/$userId",
        options:
            Options(headers: {'Authorization': authToken}, sendTimeout: 10000),
      );
      Iterable _userRoles = _result.data["userRole"]["role"];
      return Left(
          UserRole(List<String>.from(_userRoles.map((r) => r["name"]))));
    } on DioError catch (e) {
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }

static  Future<Either<User, ErrorMessage>?> getProfile() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    try {
      final authToken = await ServiceUtility.getAuthToken();
      String? _user = _prefs.getString("user");

      if (_user == null) {
        var _profile = await _httpClientConn.get(
          "${_hostUrl}/api/v1/admin/user/profile",
          options: Options(
              headers: {'Authorization': authToken}, sendTimeout: 10000),
        );
        User user = User.fromJson(_profile.data["user"]);
        _prefs.setString("user", userToJson(user));
        return Left(user);
      }
      return Left(User.fromJson(json.decode(_user)));
    } on DioError catch (e) {
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }

  static Future<Either<User, ErrorMessage>?> getStudentProfile(String userId) async {
    try {
      final authToken = await ServiceUtility.getAuthToken();
      var _profile = await _httpClientConn.get(
        "${_hostUrl}/api/v1/admin/user/studentprofile/$userId",
        options:
            Options(headers: {'Authorization': authToken}, sendTimeout: 10000),
      );
      User user = User.fromJson(_profile.data["user"]);
      return Left(user);
    } on DioError catch (e) {
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }
}
