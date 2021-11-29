import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/providers/counselors.provider.dart';
import 'package:rada_egerton/services/constants.dart';
import 'package:rada_egerton/widgets/AppBar.dart';
import 'chat/chat.dart';

class Forum extends StatelessWidget {
  Future<void> _refreshChat() async {
    //TODO : function call to refresh chat data
    await Future.delayed(Duration(milliseconds: 1000));
  }

  @override
  Widget build(BuildContext context) {
    final counselorprovider = Provider.of<CounselorProvider>(context);
    var conversations = counselorprovider.conversations.data.payload.forumMsgs;
    counselorprovider.getConversations();
    Widget forumBuilder(BuildContext context, int index) {
      var forums = conversations[index].info;
      return GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              title: forums.title,
              imgUrl: "$BASE_URL/api/v1/uploads/${forums.image}",
            ),
          ),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
              "$BASE_URL/api/v1/uploads/${forums.image}",
            ),
          ),
          title:
              Text(forums.title, style: Theme.of(context).textTheme.headline1),
          subtitle: Text(conversations.last.messages.last.message,
              style: Theme.of(context).textTheme.bodyText1),
        ),
      );
    }

    return ChangeNotifierProvider(
      create: (_) => CounselorProvider(),
      child: Scaffold(
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
              itemCount: conversations.length,
            ),
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
