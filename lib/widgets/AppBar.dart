import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/constants.dart';
import 'package:rada_egerton/providers/ApplicationProvider.dart';
import 'package:rada_egerton/providers/chat.provider.dart';
import 'package:rada_egerton/providers/counselling.provider.dart';
import 'package:rada_egerton/screens/view_profile.dart';

import 'package:rada_egerton/theme.dart';
import 'package:rada_egerton/utils/main.dart';
import 'package:rada_egerton/widgets/rating_dialog.dart';

import 'AddMembers.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final String imgUrl;
  final String? groupId;
  final String? recepientId;
  final String conversationMode;
  CustomAppBar({
    Key? key,
    required this.title,
    required this.imgUrl,
    required this.conversationMode,
    this.groupId,
    this.recepientId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RadaApplicationProvider>(context);
    final _chatProvider = Provider.of<ChatProvider>(context);
    final _counselingProvider = Provider.of<CounsellorProvider>(context);
    void _leaveGroup() async {
      InfoMessage _info = await provider.leaveGroup(groupId!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _info.message,
            style: TextStyle(color: _info.messageTypeColor),
          ),
        ),
      );
      _chatProvider.getConversations();
      Navigator.of(context).pop();
    }

    void _delete() async {
      InfoMessage _info =
          await _counselingProvider.deleteGroupOrForum(groupId!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _info.message,
            style: TextStyle(color: _info.messageTypeColor),
          ),
        ),
      );
      _chatProvider.getConversations();
      Navigator.of(context).pop();
    }

    return Row(
      children: [
        IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back)),
        CircleAvatar(
          backgroundImage: NetworkImage(this.imgUrl),
          backgroundColor: Colors.white,
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
                Text(this.title, style: Theme.of(context).textTheme.headline3),
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
                conversationMode == ChatModes.GROUP)
              PopupMenuItem(
                child: Text('Add Member'),
                onTap: () {
                  showBottomSheet(
                      context: context,
                      builder: (ctx) => AddMembers(
                            groupId: this.groupId!,
                          ),
                      constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.5,
                          maxWidth: MediaQuery.of(context).size.width));
                },
              ),
            if (provider.userRole.isCounsellor &&
                conversationMode == ChatModes.PRIVATE)
              PopupMenuItem(
                onTap: () {
                  showBottomSheet(
                    context: context,
                    builder: (ctx) => ViewProfileScreen(this.recepientId!),
                  );
                },
                child: Text(
                  'View Profile',
                ),
              ),
            if (provider.userRole.isStudent ||
                provider.userRole.isCounsellor &&
                    conversationMode == ChatModes.PRIVATE)
              PopupMenuItem(
                onTap: () => showBottomSheet(
                  context: context,
                  builder: (context) => ratingDialog(recepientId!),
                ),
                child: Text(
                  'Rate',
                ),
              ),
            if (conversationMode != ChatModes.PRIVATE)
              provider.userRole.isCounsellor
                  ? PopupMenuItem(
                      onTap: _delete,
                      child: Text(
                        conversationMode == ChatModes.FORUM
                            ? "Delete Forum"
                            : 'Delete Group',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error),
                      ),
                      // onTap: _openBottomSheet
                    )
                  : PopupMenuItem(
                      onTap: _leaveGroup,
                      child: Text(
                        conversationMode == ChatModes.FORUM
                            ? "Leave Forum"
                            : 'Leave Group',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error),
                      ),
                      // onTap: _openBottomSheet
                    ),
          ],
        )
      ],
    );
  }
}
