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
    final allForumns = provider.allForumns;

    Future<void> _refresh() async {
      provider.initAllForumns();
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
              if (provider.allForumnsStatus == ServiceStatus.loading) {
                return Shimmer(
                  child: ListView(
                    children: List.generate(
                        4, (index) => placeHolderListTile(context)),
                  ),
                );
              }
              if (provider.allForumnsStatus == ServiceStatus.loadingFailure) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Text("An error occurred"),
                      TextButton(
                        onPressed: () => _refresh(),
                        child: const Text("Retry"),
                      )
                    ],
                  ),
                );
              }
              if (allForumns.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("No forumns available"),
                );
              }
              return ListView.builder(
                itemBuilder: (context, index) => _ForumnItem(
                  forumn: allForumns[index],
                  isSubscribed: provider.isSubscribedToForum(allForumns[index]),
                ),
                itemCount: allForumns.length,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ForumnItem extends StatelessWidget {
  final GroupDTO forumn;
  final bool isSubscribed;
  const _ForumnItem({
    required this.forumn,
    required this.isSubscribed,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    void _openForumn() {
      if (!isSubscribed) return;
      context.pushNamed(
        AppRoutes.forumChats,
        params: {
          "forumnId": forumn.id.toString(),
        },
      );
    }

    return GestureDetector(
      onTap: _openForumn,
      child: ListTile(
        minVerticalPadding: 0,
        isThreeLine: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        leading: CircleAvatar(
          child: CachedNetworkImage(
            color: Colors.white,
            imageUrl: imageUrl(forumn.image),
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
        title: Text(forumn.title, style: Theme.of(context).textTheme.subtitle1),
        subtitle: const Text(
          "say something...",
        ),
        trailing: !isSubscribed
            ? TextButton(
                child: const Text('Join'),
                onPressed: () {
                  context
                      .read<RadaApplicationProvider>()
                      .joinForum(forumn.id)
                      .then(
                        (info) => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
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
                onPressed: _openForumn,
                child: const Text('View'),
              ),
      ),
    );
  }
}
