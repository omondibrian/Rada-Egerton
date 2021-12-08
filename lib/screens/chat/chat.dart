import 'package:flutter/material.dart';
import 'package:rada_egerton/entities/ChatDto.dart';
import 'package:rada_egerton/screens/chat/chat.model.dart' as ChatModel;
import 'package:rada_egerton/theme.dart';

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
  TextEditingController _chatController = TextEditingController();
  @override
  void dispose() {
    inputNode.dispose();
    super.dispose();
  }

  onTap() {
    var chat = ChatPayload(
      groupsId: widget.groupId,
      id: 0,
      imageUrl: "",
      message: _chatController.text,
      senderId: widget.currentUserId,
      reciepient: widget.reciepient,
      reply: reply?.id,
      status: "0",
      
    );

    widget.sendMessage(chat, widget.currentUserId);
    _chatController.clear();
    inputNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    var _chats = widget.chatList
        .map(
          (chat) => ChatModel.Chat.fromJson(chat),
        )
        .toList();

    void initReply(ChatModel.Chat reply) {
      this.reply = reply;
      inputNode.requestFocus();
      setState(() {});
    }

// to open keyboard call this function;
    ChatModel.Chat? _filterChat(String? id) {
      if (id == null) return null;
      for (int i = 0; i < _chats.length; ++i) {
        if (_chats[i].reply == id) return _chats[i];
      }
    }

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
                itemBuilder: (BuildContext ctx, index) => buildChatItem(
                    widget.currentUserId,
                    _chats[index],
                    initReply,
                    _filterChat(_chats[index].reply)),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                chatInput(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget replyToMessage(ChatModel.Chat chat) {
    return Container(
        margin: EdgeInsets.only(left: 3),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(width: 5.0, color: Palette.accent),
          ),
          color: Colors.white,
        ),
        // margin: EdgeInsets.only(bottom: 2),
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

  Widget chatInput(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8, bottom: 3, right: 8, top: 2),
      child: Row(
        children: <Widget>[
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    reply != null ? replyToMessage(reply!) : Container(),
                    Row(
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
