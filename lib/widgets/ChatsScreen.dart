import 'package:flutter/material.dart';
import 'package:rada_egerton/entities/ChatDto.dart';
import 'package:rada_egerton/widgets/AppBar.dart';
import 'package:rada_egerton/screens/chat/chat.dart';
import 'package:rada_egerton/entities/UserChatsDTO.dart';

class ChatScreen<T> extends StatelessWidget {
  final String title;
  final String imgUrl;
  final List<T> msgs;
  final Function(ChatPayload chat, String userId) sendMessage;
  final String reciepient;
  final String? groupId;

  ChatScreen({
    Key? key,
    required this.title,
    required this.imgUrl,
    required this.msgs,
    required this.sendMessage,
    required this.reciepient,
    required this.groupId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: SizedBox(
          child: SafeArea(
            child: CustomAppBar(title: this.title, imgUrl: this.imgUrl),
          ),
        ),
      ),
      body: Chat<PeerMsg>(
        //TODO : use actual user id from auth
        currentUserId: '3',
        chatList: this.msgs as List<PeerMsg>,
        sendMessage: this.sendMessage,
        reciepient: this.reciepient,
        groupId: this.groupId,
 
      ),
    );
  }
}