import 'dart:convert';

import 'package:rada_egerton/providers/ApplicationProvider.dart';
import 'package:rada_egerton/theme.dart';
import 'package:rada_egerton/widgets/NewGroupForm.dart';

import '../../sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rada_egerton/widgets/ChatsScreen.dart';
import 'package:rada_egerton/entities/UserChatsDTO.dart';
import 'package:rada_egerton/providers/chat.provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GroupSessionsTab extends StatelessWidget {
  GroupSessionsTab({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final chatsprovider = Provider.of<ChatProvider>(context);

    var conversations = chatsprovider.groupMessages;
    final style = TextStyle(
      fontSize: SizeConfig.isTabletWidth ? 16 : 14,
    );
    Future<void> _refreshChat() async {
      chatsprovider.getConversations();
    }

    var radaApplicationProvider = Provider.of<RadaApplicationProvider>(context);

    Widget conversationBuilder(BuildContext ctx, int index) {
      Info infoConversations = conversations[index].info;
      return GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              title: infoConversations.title,
              imgUrl: "$BASE_URL/api/v1/uploads/${infoConversations.image}",
              sendMessage: chatsprovider.sendGroupMessage,
              groupId: infoConversations.id.toString(),
              reciepient: infoConversations.id.toString(),
              chatIndex: index,
              mode: ChatModes.GROUP,
            ),
          ),
        ),
        child: ListTile(
          leading: CircleAvatar(
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
            "say something",
            style: TextStyle(
              color: Theme.of(ctx).primaryColor,
              fontSize: SizeConfig.isTabletWidth ? 16 : 14,
            ),
          ),
        ),
      );
    }

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.group_add,color: Colors.white,),
          backgroundColor: Palette.accent,
          onPressed: () {
            showBottomSheet(
                context: context,
                builder: (context) {
                  return newGroupForm(context, radaApplicationProvider);
                });
          },
        ),
        body: conversations.isNotEmpty
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
                  child: SpinKitSpinningLines(
                      color: Theme.of(context).primaryColor),
                ),
              ));
  }
}
