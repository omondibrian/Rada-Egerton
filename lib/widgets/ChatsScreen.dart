import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:rada_egerton/entities/ChatDto.dart';
import 'package:rada_egerton/entities/UserDTO.dart';
import 'package:rada_egerton/services/auth/main.dart';
import 'package:rada_egerton/widgets/AppBar.dart';
import 'package:rada_egerton/screens/chat/chat.dart';
import 'package:rada_egerton/entities/UserChatsDTO.dart';

class ChatScreen<T> extends StatefulWidget {
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
  }) {
    print(this.msgs);
  }

  @override
  State<ChatScreen<T>> createState() => _ChatScreenState<T>();
}

class _ChatScreenState<T> extends State<ChatScreen<T>> {
  String? _userId;

  final service = AuthServiceProvider();

  Future<void> init() async {
    final result = await service.getProfile();
    result!.fold((user) {
      print(user);
      _userId = user.id;
      setState(() {});
    }, (error) {
      print(error);
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: SizedBox(
          child: SafeArea(
            child: CustomAppBar(
                title: this.widget.title, imgUrl: this.widget.imgUrl),
          ),
        ),
      ),
      body: _userId == null
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : Chat<PeerMsg>(
              //TODO : use actual user id from auth
              currentUserId: _userId!,
              chatList: this.widget.msgs as List<PeerMsg>,
              sendMessage: this.widget.sendMessage,
              reciepient: this.widget.reciepient,
              groupId: this.widget.groupId,
            ),
    );
  }
}
