import '../../sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/constants.dart';
import 'package:rada_egerton/utils/main.dart';
import 'package:rada_egerton/entities/ChatDto.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rada_egerton/widgets/ChatsScreen.dart';
import 'package:rada_egerton/providers/UserProvider.dart';
import 'package:rada_egerton/providers/chat.provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rada_egerton/providers/counselors.provider.dart';

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

    Future<void> _refreshChat() async {
      chatsprovider.getConversations();
    }

    Widget conversationBuilder(BuildContext ctx, int index) {
      var counsellorId = conversations[index].recipient;
      var infoConversations = counselorprovider.counselorById(counsellorId);

      return GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen<ChatPayload>(
              title: '${infoConversations!.name}',
              imgUrl: "$BASE_URL/api/v1/uploads/${infoConversations.imgUrl}",
              msgs: conversations[index].msg,
              sendMessage:chatsprovider.sendPeerCounselingMessage,
              groupId: "",
              reciepient: counsellorId,
            ),
          ),
        ),
        child: ListTile(
          leading: CircleAvatar(
            radius: SizeConfig.isTabletWidth ? 98 : 20.0,
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl:
                    "$BASE_URL/api/v1/uploads/${infoConversations!.imgUrl}",
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
          title: Text('${infoConversations.name}', style: style),
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
            onRefresh: () => _refreshChat(),
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
            child: SizedBox(
              width: 80,
              height: 80,
              child:
                  SpinKitSpinningLines(color: Theme.of(context).primaryColor),
            ),
          );
  }
}
