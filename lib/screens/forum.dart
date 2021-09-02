import 'package:flutter/material.dart';
import 'package:rada_egerton/widgets/AppBar.dart';
import 'chat/chat.dart';

class Forum extends StatelessWidget {
  final List _forums = [
    {
      'title': 'Covid 19',
      'imageUrl': 'assets/background_pattern.png',
    },
    {
      'title': 'Hiv/Aids',
      'imageUrl': 'assets/background_pattern.png',
    },
    {
      'title': 'Covid 19',
      'imageUrl': 'assets/background_pattern.png',
    }
  ];
  Widget forumBuilder(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            title: this._forums[index]['title'],
            imgUrl: this._forums[index]['imageUrl'],
          ),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(
            this._forums[index]['imageUrl'],
          ),
        ),
        title: Text(this._forums[index]['title'],
            style: Theme.of(context).textTheme.headline1),
        subtitle: Text('hello there say something',
            style: Theme.of(context).textTheme.bodyText1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forums'),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemBuilder: forumBuilder,
          itemCount: this._forums.length,
        ),
      ),
    );
  }
}

class ChatScreen extends StatelessWidget {
  final String title;
  final String imgUrl;

  ChatScreen({
    Key? key,
    required this.title,
    required this.imgUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(title: this.title, imgUrl: this.imgUrl),
      ),
      body: Chat(
        currentUserName: 'jonathan',
      ),
    );
  }
}
