import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/constants.dart';
import 'package:rada_egerton/providers/ApplicationProvider.dart';
import 'package:rada_egerton/providers/counselling.provider.dart';
import 'package:rada_egerton/sizeConfig.dart';
import 'package:rada_egerton/utils/main.dart';
import 'package:rada_egerton/widgets/ChatsScreen.dart';
import 'package:rada_egerton/providers/chat.provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Forum extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final chatsprovider = Provider.of<ChatProvider>(context);
    final counseligProvider = Provider.of<CounsellorProvider>(context);
    final radaAppProvider = Provider.of<RadaApplicationProvider>(context);
    var forums = ServiceUtility.parseForums(
        counseligProvider.forums, chatsprovider.forumMessages);

    Future<void> _refresh() async {
      counseligProvider.getForums();
    }

    Widget forumBuilder(BuildContext context, int index) {
      var forum = forums[index].forum;
      String imageUrl = "$BASE_URL/api/v1/uploads/${forum.image}";

      joinNewGroup() async {
        final _res = await radaAppProvider.joinGroup(
          forum.id.toString(),
        );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          _res.message,
          style: TextStyle(color: _res.messageTypeColor),
        )));
        chatsprovider.getConversations();
      }

      void _navigate() {
        if (!forums[index].isSubscribed) return;
        Navigator.push(
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
            ));
      }

      return GestureDetector(
        onTap: _navigate,
        child: ListTile(
          minVerticalPadding: 0,
          isThreeLine: true,
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          leading: CircleAvatar(
            child: CachedNetworkImage(
              color: Colors.white,
              imageUrl: imageUrl,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
                width: SizeConfig.isTabletWidth ? 120 : 90,
                height: SizeConfig.isTabletWidth ? 120 : 90,
              ),
              placeholder: (context, url) => Image.asset("assets/users.png"),
            ),
          ),

          title:
              Text(forum.title, style: Theme.of(context).textTheme.subtitle1),
          //TODO:add forum desciption here
          subtitle: Text(
            "say something...",
          ),
          trailing: !forums[index].isSubscribed
              ? TextButton(
                  child: Text('Join'),
                  onPressed: joinNewGroup,
                )
              : TextButton(
                  child: Text('View'),
                  onPressed: _navigate,
                ),
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
                    onRefresh: () => _refresh(),
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
