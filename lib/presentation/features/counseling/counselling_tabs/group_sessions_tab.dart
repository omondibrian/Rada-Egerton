import 'package:go_router/go_router.dart';
import 'package:rada_egerton/data/entities/chat_dto.dart';
import 'package:rada_egerton/data/entities/group_dto.dart';
import 'package:rada_egerton/data/providers/application_provider.dart';
import 'package:rada_egerton/data/providers/counseling_provider.dart';
import 'package:rada_egerton/data/status.dart';
import 'package:rada_egerton/presentation/widgets/NewGroupForm.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/resources/constants.dart';
import 'package:rada_egerton/resources/theme.dart';
import 'package:rada_egerton/resources/sizeConfig.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GroupSessionsTab extends StatelessWidget {
  const GroupSessionsTab({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<RadaApplicationProvider>(context);
    final groups = appProvider.groups;

    final style = TextStyle(
      fontSize: SizeConfig.isTabletWidth ? 16 : 14,
    );
    Future<void> _refresh() async {}

    Widget conversationBuilder(BuildContext ctx, int index) {
      GroupDTO group = groups[index];

      return GestureDetector(
        onTap: () => {
          context.goNamed(
            AppRoutes.goupChat,
            params: {"goupId": group.id},
          )
        },
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
              return newGroupForm(context, appProvider);
            },
          );
        },
        child: const Icon(
          Icons.group_add,
          color: Colors.white,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => _refresh(),
        backgroundColor: Theme.of(context).primaryColor,
        color: Colors.white,
        displacement: 20.0,
        edgeOffset: 5.0,
        child: Builder(
          builder: (context) {
            if (appProvider.groupStatus == ServiceStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (appProvider.groupStatus == ServiceStatus.loadingFailure) {
              return Center(
                child: Row(
                  children: [
                    const Text("Ann error occured"),
                    TextButton(
                      onPressed: () => _refresh(),
                      child: const Text("Retry"),
                    )
                  ],
                ),
              );
            }
            if (groups.isEmpty) {
              Center(
                child: Image.asset(
                  "assets/message.png",
                  width: 250,
                ),
              );
            }
            return ListView.builder(
              itemBuilder: conversationBuilder,
              itemCount: groups.length,
            );
          },
        ),
      ),
    );
  }
}
