import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:rada_egerton/constants.dart';
import 'package:rada_egerton/entities/userRoles.dart';
import 'package:rada_egerton/utils/main.dart';
import 'package:rada_egerton/entities/AuthDTO.dart';
import 'package:rada_egerton/entities/UserDTO.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class AuthServiceProvider {
  String _hostUrl = BASE_URL;
  Dio _httpClientConn = Dio();

  Future<bool> isConnected() => InternetConnectionChecker().hasConnection;

  Future<Either<void, ErrorMessage>> registerNewUser(AuthDTO user) async {
    try {
      await this._httpClientConn.post(
          "${this._hostUrl}/api/v1/admin/user/register",
          data: user.toJson());
    } on DioError catch (e) {
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
    return left(null);
  }

  Future<Either<void, ErrorMessage>> logInUser(
      String email, String password) async {
    try {
      final result = await this._httpClientConn.post(
          "${this._hostUrl}/api/v1/admin/user/login",
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

  Future<Either<UserDTO, ErrorMessage>> updateProfile(UserDTO data) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    try {
      String authToken = await ServiceUtility.getAuthToken() as String;
      var _profile = await this._httpClientConn.put(
          "${this._hostUrl}/api/v1/admin/user/profile",
          options: Options(
              headers: {'Authorization': authToken}, sendTimeout: 10000),
          data: json.encode({
            'name': data.userName,
            "phone": data.phone,
          }));

      UserDTO user = UserDTO.fromJson(_profile.data["user"]);
      _prefs.setString("user", userDtoToJson(user));
      return Left(user);
    } on DioError catch (e) {
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }

  Future<Either<UserRole, ErrorMessage>> getUserRoles(String userId) async {
    try {
      String authToken = await ServiceUtility.getAuthToken() as String;
      var _result = await this._httpClientConn.get(
            "${this._hostUrl}/api/v1/admin/role/$userId",
            options: Options(
                headers: {'Authorization': authToken}, sendTimeout: 10000),
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

  Future<Either<UserDTO, ErrorMessage>?> getProfile() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    try {
      final authToken = await ServiceUtility.getAuthToken();
      String? _user = _prefs.getString("user");

      if (_user == null) {
        print('usrs gfjfhfh');
        var _profile = await this._httpClientConn.get(
              "${this._hostUrl}/api/v1/admin/user/profile",
              options: Options(
                  headers: {'Authorization': authToken}, sendTimeout: 10000),
            );
        // print(_profile.data);
        UserDTO user = UserDTO.fromJson(_profile.data["user"]);
        _prefs.setString("user", userDtoToJson(user));
        return Left(user);
      }
      return Left(UserDTO.fromJson(json.decode(_user)));
    } on DioError catch (e) {
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
    // return null;
  }

  Future<Either<UserDTO, ErrorMessage>?> getStudentProfile(
      String userId) async {
    try {
      final authToken = await ServiceUtility.getAuthToken();
      var _profile = await this._httpClientConn.get(
            "${this._hostUrl}/api/v1/admin/user/studentprofile/$userId",
            options: Options(
                headers: {'Authorization': authToken}, sendTimeout: 10000),
          );
      UserDTO user = UserDTO.fromJson(_profile.data["user"]);
      return Left(user);
    } on DioError catch (e) {
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }
}
