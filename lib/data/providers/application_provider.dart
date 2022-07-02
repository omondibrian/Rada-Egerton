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
  ///groups comprises of public forumns which a user subscribes and
  ///private groups which a user is added
  ///
  //User groups and forumns
  List<GroupDTO> groups = [];
  ServiceStatus groupStatus = ServiceStatus.initial;

  //All forumns
  List<GroupDTO> allForums = [];
  ServiceStatus allForumsStatus = ServiceStatus.initial;
  List<User> users = [];

  GroupDTO getGroup(String groupId) {
    return groups.firstWhere((element) => element.id == groupId);
  }

  bool isSubscribedToForum(GroupDTO forum) {
    for (var f in groups) {
      if (f.id == forum.id) {
        return true;
      }
    }
    return false;
  }

  RadaApplicationProvider() {
    initAllForums();
    initGroups();
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

  Future<void> refreshForums() async {
    final res = await CounselingService.userForums();
    res.fold((forums) {
      allForums = forums;
      allForumsStatus = ServiceStatus.loadingSuccess;
      notifyListeners();
    }, (r) => null);
  }

  Future<void> initGroups() async {
    groupStatus = ServiceStatus.loading;
    notifyListeners();
    final res = await CounselingService.fetchGroups();
    res.fold(
      (groups) {
        this.groups = groups;
        groupStatus = ServiceStatus.loadingSuccess;
        notifyListeners();
      },
      (r) {
        groupStatus = ServiceStatus.loadingFailure;
        notifyListeners();
      },
    );
  }

  Future<void> refreshGroups() async {
    final res = await CounselingService.fetchGroups();
    res.fold((groups) {
      this.groups = groups;
      groupStatus = ServiceStatus.loadingSuccess;
      notifyListeners();
    }, (r) => null);
  }

  Future<InfoMessage> createNewGroup(
    String name,
    String desc,
    File? imageFile,
    bool isForumn,
  ) async {
    late InfoMessage info;
    final result = await CounselingService.createGroup(
      name,
      desc,
      imageFile,
      isForumn,
    );

    result.fold(
      (group) {
        groups.add(group);
        if (group.isForum) {
          allForums.add(group);
        }
        info = InfoMessage("Created successfuly", MessageType.success);
        notifyListeners();
      },
      (error) {
        info = InfoMessage(error.message, MessageType.error);
      },
    );
    return info;
  }

  Future<Either<User, InfoMessage>> getUser({required int userId}) async {
    print(users);
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
        groups.add(forum);
        message = InfoMessage(
          "You have joined the forum",
          MessageType.success,
        );
        notifyListeners();
      },
      (error) => message = InfoMessage.fromError(error),
    );
    return message;
  }

  Future<Either<InfoMessage, ErrorMessage>> leaveGroup(String groupId) async {
    try {
      final result = await CounselingService.exitGroup(groupId);
      result.fold(
        (group) {
          groups.remove(group);
          notifyListeners();
        },
        (error) => throw (error),
      );
      return Left(
        InfoMessage("You have left the group", MessageType.success),
      );
    } on ErrorMessage catch (e) {
      return Right(e);
    }
  }

  Future<Either<InfoMessage, ErrorMessage>> deleteGroup(String groupId) async {
    try {
      final result = await CounselingService.deleteGroup(groupId);
      result.fold(
        (group) {
          groups.remove(group);
          allForums.remove(group);
          notifyListeners();
        },
        (error) => throw (error),
      );
      return Left(
        InfoMessage("You have left the group", MessageType.success),
      );
    } on ErrorMessage catch (e) {
      return Right(e);
    }
  }
}
