import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import 'package:dio/dio.dart';

class AuthServiceProvider {
  String _hostUrl = BASE_URL;
  Dio _httpClientConn = Dio();

  registerNewUser(UserDTO user) async {
    final result = await this._httpClientConn.post(
        "${this._hostUrl}/api/v1/admin/user/register",
        data: user.toJson());
    print(result);
  }

  logInUser(String email, String password) async {
    final result = await this._httpClientConn.post(
        "${this._hostUrl}/api/v1/admin/user/login",
        data: {'email': email, 'password': password});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('TOKEN', result.data["payload"]["token"]);
    print(result.data["payload"]["token"]);
  }
}

class UserDTO {
  String _email = "";
  String _password = "";
  String _userName = "";
  String _university = "";

  UserDTO({email, password, userName, university}) {
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
