import '../constants.dart';
import 'package:dio/dio.dart';

class AuthServiceProvider {
  String _hostUrl = BASE_URL;
  Dio _httpClientConn = Dio();

  registerNewUser(UserDTO user) async {
    final result = await this._httpClientConn.post(
        this._hostUrl + '/api/v1/admin/user/register',
        data: user.toJson());
    print(result);
  }
}

class UserDTO {
  String _email = "";
  String _password = "";
  String _userName = "";

  UserDTO({email, password, userName}) {
    this._email = email;
    this._password = password;
    this._userName = userName;
  }

  ///
  ///converts object to json field
  ///

  toJson() {
    return {
      "email": this._email,
      "password": this._password,
      "userName": this._userName
    };
  }
}
