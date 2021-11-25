import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import 'package:dio/dio.dart';

class AuthServiceProvider {
  String _hostUrl = BASE_URL;
  Dio _httpClientConn = Dio();

  Future<void> registerNewUser(AuthDTO user) async {
    final result = await this._httpClientConn.post(
        "${this._hostUrl}/api/v1/admin/user/register",
        data: user.toJson());
    print(result);
  }

  Future<void> logInUser(String email, String password) async {
    final result = await this._httpClientConn.post(
        "${this._hostUrl}/api/v1/admin/user/login",
        data: {'email': email, 'password': password});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('TOKEN', result.data["payload"]["token"]);
    print(result.data["payload"]["token"]);
  }

  Future<String?> getAuthToken() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final token = _prefs.getString("TOKEN");
    return token;
  }

  Future<UserDTO?> updateProfile(UserDTO data) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    try {
      String authToken = this.getAuthToken().toString();

      var _profile = await this._httpClientConn.put(
          "${this._hostUrl}/api/v1/admin/user/profile",
          options: Options(
              headers: {'Authorization': authToken}, sendTimeout: 10000),
          data: data);
      print(_profile.data);
      _prefs.setString("user", jsonEncode(_profile.data));
      return UserDTO(
        email: _profile.data['user']['email'],
        id: _profile.data['user']['_id'],
        dob: _profile.data['user']['dob'],
        userName: _profile.data['user']['userName'],
        phone: _profile.data['user']['phone'],
        profilePic: _profile.data['user']['profilePic'],
        gender: _profile.data['user']['gender'],
      );
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<UserDTO?> getProfile() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    try {
      final authToken = await this.getAuthToken();
      print('authToken  = $authToken');
      
      var _profile = await this._httpClientConn.get(
            "${this._hostUrl}/api/v1/admin/user/profile",
            options: Options(
                headers: {'Authorization': authToken}, sendTimeout: 10000),
          );
      
      _prefs.setString("user", jsonEncode(_profile.data));
      var results = UserDTO(
        email: _profile.data['user']['email'],
        id: _profile.data['user']['_id'].toString(),
        dob: _profile.data['user']['dob'] == 'undefined'
            ? 'default'
            : _profile.data['user']['dob'],
        userName: _profile.data['user']['name'],
        phone: _profile.data['user']['phone'],
        profilePic: _profile.data['user']['profilePic'],
        gender: _profile.data['user']['gender'],
      );
      
      return results;
    } catch (e) {
      print(e);
    }
    // return null;
  }
}

class AuthDTO {
  String _email = "";
  String _password = "";
  String _userName = "";
  String _university = "";

  AuthDTO({email, password, userName, university}) {
    this._email = email;
    this._password = password;
    this._userName = userName;
    this._university = university;
  }

  ///
  ///converts object to json field
  ///

  toJson() {
    return {
      "email": this.getEmail(),
      "password": this.getPassword(),
      "university": this.getUniversity()
    };
  }

  String getEmail() => this._email;
  String getPassword() => this._password;
  String getUsername() => this._userName;
  String getUniversity() => this._university;
}

class UserDTO {
  String email = "";
  String userName = "";
  String phone = "";
  String profilePic = "";
  String dob = "";
  String id = "";
  String gender = "";

  UserDTO({email, userName, phone, profilePic, dob, id, gender}) {
    this.id = id;
    this.email = email;
    this.userName = userName;
    this.phone = phone;
    this.profilePic = profilePic;
    this.dob = dob;
    this.gender = gender;
  }
}
