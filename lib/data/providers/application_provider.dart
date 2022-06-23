import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rada_egerton/data/entities/userRoles.dart';
import 'package:rada_egerton/data/services/counseling/main.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/resources/utils/main.dart';
//TODO: organize this file

class RadaApplicationProvider with ChangeNotifier {
  UserRole userRole = UserRole([]);
  CounselingServiceProvider _serviceProvider = CounselingServiceProvider();

  RadaApplicationProvider() {}

  void clearState() {
    this.userRole = UserRole([]);
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

  Future<InfoMessage> createNewGroup(
      String name, String desc, File? imageFile) async {
    late InfoMessage _info;
    final result = await _serviceProvider.createGroup(name, desc, imageFile);
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
    final result = await _serviceProvider.subToNewGroup(
      GlobalConfig.instance.user.id.toString(),
      grpId,
    );
    result!.fold((group) {
      _info = InfoMessage(
        "Joined successfuly",
        InfoMessage.success,
      );
    }, (error) {
      _info = InfoMessage(error.message, InfoMessage.error);
    });
    return _info;
  }
}
