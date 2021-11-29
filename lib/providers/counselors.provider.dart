import 'package:flutter/material.dart';
import 'package:rada_egerton/entities/CounsellorsDTO.dart';
import 'package:rada_egerton/entities/UserChatsDTO.dart';
import 'package:rada_egerton/services/counseling/main.dart';

class CounsellorsDataSource {
  List<CounsellorsDTO> _counsellors = [];

  Future<List<CounsellorsDTO>> fetchCounselors() async {
    //TODO:intergrate with api to retrive real data
    CounselingServiceProvider counselingProvider = CounselingServiceProvider();
    var results = await counselingProvider.fetchCounsellors();
    results.fold(
      (counsellors) => this._counsellors = counsellors,
      (error) => print('Error from fetchCounsellor() :${error.message}'),
    );
    return this._counsellors;
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
  late UserChatDto _conversations = UserChatDto(
    data: Data(
      msg: '',
      payload: Payload(forumMsgs: [], peerMsgs: [], groupMsgs: []),
    ),
  );

  List<CounsellorsDTO> get counselors {
    return [...this._counselors];
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

  getCounselingChats() {
    return [];
  }
}
