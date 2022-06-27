import 'package:flutter/material.dart';
import 'package:rada_egerton/data/entities/counsellors_dto.dart';
import 'package:rada_egerton/data/entities/peer_counsellor_dto.dart';
import 'package:rada_egerton/data/status.dart';
import 'package:rada_egerton/resources/utils/main.dart';

import '../services/counseling_service.dart';

class CounsellingProvider with ChangeNotifier {
  CounsellingProvider() {
    initCounsellors();
    initPeerCounsellors();
  }

  List<PeerCounsellorDto> peerCounsellors = [];
  List<Counsellor> counsellors = [];
  ServiceStatus peerStatus = ServiceStatus.loading;
  ServiceStatus counsellorStatus = ServiceStatus.loading;

  Counsellor getCounsellor({required int userId}) {
    return counsellors.firstWhere((c) => c.user.id == userId);
  }

  PeerCounsellorDto getperCounsellor({required int userId}) {
    return peerCounsellors.firstWhere((c) => c.user.id == userId);
  }

  Future<InfoMessage?> initCounsellors() async {
    counsellorStatus = ServiceStatus.loading;
    notifyListeners();
    final res = await CounselingService.fetchCounsellors();
    try {
      res.fold(
        (counsellors) => this.counsellors = counsellors,
        (errorMessage) => throw (errorMessage),
      );
      counsellorStatus = ServiceStatus.loadingSuccess;
      notifyListeners();
    } on ErrorMessage catch (e) {
      counsellorStatus = ServiceStatus.loadingFailure;
      notifyListeners();
      return InfoMessage(e.message, MessageType.error);
    }
    return null;
  }

  Future<InfoMessage?> initPeerCounsellors() async {
    peerStatus = ServiceStatus.loading;
    notifyListeners();
    final res = await CounselingService.fetchPeerCounsellors();
    try {
      res.fold(
        (counsellors) => peerCounsellors = counsellors,
        (errorMessage) => throw (errorMessage),
      );
      peerStatus = ServiceStatus.loadingSuccess;
      notifyListeners();
    } on ErrorMessage catch (e) {
      peerStatus = ServiceStatus.loadingFailure;
      notifyListeners();
      return InfoMessage(e.message, MessageType.error);
    }
    return null;
  }
}
