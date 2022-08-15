import 'dart:async';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rada_egerton/data/entities/user_dto.dart';
import 'package:rada_egerton/data/entities/group_dto.dart';
import 'package:rada_egerton/data/providers/authentication_provider.dart';
import 'package:rada_egerton/data/rest/client.dart';
import 'package:rada_egerton/data/status.dart';
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

//This method is called on spash screen when the app starts
  init() async {
    await initAllForums();
    await initGroups();
  }

  Future<void> initAllForums() async {
    allForumsStatus = ServiceStatus.loading;
    notifyListeners();
    final res = await Client.counselling.forumns();
    res.fold(
      (forums) {
        allForums = forums;
        allForumsStatus = ServiceStatus.loadingSuccess;
        //Init Groups
        notifyListeners();
      },
      (r) {
        allForumsStatus = ServiceStatus.loadingFailure;
        notifyListeners();
      },
    );
  }

  Future<void> refreshForums() async {
    final res = await Client.counselling.forumns();
    res.fold((forums) {
      allForums = forums;
      allForumsStatus = ServiceStatus.loadingSuccess;
      notifyListeners();
      //Refresh also groups
    }, (r) => null);
  }

  Future<void> initGroups() async {
    groupStatus = ServiceStatus.loading;
    notifyListeners();
    final res = await Client.counselling.userGroups();
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
    final res = await Client.counselling.userGroups();
    res.fold((groups) {
      this.groups = groups;
      groupStatus = ServiceStatus.loadingSuccess;
      notifyListeners();
    }, (r) => null);
  }

  Future<InfoMessage> createNewGroup(
      String name, String desc, File? imageFile, bool isForumn,
      {Function(String)? retryLog}) async {
    late InfoMessage info;
    String imageFileName = imageFile!.path.split('/').last;
    FormData formData = FormData.fromMap(
      {
        "image": await MultipartFile.fromFile(imageFile.path,
            filename: imageFileName),
        "title": name,
        "description": desc,
      },
    );
    final result = await Client.counselling.createGroup(
      formData,
      isForumn,
      retryLog: retryLog,
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

  Future<Either<User, InfoMessage>> getUser({
    required int userId,
    Function(String)? retryLog,
  }) async {
    for (User u in users) {
      if (u.id == userId) {
        return Left(u);
      }
    }
    try {
      late User user;
      final res = await Client.users.getUser(
        userId,
        retryLog: retryLog,
      );
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

  Future<InfoMessage> joinForum(String forumId,
      {Function(String)? retryLog}) async {
    late InfoMessage message;
    final res = await Client.counselling.subGroup(
        AuthenticationProvider.instance.user.id.toString(), forumId,
        retryLog: retryLog);
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

  Future<Either<InfoMessage, ErrorMessage>> leaveGroup(String groupId,
      {Function(String)? retryLog}) async {
    final response = Completer<Either<InfoMessage, ErrorMessage>>();
    final result =
        await Client.counselling.exitGroup(groupId, retryLog: retryLog);
    result.fold(
      (group) {
        groups.remove(group);
        notifyListeners();
        response.complete(Left(
          InfoMessage("You have left the group", MessageType.success),
        ));
      },
      (error) => response.complete(
        Right(error),
      ),
    );
    return response.future;
  }

  Future<Either<InfoMessage, ErrorMessage>> deleteGroup(String groupId) async {
    final response = Completer<Either<InfoMessage, ErrorMessage>>();

    final result = await Client.counselling.deleteGroup(groupId);
    result.fold(
      (group) {
        groups.remove(group);
        allForums.remove(group);
        notifyListeners();
        response.complete(
          Left(
            InfoMessage("You have left the group", MessageType.success),
          ),
        );
      },
      (error) => response.complete(
        Right(error),
      ),
    );
    return response.future;
  }
}
