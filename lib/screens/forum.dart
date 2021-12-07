import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/constants.dart';
import 'package:rada_egerton/widgets/ChatsScreen.dart';
import 'package:rada_egerton/providers/chat.provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Forum extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final chatsprovider = Provider.of<ChatProvider>(context);
    var forumsConversations = chatsprovider.groupMessages;

    Future<void> _refreshChat() async {
      chatsprovider.getConversations();
    }

    Widget forumBuilder(BuildContext context, int index) {
      var forum = forumsConversations[index].info;
      String imageUrl = "$BASE_URL/api/v1/uploads/${forum.image}";


      return GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              title: forum.title,
              imgUrl: imageUrl,
              sendMessage: chatsprovider.sendGroupMessage,
              groupId: forum.id.toString(),
              reciepient: forum.id.toString(),
              chatIndex: index,
              mode: ChatModes.FORUM,
            ),
          ),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
              imageUrl,
            ),
          ),
          title:
              Text(forum.title, style: Theme.of(context).textTheme.headline1),
          subtitle: Text("say something...",
              style: Theme.of(context).textTheme.bodyText1),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Forums'),
      ),
      body: SafeArea(
        child: forumsConversations.isEmpty
            ? Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              )
            : RefreshIndicator(
                onRefresh: () => _refreshChat(),
                backgroundColor: Theme.of(context).primaryColor,
                color: Colors.white,
                displacement: 20.0,
                edgeOffset: 5.0,
                child: ListView.builder(
                  itemBuilder: forumBuilder,
                  itemCount: forumsConversations.length,
                ),
              ),
      ),
    );
  }
}
