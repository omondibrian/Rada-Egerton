import 'package:flutter/material.dart';
import 'package:rada_egerton/entities/ChatDto.dart';
import 'package:rada_egerton/theme.dart';

class ChatInputBar extends StatelessWidget {
  final String userId;
  final String reciepient;
  final String? groupId;
  final String? replyId;
  final FocusNode inputNode;
  final _chatController = TextEditingController();

  final Function(ChatPayload chat, String userId) onSubmit;

  ChatInputBar(
      {required this.onSubmit,
      required this.groupId,
      required this.userId,
      required this.reciepient,
      required this.replyId,
      required this.inputNode});

  onTap() {
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
    inputNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8, bottom: 3, right: 8, top: 2),
      child: Row(
        children: <Widget>[
          Expanded(
            child: ClipRRect(
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
                        maxLines: 10,
                        minLines: 1,
                        // expands: true,
                        controller: this._chatController,
                        focusNode: this.inputNode,
                        decoration: InputDecoration(
                          hintText: 'Type a message',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Icon(Icons.camera_alt,
                        size: 30.0, color: Theme.of(context).hintColor),
                    SizedBox(width: 8.0),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 5.0,
          ),
          GestureDetector(
            onTap: onTap,
            child: CircleAvatar(
              backgroundColor: Palette.accent,
              child: Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
