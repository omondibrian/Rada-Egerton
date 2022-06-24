import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:rada_egerton/data/entities/UserDTO.dart';
import 'package:rada_egerton/data/entities/group_dto.dart';
import 'package:rada_egerton/data/services/counseling_service.dart';
import 'package:rada_egerton/data/status.dart';
import 'package:rada_egerton/resources/utils/main.dart';

/// Manage state for  Forumns, Groups, Users
class RadaApplicationProvider with ChangeNotifier {
  List<GroupDTO> groups = [];
  ServiceStatus groupStatus = ServiceStatus.initial;
  List<GroupDTO> subscribedForumns = [];
  ServiceStatus subscribedForumnsStatus = ServiceStatus.initial;
  List<GroupDTO> allForumns = [];
  ServiceStatus allForumnsStatus = ServiceStatus.initial;
  List<User> users = [];

  RadaApplicationProvider() {
    initAllForumns();
    initGroups();
    initUserForumns();
  }

  Future<void> initUserForumns() async {
    subscribedForumnsStatus = ServiceStatus.loading;
    notifyListeners();
    final res = await CounselingService.userForums();
    res.fold(
      (forumns) {
        subscribedForumns = forumns;
        subscribedForumnsStatus = ServiceStatus.loadingSuccess;
        notifyListeners();
      },
      (r) {
        subscribedForumnsStatus = ServiceStatus.loadingFailure;
        notifyListeners();
      },
    );
  }

  Future<void> initAllForumns() async {
    allForumnsStatus = ServiceStatus.loading;
    notifyListeners();
    //TODO: replace to a call to all forumns
    final res = await CounselingService.userForums();
    res.fold(
      (forumns) {
        allForumns = forumns;
        allForumnsStatus = ServiceStatus.loadingSuccess;
        notifyListeners();
      },
      (r) {
        allForumnsStatus = ServiceStatus.loadingFailure;
        notifyListeners();
      },
    );
  }

  Future<void> initGroups() async {
    groupStatus = ServiceStatus.loading;
    notifyListeners();
    final res = await CounselingService.fetchGroups();
    res.fold(
      (groups) {
        groups = groups;
        groupStatus = ServiceStatus.loadingSuccess;
        notifyListeners();
      },
      (r) {
        groupStatus = ServiceStatus.loadingFailure;
        notifyListeners();
      },
    );
  }

  Future<InfoMessage> createNewGroup(
      String name, String desc, File? imageFile) async {
    late InfoMessage info;
    final result = await CounselingService.createGroup(name, desc, imageFile);
    result.fold(
      (group) {
        info = InfoMessage("Created successfuly", MessageType.success);
      },
      (error) {
        info = InfoMessage(error.message, MessageType.error);
      },
    );
    return info;
  }

  Future<Either<User, InfoMessage>> getUser({required int userId}) async {
    for (User u in users) {
      if (u.id == userId) {
        return Left(u);
      }
    }
    try {
      late User user;
      final res = await CounselingService.getUser(userId);
      res.fold(
        (user_) {
          users.add(user_);
          user = user_;
        },
        (errorMessage) => throw (errorMessage),
      );
      return Left(user);
    } on ErrorMessage catch (e) {
      return Right(
        InfoMessage(e.message, MessageType.error),
      );
    }
  }
}
