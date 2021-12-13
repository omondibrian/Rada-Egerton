import 'package:rada_egerton/entities/CounsellorsDTO.dart';
import 'package:rada_egerton/entities/PeerCounsellorDTO.dart';
import 'package:rada_egerton/entities/StudentDTO.dart';

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
      var recipientId = conversations[index].recipient;

      late Recipient user;
      getUser(appProvider, counselorprovider, recipientId)
          .then((user_) => {user = user_});

      return GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              title: '${user.name}',
              imgUrl: "$BASE_URL/api/v1/uploads/${user.imgUrl}",
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
                imageUrl: "$BASE_URL/api/v1/uploads/${user.imgUrl}",
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
          title: Text('${user.name}', style: style),
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

  Future<Recipient> getUser(RadaApplicationProvider appProvider,
      CounselorProvider counselorprovider, String recipientId) async {
    Recipient user = Recipient(name: "", imgUrl: "");
    if (!appProvider.userRole.isStudent) {
      var infoConversations =
          counselorprovider.getReceipientBio(recipientId, true);
      infoConversations!.fold(
        (counsellorData) => user = Recipient(
            name: counsellorData!.name, imgUrl: counsellorData.imgUrl),
        (peer) => user = Recipient(name: peer.name, imgUrl: peer.profilePic),
      );
    } else {
      var std = await counselorprovider.getStudentBio(recipientId);
      std.fold(
          (user_) => {
                user = Recipient(
                    name: user_.user.name, imgUrl: user_.user.profilePic)
              },
          (r) => null);
    }
    return user;
  }
}

class Recipient {
  String name;
  String imgUrl;
  Recipient({required this.name, required this.imgUrl});
}
