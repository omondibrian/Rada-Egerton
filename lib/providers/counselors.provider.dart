import 'package:flutter/material.dart';
import 'package:rada_egerton/entities/GroupsDTO.dart';
import 'package:rada_egerton/entities/CounsellorsDTO.dart';
import 'package:rada_egerton/services/counseling/main.dart';
import 'package:rada_egerton/entities/PeerCounsellorDTO.dart';

class CounselorProvider with ChangeNotifier {
  List<CounsellorsDTO> _counselors = [];
  List<PeerCounsellorDto> _peerCounsellors = [];
  CounselingServiceProvider _service = CounselingServiceProvider();
  GroupsDto? _forums;

  bool counselorsLoading = true;
  bool peerCouselorsLoading = true;
  bool isForumLoading = true;

  CounselorProvider() {
    getCounsellors();
    getPeerCounsellors();
    getForums();
  }

  List<CounsellorsDTO> get counselors {
    return [...this._counselors];
  }

  GroupsDto? get forums {
    return this._forums;
  }

  CounsellorsDTO? counselorById(String id) {
    CounsellorsDTO? result;
    for (var i = 0; i < this._counselors.length; i++) {
      if (this._counselors[i].id == id) {
        result = this._counselors[i];
      }
    }
    return result;
  }

  List<PeerCounsellorDto> get peerCounselors {
    return [...this._peerCounsellors];
  }

  getForums() async {
    var results = await _service.fetchStudentForums();
    results!.fold(
      (forums) => {this._forums = forums},
      (error) => print('Error from fetchForums() :${error.message}'),
    );
    this.isForumLoading = false;
    notifyListeners();
  }

  getCounsellors() async {
    final results = await _service.fetchCounsellors();
    results.fold((counsellors) {
      this._counselors = counsellors;
    }, (error) => {});
    counselorsLoading = false;
    notifyListeners();
  }

  getPeerCounsellors() async {
    final results = await _service.fetchPeerCounsellors();
    results.fold(
      (peerCounselors) {
        this._peerCounsellors = peerCounselors;
      },
      (error) => {},
    );
    peerCouselorsLoading = false;
    notifyListeners();
  }
}
