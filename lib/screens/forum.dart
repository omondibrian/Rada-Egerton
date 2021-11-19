import 'package:flutter/material.dart';
import 'package:rada_egerton/widgets/AppBar.dart';
import 'chat/chat.dart';

class Forum extends StatelessWidget {
  final List _forums = [
    {
      'title': 'Covid 19',
      'imageUrl':
          'http://147.182.196.55/rada/uploads/1628172016139mint%20choclate%20chip.jpg',
    },
    {
      'title': 'Hiv/Aids',
      'imageUrl':
          'http://147.182.196.55/rada/uploads/1628172016139mint%20choclate%20chip.jpg',
    },
    {
      'title': 'Covid 19',
      'imageUrl':
          'http://147.182.196.55/rada/uploads/1628172016139mint%20choclate%20chip.jpg',
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
          backgroundImage: NetworkImage(
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

  Future<void> _refreshChat() async {
    //TODO : function call to refresh chat data
    await Future.delayed(Duration(milliseconds: 1000));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forums'),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _refreshChat(),
          backgroundColor: Theme.of(context).primaryColor,
          color: Colors.white,
          displacement: 20.0,
          edgeOffset: 5.0,
          child: ListView.builder(
            itemBuilder: forumBuilder,
            itemCount: this._forums.length,
          ),
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
        child: SizedBox(
          child: SafeArea(
            child: CustomAppBar(title: this.title, imgUrl: this.imgUrl),
          ),
        ),
      ),
      body: Chat(
        currentUserName: 'jonathan',
      ),
    );
  }
}
