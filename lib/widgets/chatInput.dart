import 'package:flutter/material.dart';
import 'package:rada_egerton/entities/ChatDto.dart';
import 'package:rada_egerton/theme.dart';

Widget chatInput(
    Function(ChatPayload chat, String userId) onSubmit,
    String userId,
    String reciepient,
    String? groupId,
    String? replyId,
    FocusNode focusNode) {
  final _chatController = TextEditingController();

  return Container(
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
            ),
          ),
          color: Colors.white,
        ),

        // Edit text
        Flexible(
          child: Container(
            child: TextField(
              controller: _chatController,
              style: TextStyle(color: Colors.black87, fontSize: 15.0),
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
              focusNode: focusNode,
              autofocus: true,
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
    decoration: BoxDecoration(color: Colors.white),
  );
}
