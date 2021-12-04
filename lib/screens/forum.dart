import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/entities/ChatDto.dart';
import 'package:rada_egerton/services/constants.dart';
import 'package:rada_egerton/widgets/ChatsScreen.dart';
import 'package:rada_egerton/entities/UserChatsDTO.dart';
import 'package:rada_egerton/services/counseling/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rada_egerton/providers/counselors.provider.dart';

class Forum extends StatelessWidget {
  Future<void> _refreshChat() async {
    //TODO : function call to refresh chat data
    await Future.delayed(Duration(milliseconds: 1000));
  }

  @override
  Widget build(BuildContext context) {
    final counselorprovider = Provider.of<CounselorProvider>(context);
    var forumsConversations =
        counselorprovider.conversations.data.payload.forumMsgs;
    Widget forumBuilder(BuildContext context, int index) {
      var forum = forumsConversations[index].info;
      var messages = forumsConversations[index].messages;
      print(messages);
      String imageUrl = "$BASE_URL/api/v1/uploads/${forum.image}";
      print(forum);
      sendMessage(ChatPayload chat, String userId) async {
        var service = CounselingServiceProvider();
        await service.groupCounseling(chat, userId);
      }

      return GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen<PeerMsg>(
              title: forum.title,
              imgUrl: imageUrl,
              msgs: messages,
              sendMessage: sendMessage,
              groupId: forum.id.toString(),
              reciepient: forum.id.toString(),
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
