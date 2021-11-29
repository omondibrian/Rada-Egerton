import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/entities/UserChatsDTO.dart';
import 'package:rada_egerton/providers/counselors.provider.dart';
import 'package:rada_egerton/services/constants.dart';
import '../../sizeConfig.dart';

class ConversationsTab extends StatelessWidget {
  ConversationsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counselorprovider = Provider.of<CounselorProvider>(context);
    var conversations = counselorprovider.conversations.data.payload.groupMsgs;
    counselorprovider.getConversations();

    final style = TextStyle(
      fontSize: SizeConfig.isTabletWidth ? 16 : 14,
    );
    Future<void> _refreshChat() async {
      //TODO : function call to refresh chat data
      await Future.delayed(Duration(milliseconds: 1000));
    }

    
    Widget conversationBuilder(BuildContext ctx, int index) {
    Info infoConversations = conversations[index].info ;
      return ListTile(
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
        ),//TODO insert clickable functionality for chat
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
