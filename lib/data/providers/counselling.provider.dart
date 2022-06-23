import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:rada_egerton/data/database/sqlite.dart';

import 'package:rada_egerton/data/entities/CounsellorsDTO.dart';
import 'package:rada_egerton/data/entities/GroupsDTO.dart';
import 'package:rada_egerton/data/entities/StudentDTO.dart';
import 'package:rada_egerton/data/entities/UserDTO.dart';
import 'package:rada_egerton/data/services/counseling_service.dart';
import 'package:rada_egerton/data/entities/PeerCounsellorDTO.dart';
import 'package:rada_egerton/resources/utils/main.dart';

class CounsellorProvider with ChangeNotifier {
  List<Counsellor>? _counsellors;
  List<PeerCounsellorDto>? _peerCounsellors;
  CounselingServiceProvider _service = CounselingServiceProvider();
  GroupsDto? _forums;
  DBManager dbManager = DBManager.instance;
  bool counsellorsLoading = true;
  bool peerCouselorsLoading = true;
  bool isForumLoading = true;

  CounsellorProvider() {
    getPeerCounsellors();
    getForums();
  }

  List<Counsellor>? get counsellors {
    if (_counsellors == null) {
      getCounsellors();
    }
    return _counsellors;
  }

  GroupsDto? get forums {
    return _forums;
  }

  Counsellor? counsellorById(int userId) {
    Counsellor? result;
    for (var i = 0; i < _counsellors!.length; i++) {
      if (_counsellors![i].user.id == userId) {
        result = _counsellors![i];
      }
    }
    return result;
  }

  List<PeerCounsellorDto>? get peerCounsellors {
    if (_peerCounsellors == null) {
      getPeerCounsellors();
    }
    return _peerCounsellors;
  }

  Future<Either<StudentDto, InfoMessage>> getStudentBio(String id) async {
    var result;
    var student = await _service.fetchStudentData(id);
    student!.fold(
      (student) => result = student,
      (error) => throw InfoMessage(error.message, MessageType.error),
    );

    return result;
  }

  Future<InfoMessage>? getForums() async {
    late InfoMessage info;
    var results = await _service.fetchStudentForums();
    results!.fold((forums) {
      _forums = forums;
      info = InfoMessage("Fetching forums  successfull", MessageType.success);
    }, (error) => {info = InfoMessage(error.message, MessageType.error)});
    isForumLoading = false;
    notifyListeners();
    return info;
  }

  Future<InfoMessage> deleteGroupOrForum(String id) async {
    late InfoMessage info;
    var results = await _service.deleteGroup(id);
    results.fold((group) {
      //TODO: update state after deleting a group
      InfoMessage("Deleted successfuly", MessageType.success);
    }, (error) => {info = InfoMessage(error.message, MessageType.error)});
    isForumLoading = false;
    notifyListeners();
    return info;
  }

  Future<InfoMessage?> getCounsellors() async {
    InfoMessage? message;
    await _service.fetchCounsellors().then((res) {
      res.fold((counsellors) async {
        //update counsellors with data from the server
        _counsellors = counsellors;
        //update the database - store user and counselloe
        for (int i = 0; i < _counsellors!.length; ++i) {
          dbManager.insertItem(counsellors[i].user, tableName: TableNames.user);
          dbManager.insertItem(counsellors[i],
              tableName: TableNames.counsellor);
        }

        notifyListeners();
        message =
            InfoMessage("Fetch counsellors successful", MessageType.success);
      }, (error) => {message = InfoMessage(error.message, MessageType.error)});
    });
    return message;
  }

  Future<InfoMessage> getPeerCounsellors() async {
    late InfoMessage message;
    await _service.fetchPeerCounsellors().then((res) {
      res.fold((peercounsellors) {
        //update peer counsellors with data from the server

        _peerCounsellors = peercounsellors;
        //update the database
        for (int i = 0; i < _counsellors!.length; ++i) {
          dbManager.insertItem(peercounsellors[i].user,
              tableName: TableNames.user);
          dbManager.insertItem(peercounsellors[i],
              tableName: TableNames.peerCounsellor);
        }
        notifyListeners();
        message = InfoMessage(
          "Fetch counsellors successful",
          MessageType.success,
        );
      }, (error) => {message = InfoMessage(error.message, MessageType.error)});
    });
    return message;
  }

  User? getUser(String userType, int userId, List<StudentDto> students) {
    if (userType == 'counsellor') {
      final res = counsellorById(userId);
      return res?.user;
    }
    if (userType == 'peerCounsellor') {
      for (var i = 0; i < peerCounsellors!.length; i++) {
        if (peerCounsellors![i].user.id == userId) {
          return peerCounsellors![i].user;
        }
      }
    } else {
      for (var i = 0; i < students.length; i++) {
        if (students[i].user.id == userId) {
          return students[i].user;
        }
      }
    }
    return null;
  }
}
