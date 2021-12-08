import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final String imgUrl;
  CustomAppBar({
    Key? key,
    required this.title,
    required this.imgUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _openBottomSheet() {
      showBottomSheet(
          context: context,
          builder: (context) {
            final theme = Theme.of(context);
            return Wrap(
              children: [
                ListTile(
                  title: Text('Title 1'),
                ),
                ListTile(
                  title: Text('Title 2'),
                ),
                ListTile(
                  title: Text('Title 3'),
                ),
                ListTile(
                  title: Text('Title 4'),
                ),
                ListTile(
                  title: Text('Title 5'),
                ),
              ],
            );
          });
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
                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
                      color: Theme.of(context).accentColor, fontSize: 14),
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
            PopupMenuItem(child: Text('Add Member'), onTap: _openBottomSheet),
            PopupMenuItem(
                child: Text(
                  'Leave Group',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                // onTap: _openBottomSheet
                ),

            // PopupMenuItem(
            //   child: Text('Profile'),
            //   value: Options.Profile,
            // ),
            // PopupMenuItem(
            //   child: Text('Contributors'),
            //   value: Options.Contributors,
            // ),
          ],
        )
      ],
    );
  }
}
