import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:rada_egerton/services/utils.dart';
import 'package:rada_egerton/entities/AuthDTO.dart';
import 'package:rada_egerton/entities/UserDTO.dart';
import 'package:rada_egerton/services/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class AuthServiceProvider {
  String _hostUrl = BASE_URL;
  Dio _httpClientConn = Dio();

  Future<bool> isConnected() => InternetConnectionChecker().hasConnection;

  Future<Either<void, ErrorMessage>> registerNewUser(AuthDTO user) async {
    try {
      final result = await this._httpClientConn.post(
          "${this._hostUrl}/api/v1/admin/user/register",
          data: user.toJson());
    } on DioError catch (e) {
      Right(
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
      print(result.data["payload"]["token"]);
    } on DioError catch (e) {
      Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
    return left(null);
  }

  Future<Either<UserDTO, ErrorMessage>?> updateProfile(UserDTO data) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    try {
      String authToken = await ServiceUtility.getAuthToken() as String;
      var _profile = await this._httpClientConn.put(
          "${this._hostUrl}/api/v1/admin/user/profile",
          options: Options(
              headers: {'Authorization': authToken}, sendTimeout: 10000),
          data: data);
      return this._saveUser(_profile, _prefs);
    } on DioError catch (e) {
      Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }

  Future<Either<UserDTO, ErrorMessage>?> getProfile() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    try {
      final authToken = await ServiceUtility.getAuthToken();
      String? _user = _prefs.getString("user");
      print(_user);
      if (_user == null) {
        print('usrs gfjfhfh');
        var _profile = await this._httpClientConn.get(
              "${this._hostUrl}/api/v1/admin/user/profile",
              options: Options(
                  headers: {'Authorization': authToken}, sendTimeout: 10000),
            );
        // print(_profile.data);
        return _saveUser(_profile, _prefs);
      }
      return Left(UserDTO.fromJson(json.decode(_user)));
    } on DioError catch (e) {
      Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
    // return null;
  }

  _saveUser(Response<dynamic> _profile, SharedPreferences _prefs) {
    var user = UserDTO.fromJson(_profile.data["user"]);
    _prefs.setString("user", userDtoToJson(user));
    return Left(user);
  }
}
