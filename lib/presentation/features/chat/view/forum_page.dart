import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/data/providers/counselling.provider.dart';
import 'package:rada_egerton/presentation/features/chat/bloc/bloc.dart';

import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/resources/constants.dart';
import 'package:rada_egerton/resources/sizeConfig.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rada_egerton/resources/utils/main.dart';

class ForumPage extends StatelessWidget {
  const ForumPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counseligProvider = Provider.of<CounsellorProvider>(context);
    var forums = [];

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
        context.pushNamed(
          AppRoutes.forumMessages,
          queryParams: {"id": forum.forum.id.toString()},
        
        );
        context.read<ChatBloc>().add(
              ChatRecepientChanged(
                Recepient(
                  imgUrl: forum.forum.image,
                  reciepient: forum.forum.id,
                  title: forum.forum.title,
                ),
                ChatModes.FORUM,
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
              imageUrl: imageUrl(forum.forum.image),
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
