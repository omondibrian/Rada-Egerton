import 'package:flutter/foundation.dart';
import 'package:rada_egerton/data/entities/user_dto.dart';
import 'package:rada_egerton/data/status.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationProvider with ChangeNotifier {
  AuthenticationProvider._();
  static final instance = AuthenticationProvider._();

  AuthenticationStatus status = AuthenticationStatus.unkown;
  User user = User.empty();
  String authToken = "";

  void authenticationChanged(AuthenticationStatus status) {
    this.status = status;
    notifyListeners();
  }

  void loginUser({required User user, required String authToken}) {
    this.user = user;
    this.authToken = authToken;
    status = AuthenticationStatus.authenticated;
    notifyListeners();
  }

  void logout() async {
    status = AuthenticationStatus.unAuthenticated;
    user = User.empty();
    authToken = "";
    SharedPreferences.getInstance().then((pref) => pref.clear());
    notifyListeners();
  }

  void inialize({User? user, String? authToken}) {
    this.user = user ?? this.user;
    this.authToken = authToken ?? this.authToken;
  }
}
