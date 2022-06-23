import 'package:rada_egerton/data/entities/chat_dto.dart';
import 'package:rada_egerton/data/providers/application_provider.dart';
import 'package:rada_egerton/data/providers/chat.provider.dart';
import 'package:rada_egerton/presentation/widgets/NewGroupForm.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/resources/theme.dart';
import 'package:rada_egerton/resources/sizeConfig.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GroupSessionsTab extends StatelessWidget {
  const GroupSessionsTab({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final chatsprovider = Provider.of<ChatProvider>(context);

    var conversations = chatsprovider.groupMessages;
    final style = TextStyle(
      fontSize: SizeConfig.isTabletWidth ? 16 : 14,
    );
    Future<void> _refresh() async {}

    var radaApplicationProvider = Provider.of<RadaApplicationProvider>(context);

    Widget conversationBuilder(BuildContext ctx, int index) {
      ChatPayload Conversations = conversations[index];

      _openGroup() {}
      return GestureDetector(
        // onTap: () => context.go("${AppRoutes.counselingMessages}?id=${conversations[index].messages}")
        child: ListTile(
          leading: CircleAvatar(
            child: ClipOval(
              child: CachedNetworkImage(
                color: Colors.white,
                imageUrl: imageUrl("infoConversations.image"),
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => Image.asset("assets/user.png"),
              ),
            ),
          ),
          title: Text("infoConversations.title", style: style),
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
        backgroundColor: Palette.accent,
        onPressed: () {
          showBottomSheet(
            context: context,
            builder: (context) {
              return newGroupForm(context, radaApplicationProvider);
            },
          );
        },
        child: const Icon(
          Icons.group_add,
          color: Colors.white,
        ),
      ),
      body: conversations.isNotEmpty
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
              ),
            ),
    );
  }
}
