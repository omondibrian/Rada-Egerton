import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/providers/ApplicationProvider.dart';
import 'package:rada_egerton/providers/chat.provider.dart';
import 'package:rada_egerton/providers/counselling.provider.dart';
import 'package:rada_egerton/resources/constants.dart';
import 'package:rada_egerton/resources/theme.dart';
import 'package:rada_egerton/screens/chat/bloc/bloc.dart';
import 'package:rada_egerton/screens/view_profile.dart';
import 'package:rada_egerton/sizeConfig.dart';

import 'package:rada_egerton/utils/main.dart';
import 'package:rada_egerton/widgets/rating_dialog.dart';

import 'AddMembers.dart';

class CustomAppBar extends StatelessWidget {
  CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RadaApplicationProvider>(context);
    final _chatProvider = Provider.of<ChatProvider>(context);
    final _counselingProvider = Provider.of<CounsellorProvider>(context);
    String recepientId = context.read<ChatBloc>().state.recepient.toString();
    void _leaveGroup() async {
      InfoMessage _info = await provider.leaveGroup(recepientId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _info.message,
            style: TextStyle(color: _info.messageTypeColor),
          ),
        ),
      );
      _chatProvider.getConversations();
      context.pop();
    }

    void _delete() async {
      InfoMessage _info =
          await _counselingProvider.deleteGroupOrForum(recepientId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _info.message,
            style: TextStyle(color: _info.messageTypeColor),
          ),
        ),
      );
      _chatProvider.getConversations();
      context.pop();
    }

    return BlocBuilder<ChatBloc, ChatState>(
      buildWhen: (previous, current) => previous.recepient != current.recepient,
      builder: (context, state) {
        return Row(
          children: [
            IconButton(
              onPressed: () {
                context.pop();
              },
              icon: Icon(Icons.arrow_back),
            ),
            CircleAvatar(
              child: ClipOval(
                child: CachedNetworkImage(
                  color: Colors.white,
                  imageUrl: "${state.recepient?.imgUrl}",
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
                  placeholder: (context, url) => Image.asset(
                    state.chatType == ChatModes.PRIVATE
                        ? "assets/user.png"
                        : "assets/users.png",
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Container(
                height: 50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("${state.recepient?.title}",
                        style: Theme.of(context).textTheme.headline3),
                    Text(
                      'say Something',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          ?.copyWith(color: Palette.accent, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            PopupMenuButton(
              icon: Icon(
                Icons.more_vert,
              ),
              itemBuilder: (_) => [
                if (provider.userRole.isCounsellor &&
                    state.chatType == ChatModes.GROUP)
                  PopupMenuItem(
                    child: Text('Add Member'),
                    onTap: () {
                      showBottomSheet(
                          context: context,
                          builder: (ctx) => AddMembers(
                                groupId: recepientId,
                              ),
                          constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.5,
                              maxWidth: MediaQuery.of(context).size.width));
                    },
                  ),
                if (provider.userRole.isCounsellor &&
                    state.chatType == ChatModes.PRIVATE)
                  PopupMenuItem(
                    onTap: () {
                      showBottomSheet(
                        context: context,
                        builder: (ctx) => ViewProfileScreen(recepientId),
                      );
                    },
                    child: Text(
                      'View Profile',
                    ),
                  ),
                if (provider.userRole.isStudent ||
                    provider.userRole.isCounsellor &&
                        state.chatType == ChatModes.PRIVATE)
                  PopupMenuItem(
                    onTap: () => showBottomSheet(
                      context: context,
                      builder: (context) => ratingDialog(recepientId),
                    ),
                    child: Text(
                      'Rate',
                    ),
                  ),
                if (state.chatType != ChatModes.PRIVATE)
                  provider.userRole.isCounsellor
                      ? PopupMenuItem(
                          onTap: _delete,
                          child: Text(
                            'Delete',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error),
                          ),
                          // onTap: _openBottomSheet
                        )
                      : PopupMenuItem(
                          onTap: _leaveGroup,
                          child: Text(
                            'Leave ',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error),
                          ),
                          // onTap: _openBottomSheet
                        ),
              ],
            )
          ],
        );
      },
    );
  }
}
