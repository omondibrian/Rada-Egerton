import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rada_egerton/data/entities/group_dto.dart';
import 'package:rada_egerton/data/providers/application_provider.dart';
import 'package:rada_egerton/data/providers/authentication_provider.dart';
import 'package:rada_egerton/data/providers/counseling_provider.dart';
import 'package:rada_egerton/presentation/features/chat/group_chat/bloc/bloc.dart';
import 'package:rada_egerton/presentation/features/chat/group_chat/view/widgets/add_members.dart';
import 'package:rada_egerton/resources/config.dart';

class GroupAppBar extends StatelessWidget {
  const GroupAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String groupId = context.read<GroupBloc>().groupId;
    GroupDTO group = context.read<RadaApplicationProvider>().getGroup(groupId);
    bool isCounsellor = context.watch<CounsellingProvider>().isCounsellor(
          userId: AuthenticationProvider.instance.user.id,
        );

    return AppBar(
      title: Row(
        children: [
          CircleAvatar(
            child: ClipOval(
              child: CachedNetworkImage(
                color: Colors.white,
                imageUrl: group.image != null
                    ? imageUrl(group.image!)
                    : GlobalConfig.usersAvi,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                  width: 120,
                  height: 120,
                ),
                placeholder: (context, url) => Image.asset(
                  "assets/users.png",
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            children: [
              Text(group.title),
              const Text(
                "Say something..",
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
      actions: [
        PopupMenuButton(
          icon: const Icon(
            Icons.more_vert,
          ),
          itemBuilder: (_) => [
            if (isCounsellor) ...[
              PopupMenuItem(
                onTap: () => showBottomSheet(
                  context: context,
                  builder: (context) {
                    return AddMembers(
                      groupId: context.read<GroupBloc>().groupId,
                    );
                  },
                ),
                child: const Text(
                  'Add member ',
                ),
              ),
              //TODO: implement edit
              PopupMenuItem(
                onTap: () => context.read<GroupBloc>().add(
                      GroupUnsubscribe(),
                    ),
                child: Text(
                  'Leave ',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
              PopupMenuItem(
                onTap: () => context.read<GroupBloc>().add(
                      DeleteGroup(),
                    ),
                child: Text(
                  'Delete ',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            ],
            if (!isCounsellor)
              PopupMenuItem(
                onTap: () => context.read<GroupBloc>().add(
                      GroupUnsubscribe(),
                    ),
                child: Text(
                  'Leave ',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
          ],
        )
      ],
    );
  }
}
