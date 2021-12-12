import '../../sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/constants.dart';
import 'package:rada_egerton/utils/main.dart';
import 'package:rada_egerton/widgets/ChatsScreen.dart';
import 'package:rada_egerton/providers/ApplicationProvider.dart';
import 'package:rada_egerton/providers/chat.provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rada_egerton/providers/counselling.provider.dart';

class PrivateSessionsTab extends StatelessWidget {
  PrivateSessionsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counselorprovider = Provider.of<CounselorProvider>(context);
    final chatsprovider = Provider.of<ChatProvider>(context);
    final appProvider = Provider.of<RadaApplicationProvider>(context);
    String userId = "";
    if (appProvider.user != null) {
      userId = appProvider.user!.id;
    }

    var conversations = ServiceUtility.combinePeerMsgs(
      chatsprovider.privateMessages,
      userId,
    );

    final style = TextStyle(
      fontSize: SizeConfig.isTabletWidth ? 16 : 14,
    );

    Future<void> _refresh() async {
      chatsprovider.getConversations();
    }

    Widget conversationBuilder(BuildContext ctx, int index) {
      var counsellorId = conversations[index].recipient;
      var infoConversations = counselorprovider.counselorById(counsellorId);
      return GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              title: '${infoConversations?.name}',
              imgUrl: "$BASE_URL/api/v1/uploads/${infoConversations?.imgUrl}",
              sendMessage: chatsprovider.sendPrivateCounselingMessage,
              groupId: "",
              reciepient: counsellorId,
              chatIndex: index,
              mode: ChatModes.PRIVATE,
            ),
          ),
        ),
        child: ListTile(
          leading: CircleAvatar(
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl:
                    "$BASE_URL/api/v1/uploads/${infoConversations?.imgUrl}",
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          title: Text('${infoConversations?.name}', style: style),
          subtitle: Text(
            "say something",
            style: TextStyle(
              color: Theme.of(ctx).primaryColor,
              fontSize: SizeConfig.isTabletWidth ? 16 : 14,
            ),
          ), //TODO insert clickable functionality for chat
        ),
      );
    }

    return conversations.isNotEmpty
        ? RefreshIndicator(
            onRefresh: () => _refresh(),
            backgroundColor: Theme.of(context).primaryColor,
            color: Colors.white,
            displacement: 20.0,
            edgeOffset: 5.0,
            child: ListView.builder(
              itemBuilder: conversationBuilder,
              itemCount: conversations.length,
            ),
          )
        : Center(
            child: Image.asset(
            "assets/message.png",
            width: 250,
          ));
  }
}
