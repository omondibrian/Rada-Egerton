import 'package:rada_egerton/entities/ChatDto.dart';
import 'package:rada_egerton/entities/UserDTO.dart';
import 'package:rada_egerton/loading_effect/shimmer.dart';
import 'package:rada_egerton/screens/CounselingTabs/PeerCounselorsTab.dart';

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
    final counsellorprovider = Provider.of<CounsellorProvider>(context);
    final chatsprovider = Provider.of<ChatProvider>(context);
    final appProvider = Provider.of<RadaApplicationProvider>(context);
    List<Message> _conversations = [];
    String userId = "";
    if (appProvider.user != null) {
      userId = appProvider.user!.id.toString();
    }
    if (chatsprovider.privateMessages != null) {
      _conversations = ServiceUtility.combinePeerMsgs(
        chatsprovider.privateMessages!,
        userId,
      );
    }

    final style = TextStyle(
      fontSize: SizeConfig.isTabletWidth ? 16 : 14,
    );

    Future<void> _refresh() async {
      chatsprovider.getConversations();
    }

    Widget conversationBuilder(BuildContext ctx, int index) {
      var recipientId = _conversations[index].recipient;
      User? user = counsellorprovider.getUser(_conversations[index].userType,
          int.parse(recipientId), chatsprovider.students);

      return GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              title: '${user?.name}',
              imgUrl: "$BASE_URL/api/v1/uploads/${user!.profilePic}",
              sendMessage: chatsprovider.sendPrivateCounselingMessage,
              groupId: "",
              reciepient: recipientId,
              chatIndex: index,
              mode: ChatModes.PRIVATE,
            ),
          ),
        ),
        child: ListTile(
          leading: CircleAvatar(
            child: ClipOval(
              child: CachedNetworkImage(
                color: Colors.white, 
                imageUrl: "$BASE_URL/api/v1/uploads/${user?.profilePic}",
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
          title: Text('${user?.name}', style: style),
          subtitle: Text(
            "say something",
            style: TextStyle(
              color: Theme.of(ctx).primaryColor,
              fontSize: SizeConfig.isTabletWidth ? 16 : 14,
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _refresh(),
      backgroundColor: Theme.of(context).primaryColor,
      color: Colors.white,
      displacement: 20.0,
      edgeOffset: 5.0,
      child: chatsprovider.privateMessages == null
          //show skeleton if private messages have not been initialized
          ? Shimmer(
              child: ListView(
                children:
                    List.generate(4, (index) => placeHolderListTile(context)),
              ),
            )
          : _conversations.isNotEmpty
              ? ListView.builder(
                  itemBuilder: conversationBuilder,
                  itemCount: _conversations.length,
                )
              : Center(
                  child: Image.asset(
                    "assets/message.png",
                    width: 250,
                  ),
                ),
    );
  }
}
