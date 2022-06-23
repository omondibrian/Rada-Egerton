import 'package:flutter/foundation.dart';
import 'package:rada_egerton/data/entities/UserDTO.dart';
import 'package:rada_egerton/data/services/auth_service.dart';
import 'package:rada_egerton/data/status.dart';

class AuthenticationProvider with ChangeNotifier {
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
    await AuthService.logout();
    notifyListeners();
  }
}
