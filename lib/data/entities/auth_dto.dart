import 'package:equatable/equatable.dart';
import 'package:rada_egerton/data/entities/user_dto.dart';

class AuthDTO extends Equatable {
  String _email = "";
  String _password = "";
  String _userName = "";
  String _university = "";

  AuthDTO({email, password, userName, university}) {
    _email = email;
    _password = password;
    _userName = userName;
    _university = university;
  }

  ///
  ///converts object to json field
  ///

  toJson() {
    return {
      "email": getEmail(),
      "password": getPassword(),
      "university": getUniversity()
    };
  }

  String getEmail() => _email;
  String getPassword() => _password;
  String getUsername() => _userName;
  String getUniversity() => _university;

  @override
  // TODO: implement props
  List<Object?> get props => [
        _email,
        _password,
        _userName,
        _university,
      ];
}

class LoginData {
  final User user;
  final String authToken;
  LoginData({required this.user, required this.authToken});
}
