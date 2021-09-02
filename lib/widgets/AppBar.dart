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
    return Row(
      children: [
        IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back)),
        CircleAvatar(
          backgroundImage: NetworkImage(this.imgUrl),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          height: 50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(this.title, style: Theme.of(context).textTheme.headline1),
              Text('say Something',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      ?.copyWith(color: Theme.of(context).accentColor))
            ],
          ),
        )
      ],
    );
  }
}
