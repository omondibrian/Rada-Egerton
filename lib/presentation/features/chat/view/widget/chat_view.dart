import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rada_egerton/data/entities/ChatDto.dart';
import 'package:rada_egerton/presentation/features/chat/bloc/bloc.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/resources/theme.dart';

import 'buildChatItem.dart';

class ChatView extends StatelessWidget {
  final List<ChatPayload> chats;
  ChatView(this.chats);

  @override
  Widget build(BuildContext context) {
    // List userChats =
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
                itemCount: chats.length,
                itemBuilder: (BuildContext ctx, index) => BuildChatItem(
                  chat: chats[index],
                  replyTo: chats.firstWhere(
                    (c) => chats[index].reply == c.id,
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _ChatInput(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectedChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state.selectedChat != null)
          Container(
            margin: EdgeInsets.only(left: 3),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(width: 5.0, color: Palette.accent),
              ),
              color: Colors.white,
            ),
            // margin: EdgeInsets.only(bottom: 2),
            child: Row(
              children: [
                Icon(
                  Icons.reply,
                ),
                Expanded(child: Text(state.selectedChat!.message)),
                IconButton(
                  onPressed: () => context.read<ChatBloc>().add(
                        ChatUnselected(),
                      ),
                  icon: Icon(Icons.close),
                )
              ],
            ),
          );
        return Container();
      },
    );
  }
}

class _ChatInput extends StatelessWidget {
  final FocusNode inputNode = FocusNode();
  final TextEditingController _chatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      buildWhen: (previous, current) =>
          previous.selectedChat != current.selectedChat,
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(left: 8, bottom: 3, right: 8, top: 2),
          child: Row(
            children: <Widget>[
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25.0),
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        _SelectedChat(),
                        Row(
                          children: <Widget>[
                            SizedBox(width: 8.0),
                            // Icon(Icons.insert_emoticon,
                            //     size: 30.0, color: Theme.of(context).hintColor),
                            // SizedBox(width: 8.0),
                            Expanded(
                              child: TextField(
                                maxLines: 10,
                                minLines: 1,
                                controller: this._chatController,
                                focusNode: this.inputNode,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  hintText: 'Type a message',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
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
                onTap: () => context.read<ChatBloc>().add(
                      ChatSend(
                          ChatPayload(
                            message: _chatController.text,
                            reciepient: state.recepient!.reciepient.toString(),
                            senderId: GlobalConfig.instance.user.id.toString(),
                          ),
                          state.chatType!),
                    ),
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
      },
    );
  }
}
