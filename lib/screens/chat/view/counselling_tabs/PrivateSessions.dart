import 'package:go_router/go_router.dart';
import 'package:rada_egerton/entities/ChatDto.dart';
import 'package:rada_egerton/entities/UserDTO.dart';
import 'package:rada_egerton/loading_effect/shimmer.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/resources/constants.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/screens/chat/bloc/bloc.dart';
import 'package:rada_egerton/screens/chat/view/counselling_tabs/PeerCounselorsTab.dart';
import 'package:rada_egerton/sizeConfig.dart';
import 'package:rada_egerton/utils/main.dart';
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
    List<ChatPayload> _conversations = [];

    final style = TextStyle(
      fontSize: SizeConfig.isTabletWidth ? 16 : 14,
    );

    Future<void> _refresh() async {}

    Widget conversationBuilder(BuildContext ctx, int index) {
      String recipientId = _conversations[index].reciepient.toString();
      User? user;

      void _openChat() {
        if (GlobalConfig.instance.user?.id == recipientId) return;
        context.push("${AppRoutes.peerChat}?id=${recipientId}");
        context.read<ChatBloc>().add(
              ChatRecepientChanged(
                Recepient(
                  imgUrl: user?.profilePic ?? "",
                  reciepient: int.parse(recipientId),
                  title: user?.name ?? "",
                ),
              ),
            );
      }

      return GestureDetector(
        onTap: _openChat,
        child: ListTile(
          leading: CircleAvatar(
            child: ClipOval(
              child: CachedNetworkImage(
                color: Colors.white,
                imageUrl: GlobalConfig.imageUrl("${user?.profilePic}"),
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
      child: chatsprovider == null
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
