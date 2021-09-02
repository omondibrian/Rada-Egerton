import 'package:flutter/material.dart';
import 'package:rada_egerton/screens/chat/chat.model.dart' as ChatModel;
import 'package:rada_egerton/widgets/buildInput.dart';
import '../../widgets/buildChatItem.dart';

class Chat extends StatefulWidget {
  final String title;
  final String imgUrl;
  final String currentUserName;
  @override
  _ChatState createState() => _ChatState();
  Chat(
      {required this.title,
      required this.imgUrl,
      required this.currentUserName});
}

class _ChatState extends State<Chat> {
  Widget customAppBar(BuildContext context) {
    return Row(
      children: [
        IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
        CircleAvatar(
          backgroundImage: NetworkImage(widget.imgUrl),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title, style: Theme.of(context).textTheme.headline1),
            Text('say Something',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    ?.copyWith(color: Theme.of(context).accentColor))
          ],
        )
      ],
    );
  }

  final List<ChatModel.Chat> _chats = getChats();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
              child: Stack(
        children: [
          customAppBar(context),
          Container(
            padding: EdgeInsets.only(top: 10.0),
            child: ListView.builder(
              itemCount: _chats.length,
              itemBuilder: (BuildContext ctx, index) =>
                  buildItem(widget.currentUserName, this._chats[index]),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: buildInput(),
          )
        ],
      ))),
    );
  }
}

List<ChatModel.Chat> getChats() {
  List<ChatModel.Chat> chatWidgets = [];
  for (int i = 0; i < chatContent.length; i++) {
    chatWidgets.add(
      ChatModel.Chat(
        authorName: chatContent[i]['authorName'],
        content: chatContent[i]['content'],
        media: chatContent[i]['media'],
      ),
    );
  }
  return chatWidgets;
}

List<Map<String, dynamic>> chatContent = [
  {
    'authorName': 'brian',
    'content': 'I\'m a recipient',
    'media':
        'http://147.182.196.55/rada/uploads/1628172016139mint%20choclate%20chip.jpg'
  },
  {'authorName': 'jonathan', 'content': 'I\'m a sender'},
  {
    'authorName': 'mozes',
    'content': 'I\'m a participant',
    'media':
        'http://147.182.196.55/rada/uploads/1628172016139mint%20choclate%20chip.jpg'
  },
  {'authorName': 'elvis', 'content': 'I like Rada at Egerton'},
];
