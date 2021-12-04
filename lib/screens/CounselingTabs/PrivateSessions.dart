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

class PrivateSessionsTab extends StatelessWidget {
  PrivateSessionsTab({Key? key}) : super(key: key);
  final String userId = "3"; //to be changed later
  sendMessage(ChatPayload chat, String userId) async {
    var service = CounselingServiceProvider();
    await service.peerCounseling(chat, userId);
  }

  @override
  Widget build(BuildContext context) {
    final counselorprovider = Provider.of<CounselorProvider>(context);
    var conversations = counselorprovider.conversations.data.payload.peerMsgs;
    counselorprovider.getConversations();

    final style = TextStyle(
      fontSize: SizeConfig.isTabletWidth ? 16 : 14,
    );

    Future<void> _refreshChat() async {
      await Future.delayed(Duration(milliseconds: 1000));
    }

    Widget conversationBuilder(BuildContext ctx, int index) {
      var counsellorId = conversations[index].senderId == this.userId
          ? conversations[index].reciepient
          : conversations[index].senderId;

      var infoConversations = counselorprovider.counselorById(counsellorId);
    
      print(" info = $infoConversations");
      return GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen<PeerMsg>(
              title: '${infoConversations!.name}',
              imgUrl: "$BASE_URL/api/v1/uploads/${infoConversations.imgUrl}",
              msgs: conversations,
              sendMessage: sendMessage,
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
            conversations.last.message,
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