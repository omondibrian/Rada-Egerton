import 'package:flutter/material.dart';
import 'package:rada_egerton/entities/CounsellorsDTO.dart';
import 'package:rada_egerton/entities/PeerCounsellorDTO.dart';
import 'package:rada_egerton/entities/UserChatsDTO.dart';
import 'package:rada_egerton/services/counseling/main.dart';

class CounsellorsDataSource {
  List<CounsellorsDTO> _counsellors = [];
  List<PeerCounsellorDto>? _peerCounsellors;

  Future<CounsellorsDTO?> fetchCounsellor(String id) async {
    CounsellorsDTO? counsellor;
    CounselingServiceProvider counselingProvider = CounselingServiceProvider();
    var results = await counselingProvider.fetchCounsellor(id);
    results.fold(
      (counsellor) => counsellor = counsellor,
      (error) => print('Error from fetchCounsellor() :${error.message}'),
    );
    return counsellor;
  }

  Future<UserChatDto> fetchChats() async {
    var chats;
    CounselingServiceProvider counselingProvider = CounselingServiceProvider();
    var results = await counselingProvider.fetchUserMsgs();
    results!.fold(
      (userChats) => chats = userChats,
      (error) => print('Error from fetchChats() :${error.message}'),
    );
    return chats;
  }
}

class CounselorProvider with ChangeNotifier {
  var _dataSource = CounsellorsDataSource();
  List<CounsellorsDTO> _counselors = [];
  List<PeerCounsellorDto> _peerCounsellors = [];
  CounselingServiceProvider _service = CounselingServiceProvider();
  bool counselorsLoading = true;
  bool peerCouselorsLoading = true;

  CounselorProvider() {
    getCounsellors();
    getPeerCounsellors();
  }

  late UserChatDto _conversations = UserChatDto(
    data: Data(
      msg: '',
      payload: Payload(forumMsgs: [], peerMsgs: [], groupMsgs: []),
    ),
  );

  List<CounsellorsDTO> get counselors {
    // if (this._counselors.length != 0) {
    //   getCounsellors();
    // }

    return [...this._counselors];
  }

  CounsellorsDTO? counselorById(String id) {
    CounsellorsDTO? result;
    for (var i = 0; i < this._counselors.length; i++) {
      print(" cid = ${this._counselors[i]}");
      if (this._counselors[i].id == id) {
        result = this._counselors[i];
        print(" counsellor = ${this._counselors[i]}");
      }
    }
    return result;
  }

  List<PeerCounsellorDto> get peerCounselors {
    return [...this._peerCounsellors];
  }

  UserChatDto get conversations {
    return this._conversations;
  }

  getConversations() async {
    var results = await _service.fetchUserMsgs();
    results!.fold(
      (userChats) => {this._conversations = userChats},
      (error) => print('Error from fetchChats() :${error.message}'),
    );
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

  getCounselingChats() {
    return [];
  }
}
