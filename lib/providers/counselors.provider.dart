import 'package:flutter/material.dart';
import 'package:rada_egerton/entities/CounsellorsDTO.dart';
import 'package:rada_egerton/entities/PeerCounsellorDTO.dart';
import 'package:rada_egerton/entities/UserChatsDTO.dart';
import 'package:rada_egerton/services/counseling/main.dart';

class CounsellorsDataSource {
  List<CounsellorsDTO> _counsellors = [];
  List<PeerCounsellorDto> _peerCounsellors = [];

  Future<List<CounsellorsDTO>> fetchCounselors() async {
    CounselingServiceProvider counselingProvider = CounselingServiceProvider();
    var results = await counselingProvider.fetchCounsellors();
    results.fold(
      (counsellors) => this._counsellors = counsellors,
      (error) => print('Error from fetchCounsellors() :${error.message}'),
    );
    return this._counsellors;
  }

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

  Future<List<PeerCounsellorDto>> fetchPeerCounselors() async {
    CounselingServiceProvider counselingProvider = CounselingServiceProvider();
    var results = await counselingProvider.fetchPeerCounsellors();
    results.fold(
      (counsellors) => this._peerCounsellors = counsellors,
      (error) => print('Error from fetchPeerCounsellor() :${error.message}'),
    );
    return this._peerCounsellors;
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
   late  CounsellorsDTO _counsellor;
  late UserChatDto _conversations = UserChatDto(
    data: Data(
      msg: '',
      payload: Payload(forumMsgs: [], peerMsgs: [], groupMsgs: []),
    ),
  );

  List<CounsellorsDTO> get counselors {
    if (this._counselors.length != 0) {
      getCounsellors();
    }

    return [...this._counselors];
  }

  Future<CounsellorsDTO?> counselorById(String id) {
    return this._dataSource.fetchCounsellor(id).then((counsellor) {
      return counsellor;
    });
  }

  List<PeerCounsellorDto> get peerCounselors {
    if (this._peerCounsellors.length != 0) {
      getPeerCounsellors();
    }
    return [...this._peerCounsellors];
  }

  UserChatDto get conversations {
    return this._conversations;
  }

  getConversations() async {
    var result = await this._dataSource.fetchChats();
    this._conversations = result;
    notifyListeners();
  }

  getCounsellors() async {
    var result = await this._dataSource.fetchCounselors();
    this._counselors = result;
    notifyListeners();
  }

  getPeerCounsellors() async {
    var result = await this._dataSource.fetchPeerCounselors();
    this._peerCounsellors = result;
    notifyListeners();
  }

  getCounselingChats() {
    return [];
  }
}
