import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rada_egerton/data/entities/userRoles.dart';
import 'package:rada_egerton/data/services/counseling_service.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/resources/utils/main.dart';
//TODO: organize this file

class RadaApplicationProvider with ChangeNotifier {
  UserRole userRole = UserRole([]);
  final CounselingServiceProvider _serviceProvider = CounselingServiceProvider();


  void clearState() {
    userRole = UserRole([]);
  }

  Future<InfoMessage> leaveGroup(String grpId) async {
    final result = await _serviceProvider.exitGroup(grpId);
    late InfoMessage info;
    result!.fold((l) {
      info = InfoMessage("You have left the group", InfoMessage.success);
    }, (error) {
      info = InfoMessage(error.message, InfoMessage.error);
    });
    return info;
  }

  Future<InfoMessage> createNewGroup(
      String name, String desc, File? imageFile) async {
    late InfoMessage info;
    final result = await _serviceProvider.createGroup(name, desc, imageFile);
    result!.fold((group) {
      //TODO:- add group to state
      info = InfoMessage("Created successfuly", InfoMessage.success);
    }, (error) {
      info = InfoMessage(error.message, InfoMessage.error);
    });
    return info;
  }

  Future<InfoMessage> joinGroup(String grpId) async {
    late InfoMessage info;
    final result = await _serviceProvider.subToNewGroup(
      GlobalConfig.instance.user.id.toString(),
      grpId,
    );
    result!.fold((group) {
      info = InfoMessage(
        "Joined successfuly",
        InfoMessage.success,
      );
    }, (error) {
      info = InfoMessage(error.message, InfoMessage.error);
    });
    return info;
  }
}
