import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:rada_egerton/data/entities/user_dto.dart';
import 'package:rada_egerton/data/entities/group_dto.dart';
import 'package:rada_egerton/data/services/counseling_service.dart';
import 'package:rada_egerton/data/status.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/resources/utils/main.dart';

/// Manage state for  Forums, Groups, Users
class RadaApplicationProvider with ChangeNotifier {
  List<GroupDTO> groups = [];
  ServiceStatus groupStatus = ServiceStatus.initial;
  List<GroupDTO> subscribedForums = [];
  ServiceStatus subscribedForumsStatus = ServiceStatus.initial;
  List<GroupDTO> allForums = [];
  ServiceStatus allForumsStatus = ServiceStatus.initial;
  List<User> users = [];

  GroupDTO getForum(String forumId) {
    return allForums.firstWhere((element) => element.id == forumId);
  }

  GroupDTO getGroup(String groupId) {
    return groups.firstWhere((element) => element.id == groupId);
  }

  bool isSubscribedToForum(GroupDTO forum) {
    for (var f in subscribedForums) {
      if (f.id == forum.id) {
        return true;
      }
    }
    return false;
  }

  RadaApplicationProvider() {
    initAllForums();
    initGroups();
    initUserForums();
  }

  Future<void> initUserForums() async {
    subscribedForumsStatus = ServiceStatus.loading;
    notifyListeners();
    //TODO: replace to a call to subscribed forums

    final res = await CounselingService.userForums();
    res.fold(
      (forums) {
        subscribedForums = forums;
        subscribedForumsStatus = ServiceStatus.loadingSuccess;
        notifyListeners();
      },
      (r) {
        subscribedForumsStatus = ServiceStatus.loadingFailure;
        notifyListeners();
      },
    );
  }

  Future<void> initAllForums() async {
    allForumsStatus = ServiceStatus.loading;
    notifyListeners();
    final res = await CounselingService.userForums();
    res.fold(
      (forums) {
        allForums = forums;
        allForumsStatus = ServiceStatus.loadingSuccess;
        notifyListeners();
      },
      (r) {
        allForumsStatus = ServiceStatus.loadingFailure;
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
    //TODO: implement get user by id
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

  Future<InfoMessage> joinForum(String forumId) async {
    late InfoMessage message;

    final res = await CounselingService.subToNewGroup(
      GlobalConfig.instance.user.id.toString(),
      forumId,
    );
    res.fold(
      (forum) {
        subscribedForums.add(forum);
        notifyListeners();
        message = InfoMessage(
          "You have joined the forum",
          MessageType.success,
        );
      },
      (error) => message = InfoMessage.fromError(error),
    );
    return message;
  }
}
