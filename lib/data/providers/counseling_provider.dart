import 'package:flutter/material.dart';
import 'package:rada_egerton/data/entities/CounsellorsDTO.dart';
import 'package:rada_egerton/data/entities/PeerCounsellorDTO.dart';
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
  ServiceStatus peerStatus = ServiceStatus.initial;
  ServiceStatus counsellorStatus = ServiceStatus.initial;

  Counsellor getCounsellor({required int userId}) {
    return counsellors.firstWhere((c) => c.user.id == userId);
  }

  PeerCounsellorDto getperCounsellor({required int userId}) {
    return peerCounsellors.firstWhere((c) => c.user.id == userId);
  }

  Future<InfoMessage?> initCounsellors() async {
    final res = await CounselingService.fetchCounsellors();
    counsellorStatus = ServiceStatus.loading;
    notifyListeners();
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
    final res = await CounselingService.fetchPeerCounsellors();
    peerStatus = ServiceStatus.loading;
    notifyListeners();
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
