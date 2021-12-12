import 'package:flutter/material.dart';
import 'package:rada_egerton/entities/GroupsDTO.dart';
import 'package:rada_egerton/entities/CounsellorsDTO.dart';
import 'package:rada_egerton/services/counseling/main.dart';
import 'package:rada_egerton/entities/PeerCounsellorDTO.dart';
import 'package:rada_egerton/utils/main.dart';

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
}
