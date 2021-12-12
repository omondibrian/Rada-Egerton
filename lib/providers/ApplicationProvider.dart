import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rada_egerton/entities/UserDTO.dart';
import 'package:rada_egerton/entities/userRoles.dart';
import 'package:rada_egerton/services/auth/main.dart';
import 'package:rada_egerton/services/counseling/main.dart';
import 'package:rada_egerton/utils/main.dart';

class RadaApplicationProvider with ChangeNotifier {
  UserDTO? _user;
  UserRole userRole = UserRole([]);
  CounselingServiceProvider _serviceProvider = CounselingServiceProvider();
  UserDTO? get user {
    return this._user;
  }

  RadaApplicationProvider() {
    this.init();
  }

  void clearState(){
    this.userRole = UserRole([]);
  }

  Future<void> init() async {
    var result = await AuthServiceProvider().getProfile();
    result!.fold((user) async {
      this._user = user;
      var role = await AuthServiceProvider().getUserRoles(user.id);
      role.fold((_userRole) => {userRole = _userRole}, (r) => {});
    }, (error) => print(error));
    notifyListeners();
  }

  Future<InfoMessage> leaveGroup(String grpId) async {
    final result = await _serviceProvider.exitGroup(grpId);
    late InfoMessage _info;
    result!.fold((l) {
      _info = InfoMessage("You have left the group", InfoMessage.success);
    }, (error) {
      _info = InfoMessage(error.message, InfoMessage.error);
    });
    return _info;
  }

  Future<InfoMessage> createNewGroup(String name, String desc,File? imageFile) async {
    late InfoMessage _info;
    final result = await _serviceProvider.createGroup(name, desc,imageFile);
    result!.fold((group) {
      //TODO:- add group to state
      _info = InfoMessage("Created successfuly", InfoMessage.success);
    }, (error) {
      _info = InfoMessage(error.message, InfoMessage.error);
    });
    return _info;
  }

  Future<InfoMessage> joinGroup(String grpId) async {
    late InfoMessage _info;
    final result = await _serviceProvider.subToNewGroup(this._user!.id, grpId);
    result!.fold((group) {
      _info = InfoMessage("Joined successfuly", InfoMessage.success);
    }, (error) {
      _info = InfoMessage(error.message, InfoMessage.error);
    });
    return _info;
  }
}
