import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:rada_egerton/entities/GroupsDTO.dart';
import 'package:rada_egerton/entities/CounsellorsDTO.dart';
import 'package:rada_egerton/entities/StudentDTO.dart';
import 'package:rada_egerton/entities/UserDTO.dart';
import 'package:rada_egerton/services/counseling/main.dart';
import 'package:rada_egerton/entities/PeerCounsellorDTO.dart';
import 'package:rada_egerton/utils/main.dart';

class CounselorProvider with ChangeNotifier {
  List<Counselor> _counselors = [];
  List<PeerCounsellorDto> _peerCounsellors = [];
  CounselingServiceProvider _service = CounselingServiceProvider();
  GroupsDto? _forums;

  bool counselorsLoading = true;
  bool peerCouselorsLoading = true;
  bool isForumLoading = true;

  void clearState() {
    this._counselors.clear();
    this._peerCounsellors.clear();
    this._forums = null;
  }

  CounselorProvider() {
    getCounsellors();
    getPeerCounsellors();
    getForums();
  }

  List<Counselor> get counselors {
    return [...this._counselors];
  }

  GroupsDto? get forums {
    return this._forums;
  }

  Counselor? counselorById(int userId) {
    Counselor? result;
    for (var i = 0; i < this._counselors.length; i++) {
      if (this._counselors[i].user.id == userId) {
        result = this._counselors[i];
      }
    }
    return result;
  }

  List<PeerCounsellorDto> get peerCounselors {
    return [...this._peerCounsellors];
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

  Future<InfoMessage> getForums() async {
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

  Future<InfoMessage> getCounsellors() async {
    final results = await _service.fetchCounsellors();
    late InfoMessage _info;
    results.fold((counsellors) {
      this._counselors = counsellors;
      _info =
          InfoMessage("fetching counselors  successfull", InfoMessage.success);
    }, (error) => {_info = InfoMessage(error.message, InfoMessage.error)});
    counselorsLoading = false;
    notifyListeners();
    return _info;
  }

  Future<InfoMessage> getPeerCounsellors() async {
    final results = await _service.fetchPeerCounsellors();
    late InfoMessage _info;
    results.fold(
      (peerCounselors) {
        this._peerCounsellors = peerCounselors;
        _info = InfoMessage(
            "fetching peer counselors  successfull", InfoMessage.success);
      },
      (error) {
        _info = InfoMessage(error.message, InfoMessage.error);
      },
    );
    peerCouselorsLoading = false;
    notifyListeners();
    return _info;
  }

  User? getUser(String userType, int userId, List<StudentDto> students) {
    if (userType == 'counsellor') {
      final res = this.counselorById(userId);
      return res?.user;
    }
    if (userType == 'peerCounsellor') {
      for (var i = 0; i < this._peerCounsellors.length; i++) {
        if (this._peerCounsellors[i].user.id == userId) {
          return this._peerCounsellors[i].user;
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
