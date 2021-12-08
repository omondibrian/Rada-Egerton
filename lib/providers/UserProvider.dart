import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:rada_egerton/entities/GroupDTO.dart';
import 'package:rada_egerton/entities/UserDTO.dart';
import 'package:rada_egerton/services/auth/main.dart';
import 'package:rada_egerton/services/counseling/main.dart';
import 'package:rada_egerton/utils/main.dart';

class RadaApplicationProvider with ChangeNotifier {
  UserDTO? _user;
  CounselingServiceProvider _serviceProvider = CounselingServiceProvider();
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

  Future<Either<GroupDTO, ErrorMessage>?> joinGroup(String grpId) async {
    return _serviceProvider.subToNewGroup(this._user!.id, grpId);
  }

  Future<Either<GroupDTO, ErrorMessage>?> leftGroup(String grpId) async {
    return _serviceProvider.exitGroup(grpId);
  }
}
