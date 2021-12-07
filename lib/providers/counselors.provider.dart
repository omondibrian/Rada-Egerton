import 'package:flutter/material.dart';
import 'package:rada_egerton/entities/ChatDto.dart';
import 'package:rada_egerton/entities/CounsellorsDTO.dart';
import 'package:rada_egerton/entities/GroupsDTO.dart';
import 'package:rada_egerton/entities/PeerCounsellorDTO.dart';
import 'package:rada_egerton/entities/UserChatsDTO.dart' as User;
import 'package:rada_egerton/services/counseling/main.dart';

class CounselorProvider with ChangeNotifier {
  List<CounsellorsDTO> _counselors = [];
  List<PeerCounsellorDto> _peerCounsellors = [];
  CounselingServiceProvider _service = CounselingServiceProvider();
  late GroupsDto _forums;

  bool counselorsLoading = true;
  bool peerCouselorsLoading = true;

  CounselorProvider() {
    getCounsellors();
    getPeerCounsellors();
    getForums();
    getConversations();
  }

  User.UserChatDto _conversations = User.UserChatDto(
    data: User.Data(
      msg: '',
      payload: User.Payload(forumMsgs: [], peerMsgs: [], groupMsgs: []),
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
      if (this._counselors[i].id == id) {
        result = this._counselors[i];
      }
    }
    return result;
  }

  List<PeerCounsellorDto> get peerCounselors {
    return [...this._peerCounsellors];
  }

  User.UserChatDto get conversations {
    return this._conversations;
  }

  getConversations() async {
    var results = await _service.fetchUserMsgs();
    results!.fold(
      (userChats) {
        this._conversations = userChats;
      },
      (error) => print('Error from fetchChats() :${error.message}'),
    );
    notifyListeners();
  }

  getForums() async {
    var results = await _service.fetchStudentForums();
    results!.fold(
      (forums) => {this._forums = forums},
      (error) => print('Error from fetchForums() :${error.message}'),
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


  sendPeerCounselingMessage(ChatPayload chat, String userId) async {
    var service = CounselingServiceProvider();
    final result = await service.peerCounseling(chat, userId);
    result!.fold((chat) {
      this._conversations.data.payload.peerMsgs.add(User.PeerMsg(
          id: chat.data.payload.id,
          message: chat.data.payload.message,
          imageUrl: chat.data.payload.imageUrl,
          senderId: chat.data.payload.senderId,
          groupsId: chat.data.payload.groupsId??"",
          reply: chat.data.payload.reply??"",
          status: chat.data.payload.status,
          reciepient: chat.data.payload.reciepient));
    }, (r) => null);
    notifyListeners();
  }
}
