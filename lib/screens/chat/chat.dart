import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/entities/ChatDto.dart';
import 'package:rada_egerton/providers/counselors.provider.dart';
import 'package:rada_egerton/screens/chat/chat.model.dart' as ChatModel;
import 'package:rada_egerton/widgets/buildInput.dart';
import '../../widgets/buildChatItem.dart';

class Chat<T> extends StatefulWidget {
  final String currentUserId;
  final List<T> chatList;
  final Function(ChatPayload chat, String userId) sendMessage;
  final String reciepient;
  final String? groupId;
  String reply = "";
  void initReply(String reply) {
    this.reply = reply;
  }

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
  @override
  Widget build(BuildContext context) {
    final counselorprovider = Provider.of<CounselorProvider>(context);
    var _ = counselorprovider.conversations;
    var _chats = widget.chatList
        .map(
          (chat) => ChatModel.Chat.fromJson(chat),
        )
        .toList();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/background_pattern.png'),
              repeat: ImageRepeat.repeat),
        ),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(top: 10.0),
              child: ListView.builder(
                itemCount: _chats.length,
                itemBuilder: (BuildContext ctx, index) => buildItem(
                    widget.currentUserId, _chats[index], widget.initReply),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: buildInput(
                widget.sendMessage,
                widget.currentUserId,
                widget.reciepient,
                widget.groupId,
                widget.reply,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
