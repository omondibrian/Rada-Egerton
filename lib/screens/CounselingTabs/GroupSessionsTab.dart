import '../../sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/entities/ChatDto.dart';
import 'package:rada_egerton/services/constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rada_egerton/widgets/ChatsScreen.dart';
import 'package:rada_egerton/entities/UserChatsDTO.dart';
import 'package:rada_egerton/services/counseling/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rada_egerton/providers/counselors.provider.dart';

class GroupSessionsTab extends StatelessWidget {
  GroupSessionsTab({Key? key}) : super(key: key);

  sendMessage(ChatPayload chat, String userId) async {
    var service = CounselingServiceProvider();
    await service.groupCounseling(chat, userId);
  }

  @override
  Widget build(BuildContext context) {
    final counselorprovider = Provider.of<CounselorProvider>(context);
    var conversations = counselorprovider.conversations.data.payload.groupMsgs;
    counselorprovider.getConversations();

    final style = TextStyle(
      fontSize: SizeConfig.isTabletWidth ? 16 : 14,
    );
    Future<void> _refreshChat() async {
      await Future.delayed(Duration(milliseconds: 1000));
    }

    Widget conversationBuilder(BuildContext ctx, int index) {
      Info infoConversations = conversations[index].info;
      var msgs = conversations[index].messages;
      return GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen<PeerMsg>(
              title: infoConversations.title,
              imgUrl: "$BASE_URL/api/v1/uploads/${infoConversations.image}",
              msgs: msgs,
              sendMessage: sendMessage,
              groupId: infoConversations.id.toString(),
              reciepient: infoConversations.id.toString() ,
              
            ),
          ),
        ),
        child: ListTile(
          leading: CircleAvatar(
            radius: SizeConfig.isTabletWidth ? 98 : 20.0,
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: "$BASE_URL/api/v1/uploads/${infoConversations.image}",
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
          title: Text(infoConversations.title, style: style),
          subtitle: Text(
            conversations.last.messages.last.message,
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