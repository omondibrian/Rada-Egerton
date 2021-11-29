import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:rada_egerton/services/utils.dart';
import 'package:rada_egerton/entities/AuthDTO.dart';
import 'package:rada_egerton/entities/UserDTO.dart';
import 'package:rada_egerton/services/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServiceProvider {
  String _hostUrl = BASE_URL;
  Dio _httpClientConn = Dio();

  Future<Either<void, ErrorMessage>> registerNewUser(AuthDTO user) async {
    try {
      final result = await this._httpClientConn.post(
          "${this._hostUrl}/api/v1/admin/user/register",
          data: user.toJson());
      print(result);
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
      print(_profile.data);
      _prefs.setString("user", jsonEncode(_profile.data));
      return Left(
        UserDTO(
          email: _profile.data['user']['email'],
          id: _profile.data['user']['_id'],
          dob: _profile.data['user']['dob'],
          userName: _profile.data['user']['userName'],
          phone: _profile.data['user']['phone'],
          profilePic: _profile.data['user']['profilePic'],
          gender: _profile.data['user']['gender'],
        ),
      );
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
      print('authToken  = $authToken');

      var _profile = await this._httpClientConn.get(
            "${this._hostUrl}/api/v1/admin/user/profile",
            options: Options(
                headers: {'Authorization': authToken}, sendTimeout: 10000),
          );

      _prefs.setString("user", jsonEncode(_profile.data));
      return Left(
        UserDTO(
          email: _profile.data['user']['email'],
          id: _profile.data['user']['_id'].toString(),
          dob: _profile.data['user']['dob'] == 'undefined'
              ? 'default'
              : _profile.data['user']['dob'],
          userName: _profile.data['user']['name'],
          phone: _profile.data['user']['phone'],
          profilePic: _profile.data['user']['profilePic'],
          gender: _profile.data['user']['gender'],
        ),
      );
    } on DioError catch (e) {
      Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
    // return null;
  }
}
