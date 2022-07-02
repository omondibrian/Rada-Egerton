import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/data/entities/group_dto.dart';
import 'package:rada_egerton/data/providers/application_provider.dart';
import 'package:rada_egerton/data/status.dart';
import 'package:rada_egerton/presentation/features/counseling/counselling_tabs/peer_counselors_tab.dart';
import 'package:rada_egerton/presentation/loading_effect/shimmer.dart';

import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/resources/constants.dart';
import 'package:rada_egerton/resources/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rada_egerton/resources/utils/main.dart';

class ForumPage extends StatelessWidget {
  const ForumPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RadaApplicationProvider>(context);
    final allForums = provider.allForums;

    Future<void> _refresh() async {
      await provider.refreshForums();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forums'),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _refresh(),
          backgroundColor: Theme.of(context).primaryColor,
          color: Colors.white,
          displacement: 20.0,
          edgeOffset: 5.0,
          child: Builder(
            builder: (context) {
              if (provider.allForumsStatus == ServiceStatus.loading) {
                return Shimmer(
                  child: ListView(
                    children: List.generate(
                      4,
                      (index) => const TileLoader(),
                    ),
                  ),
                );
              }
              if (provider.allForumsStatus == ServiceStatus.loadingFailure) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Text("An error occurred"),
                      TextButton(
                        onPressed: () => _refresh(),
                        child: const Text("RETRY"),
                      )
                    ],
                  ),
                );
              }
              if (allForums.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("No forums available"),
                );
              }
              return ListView.builder(
                itemBuilder: (context, index) => _ForumItem(
                  forum: allForums[index],
                  isSubscribed: provider.isSubscribedToForum(allForums[index]),
                ),
                itemCount: allForums.length,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ForumItem extends StatelessWidget {
  final GroupDTO forum;
  final bool isSubscribed;
  const _ForumItem({
    required this.forum,
    required this.isSubscribed,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    void _openForum() {
      if (!isSubscribed) return;
      context.pushNamed(
        AppRoutes.goupChat,
        params: {
          "groupId": forum.id.toString(),
        },
      );
    }

    return GestureDetector(
      onTap: _openForum,
      child: ListTile(
        minVerticalPadding: 0,
        isThreeLine: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        leading: ClipOval(
          child: CircleAvatar(
            child: CachedNetworkImage(
              color: Colors.white,
              imageUrl: imageUrl(forum.image),
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
                width: SizeConfig.isTabletWidth ? 120 : 90,
                height: SizeConfig.isTabletWidth ? 120 : 90,
              ),
              placeholder: (context, url) => Image.asset("assets/users.png"),
            ),
          ),
        ),
        title: Text(forum.title, style: Theme.of(context).textTheme.subtitle1),
        subtitle: const Text(
          "say something...",
        ),
        trailing: !isSubscribed
            ? TextButton(
                child: const Text('Join'),
                onPressed: () {
                  context
                      .read<RadaApplicationProvider>()
                      .joinForum(forum.id)
                      .then(
                        (info) => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            content: Text(
                              info.message,
                              style: TextStyle(color: info.messageTypeColor),
                            ),
                          ),
                        ),
                      );
                },
              )
            : TextButton(
                onPressed: _openForum,
                child: const Text('View'),
              ),
      ),
    );
  }
}
