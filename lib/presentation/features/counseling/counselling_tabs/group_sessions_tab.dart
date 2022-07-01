import 'package:go_router/go_router.dart';
import 'package:rada_egerton/data/entities/group_dto.dart';
import 'package:rada_egerton/data/providers/application_provider.dart';
import 'package:rada_egerton/data/status.dart';
import 'package:rada_egerton/presentation/features/counseling/counselling_tabs/new_group_create.dart';
import 'package:rada_egerton/presentation/features/counseling/counselling_tabs/peer_counselors_tab.dart';
import 'package:rada_egerton/presentation/loading_effect/shimmer.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/resources/constants.dart';
import 'package:rada_egerton/resources/theme.dart';
import 'package:rada_egerton/resources/size_config.dart';

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
    Future<void> _refresh() async {
      await appProvider.refreshGroups();
    }

    Widget conversationBuilder(BuildContext ctx, int index) {
      GroupDTO group = groups[index];
      return GestureDetector(
        onTap: () => {
          context.pushNamed(
            AppRoutes.goupChat,
            params: {"groupId": group.id},
          )
        },
        child: ListTile(
          leading: CircleAvatar(
            child: ClipOval(
              child: CachedNetworkImage(
                color: Colors.white,
                imageUrl: imageUrl(group.image),
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => Image.asset("assets/users.png"),
              ),
            ),
          ),
          title: Text(group.title, style: style),
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
              return const NewGroupForm();
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
              return Shimmer(
                child: ListView(
                  children: List.generate(
                    4,
                    (index) => const TileLoader(),
                  ),
                ),
              );
            }
            if (appProvider.groupStatus == ServiceStatus.loadingFailure) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    const Text("Ann error occured"),
                    TextButton(
                      onPressed: () => _refresh(),
                      child: const Text("RETRY"),
                    )
                  ],
                ),
              );
            }
            if (groups.isEmpty) {
              return Center(
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
