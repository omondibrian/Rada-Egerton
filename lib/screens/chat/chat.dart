import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/entities/ChatDto.dart';
import 'package:rada_egerton/providers/chat.provider.dart';
import 'package:rada_egerton/screens/chat/chat.model.dart' as ChatModel;
import 'package:rada_egerton/widgets/chatInput.dart';
import '../../widgets/buildChatItem.dart';

// ignore: must_be_immutable
class Chat<T> extends StatefulWidget {
  final String currentUserId;
  final List<T> chatList;
  final Function(ChatPayload chat, String userId) sendMessage;
  final String reciepient;
  final String? groupId;

  @override
  _ChatState createState() => _ChatState();
  Chat({
    required this.currentUserId,
    required this.chatList,
    required this.sendMessage,
    required this.reciepient,
    this.groupId,
  });
}

class _ChatState extends State<Chat> {
  ChatModel.Chat? reply;
  FocusNode inputNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    var _chats = widget.chatList
        .map(
          (chat) => ChatModel.Chat.fromJson(chat),
        )
        .toList();

    final chatProvider = Provider.of<ChatProvider>(context, listen: true);
    chatProvider.addListener(() => setState(() {}));
    void initReply(ChatModel.Chat reply) {
      this.reply = reply;
      inputNode.requestFocus();
      setState(() {});
    }

// to open keyboard call this function;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/background_pattern.png',
            ),
            repeat: ImageRepeat.repeat,
          ),
        ),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(top: 10.0, bottom: 50),
              child: ListView.builder(
                itemCount: _chats.length,
                itemBuilder: (BuildContext ctx, index) => buildItem(
                  widget.currentUserId,
                  _chats[index],
                  initReply,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                reply != null ? replyToMessage(reply!) : Container(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: chatInput(
                      widget.sendMessage,
                      widget.currentUserId,
                      widget.reciepient,
                      widget.groupId,
                      reply?.id.toString(),
                      inputNode),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget replyToMessage(ChatModel.Chat chat) {
    return Container(
        decoration: BoxDecoration(color: Colors.white),
        margin: EdgeInsets.only(bottom: 2),
        child: Row(children: [
          Icon(
            Icons.reply,
          ),
          Expanded(child: Text(chat.content)),
          IconButton(
              onPressed: () => setState(() {
                    reply = null;
                  }),
              icon: Icon(Icons.close))
        ]));
  }
}
