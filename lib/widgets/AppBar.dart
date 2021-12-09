import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/providers/ApplicationProvider.dart';
import 'package:rada_egerton/theme.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final String imgUrl;
  final String? groupId;
  CustomAppBar({
    Key? key,
    required this.title,
    required this.imgUrl,
    this.groupId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RadaApplicationProvider>(context);
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
            PopupMenuItem(
              child: Text('Add Member'),
              onTap: () {},
            ),
            PopupMenuItem(
              onTap: () {
                provider.leaveGroup(groupId!);
                Navigator.of(context).pop();
              },
              child: Text(
                'Leave Group',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              // onTap: _openBottomSheet
            ),
          ],
        )
      ],
    );
  }
}
