import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/entities/ChatDto.dart';
import 'package:rada_egerton/providers/counselors.provider.dart';
import 'package:rada_egerton/screens/chat/chat.model.dart' as ChatModel;
import 'package:rada_egerton/theme.dart';
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  buildInput(
                    widget.sendMessage,
                    widget.currentUserId,
                    widget.reciepient,
                    widget.groupId,
                    widget.reply,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  

  Widget buildInput(Function(ChatPayload chat, String userId) onSubmit,
      String userId, String reciepient, String? groupId, String? replyId) {
    final _chatController = TextEditingController();
    return ClipRRect(
      borderRadius: BorderRadius.circular(30.0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Button choose image
            Material(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 1.0),
                child: IconButton(
                  icon: Icon(Icons.image),
                  onPressed: () {},
                  // color: Colors.black,
                ),
              ),
              color: Colors.white,
            ),
            //Emoji button

            Flexible(
              child: Container(
                child: TextField(
                  controller: _chatController,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Type your message...',
                  ),
                ),
              ),
            ),

            // Button send message
            Material(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Palette.accent,
                ),
                margin: EdgeInsets.symmetric(horizontal: 3.0),
                child: IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    var chat = ChatPayload(
                      groupsId: groupId,
                      id: 0,
                      imageUrl: "",
                      message: _chatController.text,
                      senderId: userId,
                      reciepient: reciepient,
                      reply: replyId,
                      status: "0",
                    );

                    onSubmit(chat, userId);
                    _chatController.clear();
                  },
                ),
              ),
              color: Colors.white,
            ),
          ],
        ),
        width: double.infinity,
        height: 50.0,
        decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.black87, width: 0.5),
            ),
            color: Colors.white),
      ),
    );
  }
}
