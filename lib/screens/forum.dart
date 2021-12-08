import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/constants.dart';
import 'package:rada_egerton/providers/counselors.provider.dart';
import 'package:rada_egerton/widgets/ChatsScreen.dart';
import 'package:rada_egerton/providers/chat.provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Forum extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final chatsprovider = Provider.of<ChatProvider>(context);
    final counseligProvider = Provider.of<CounselorProvider>(context);

    var forums = counseligProvider.forums?.data.payload ?? [];

    Future<void> _refreshChat() async {
      counseligProvider.getForums();
    }

    Widget forumBuilder(BuildContext context, int index) {
      var forum = forums[index];
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
            backgroundColor: Colors.white,
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
        child: counseligProvider.isForumLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              )
            : forums.isEmpty
                ? Center(child: Text("No forums"))
                : RefreshIndicator(
                    onRefresh: () => _refreshChat(),
                    backgroundColor: Theme.of(context).primaryColor,
                    color: Colors.white,
                    displacement: 20.0,
                    edgeOffset: 5.0,
                    child: ListView.builder(
                      itemBuilder: forumBuilder,
                      itemCount: forums.length,
                    ),
                  ),
      ),
    );
  }
}
