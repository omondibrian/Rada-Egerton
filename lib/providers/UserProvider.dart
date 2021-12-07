import 'package:flutter/material.dart';
import 'package:rada_egerton/entities/UserDTO.dart';
import 'package:rada_egerton/services/auth/main.dart';

class RadaApplicationProvider with ChangeNotifier {
  UserDTO? _user;

  UserDTO? get user {
    return this._user;
  }

  RadaApplicationProvider() {
    print('rada initialised');
    this.fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    var result = await AuthServiceProvider().getProfile();
    result!.fold((user) => {this._user = user}, (error) => print(error));
    notifyListeners();
  }


}
