import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/providers/ApplicationProvider.dart';
import 'package:rada_egerton/providers/counselling.provider.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/resources/constants.dart';
import 'package:rada_egerton/screens/chat/bloc/bloc.dart';
import 'package:rada_egerton/sizeConfig.dart';
import 'package:rada_egerton/utils/main.dart';
import 'package:rada_egerton/providers/chat.provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ForumPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<ChatBloc>().add(ChatModeChanged(ChatModes.FORUM));

    final chatsprovider = Provider.of<ChatProvider>(context);
    final counseligProvider = Provider.of<CounsellorProvider>(context);
    final radaAppProvider = Provider.of<RadaApplicationProvider>(context);
    var forums = ServiceUtility.parseForums(
        counseligProvider.forums, chatsprovider.forumMessages);

    Future<void> _refresh() async {
      counseligProvider.getForums();
    }

    Widget forumBuilder(BuildContext context, ForumPayload forum) {
      // var forum = forums[index].forum;
      // joinNewGroup() async {
      //   final _res = await radaAppProvider.joinGroup(
      //     forum.id.toString(),
      //   );
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //       content: Text(
      //     _res.message,
      //     style: TextStyle(color: _res.messageTypeColor),
      //   )));
      //   chatsprovider.getConversations();
      // }

      void _openForumn() {
        if (!forum.isSubscribed) return;
        context.push("${AppRoutes.forumMessages}?id=${forum.forum.id}");
        context.read<ChatBloc>().add(
              ChatRecepientChanged(
                Recepient(
                  imgUrl: forum.forum.image,
                  reciepient: forum.forum.id,
                  title: forum.forum.title,
                ),
              ),
            );
      }

      return GestureDetector(
        onTap: _openForumn,
        child: ListTile(
          minVerticalPadding: 0,
          isThreeLine: true,
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          leading: CircleAvatar(
            child: CachedNetworkImage(
              color: Colors.white,
              imageUrl: GlobalConfig.imageUrl(forum.forum.image),
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

          title: Text(forum.forum.title,
              style: Theme.of(context).textTheme.subtitle1),
          //TODO:add forum desciption here
          subtitle: Text(
            "say something...",
          ),
          trailing: !forum.isSubscribed
              ? TextButton(
                  child: Text('Join'),
                  onPressed: () => {
                    //TODO join forum
                  },
                )
              : TextButton(
                  child: Text('View'),
                  onPressed: _openForumn,
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
                      itemBuilder: (context, index) => forumBuilder(
                        context,
                        forums[index],
                      ),
                      itemCount: forums.length,
                    ),
                  ),
      ),
    );
  }
}
