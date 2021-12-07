import 'package:flutter/material.dart';
import 'package:rada_egerton/entities/ChatDto.dart';

class ChatInputBar extends StatelessWidget {
  final String userId;
  final String reciepient;
  final String? groupId;
  final String? replyId;
  final _chatController = TextEditingController();
  final Function(ChatPayload chat, String userId) onSubmit;

  ChatInputBar({
    required this.onSubmit,
    required this.groupId,
    required this.userId,
    required this.reciepient,
    required this.replyId,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: ChatInput(),
          ),
          SizedBox(
            width: 5.0,
          ),
          GestureDetector(
            onTap: () {
              var chat = ChatPayload(
                groupsId: this.groupId,
                id: 0,
                imageUrl: "",
                message: _chatController.text,
                senderId: this.userId,
                reciepient: this.reciepient,
                reply: this.replyId,
                status: "0",
              );

              this.onSubmit(chat, userId);
              _chatController.clear();
            },
            child: CircleAvatar(
              child: Icon(Icons.send),
            ),
          ),
        ],
      ),
    );
  }
}
class ChatInput extends StatelessWidget {
  const ChatInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            SizedBox(width: 8.0),
            Icon(Icons.insert_emoticon,
                size: 30.0, color: Theme.of(context).hintColor),
            SizedBox(width: 8.0),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Type a message',
                  border: InputBorder.none,
                ),
              ),
            ),
            Icon(Icons.attach_file,
                size: 30.0, color: Theme.of(context).hintColor),
            SizedBox(width: 8.0),
            Icon(Icons.camera_alt,
                size: 30.0, color: Theme.of(context).hintColor),
            SizedBox(width: 8.0),
          ],
        ),
      ),
    );
  }
}


