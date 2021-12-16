import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:rada_egerton/entities/CounsellorsDTO.dart';
import 'package:rada_egerton/entities/GroupsDTO.dart';
import 'package:rada_egerton/entities/StudentDTO.dart';
import 'package:rada_egerton/entities/UserDTO.dart';
import 'package:rada_egerton/services/counseling/main.dart';
import 'package:rada_egerton/entities/PeerCounsellorDTO.dart';
import 'package:rada_egerton/utils/main.dart';
import 'package:rada_egerton/utils/sqlite.dart';

class CounsellorProvider with ChangeNotifier {
  List<Counsellor>? _counsellors;
  List<PeerCounsellorDto>? _peerCounsellors;
  CounselingServiceProvider _service = CounselingServiceProvider();
  GroupsDto? _forums;
  DBManager dbManager = DBManager();
  bool counsellorsLoading = true;
  bool peerCouselorsLoading = true;
  bool isForumLoading = true;

  CounsellorProvider() {
    getCounsellors();
    getCounsellors();
    getForums();
  }

  List<Counsellor> get counsellors {
    if (this._counsellors == null) {
      getCounsellors();
      return [];
    }
    return [...this._counsellors!];
  }

  GroupsDto? get forums {
    return this._forums;
  }

  Counsellor? counsellorById(int userId) {
    Counsellor? result;
    for (var i = 0; i < this._counsellors!.length; i++) {
      if (this._counsellors![i].user.id == userId) {
        result = this._counsellors![i];
      }
    }
    return result;
  }

  List<PeerCounsellorDto> get peerCounsellors {
    if (this._peerCounsellors == null) {
      getPeerCounsellors();
      return [];
    }
    return [...this._peerCounsellors!];
  }

  Future<Either<StudentDto, InfoMessage>> getStudentBio(String id) async {
    var result;
    var student = await _service.fetchStudentData(id);
    student!.fold(
      (student) => result = student,
      (error) => throw new InfoMessage(error.message, InfoMessage.error),
    );

    return result;
  }

  Future<InfoMessage>? getForums() async {
    late InfoMessage _info;
    var results = await _service.fetchStudentForums();
    results!.fold((forums) {
      this._forums = forums;
      _info = InfoMessage("Fetching forums  successfull", InfoMessage.success);
    }, (error) => {_info = InfoMessage(error.message, InfoMessage.error)});
    this.isForumLoading = false;
    notifyListeners();
    return _info;
  }

  Future<InfoMessage> deleteGroupOrForum(String id) async {
    late InfoMessage _info;
    var results = await _service.deleteGroup(id);
    results.fold((_group) {
      //TODO: update state after deleting a group
      InfoMessage("Deleted successfuly", InfoMessage.success);
    }, (error) => {_info = InfoMessage(error.message, InfoMessage.error)});
    this.isForumLoading = false;
    notifyListeners();
    return _info;
  }

  Future<InfoMessage?> getCounsellors() async {
    InfoMessage? message;
    await dbManager.db.then((db) async {
      final _res = await db.rawQuery("""
          SELECT * FROM  ${Counsellor.tableName_} 
          INNER JOIN  ${User.tableName_} 
          ON ${Counsellor.tableName_}._id = ${User.tableName_}._id""", []);

      this._counsellors =
          List<Counsellor>.from(_res.map((item) => Counsellor.fromJson(item)));
      notifyListeners();
    });
    _service.fetchCounsellors().then((res) {
      res.fold((counsellors) {
        //update counsellors with data from the server

        this._counsellors = counsellors;
        //update the database
        counsellors.map((counsellor) => dbManager.insertItem(counsellor));
        notifyListeners();
      }, (error) => {message = InfoMessage(error.message, InfoMessage.error)});
    });
    return message;
  }

  Future<InfoMessage?> getPeerCounsellors() async {
    InfoMessage? message;
    await dbManager.db.then((db) async {
      final _res = await db.rawQuery("""
          SELECT * FROM  ${PeerCounsellorDto.tableName_} 
          INNER JOIN  ${User.tableName_} 
          ON ${PeerCounsellorDto.tableName_}._id = ${User.tableName_}._id""",
          []);

      this._peerCounsellors = List<PeerCounsellorDto>.from(
          _res.map((item) => PeerCounsellorDto.fromJson(item)));
      notifyListeners();
    });
    _service.fetchPeerCounsellors().then((res) {
      res.fold((peercounsellors) {
        //update peer counsellors with data from the server

        this._peerCounsellors = peercounsellors;
        //update the database
        peercounsellors.map((counsellor_) {
          dbManager.insertItem(counsellor_);
          dbManager.insertItem(counsellor_.user);
          dbManager.insertItem(counsellor_.user);
        });
        notifyListeners();
      }, (error) => {message = InfoMessage(error.message, InfoMessage.error)});
    });
    return message;
  }

  User? getUser(String userType, int userId, List<StudentDto> students) {
    if (userType == 'counsellor') {
      final res = this.counsellorById(userId);
      return res?.user;
    }
    if (userType == 'peerCounsellor') {
      for (var i = 0; i < this.peerCounsellors.length; i++) {
        if (this.peerCounsellors[i].user.id == userId) {
          return this.peerCounsellors[i].user;
        }
      }
    } else {
      for (var i = 0; i < students.length; i++) {
        if (students[i].user.id == userId) {
          return students[i].user;
        }
      }
    }
  }
}
