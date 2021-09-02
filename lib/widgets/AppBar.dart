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
        IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
        CircleAvatar(
          backgroundImage: NetworkImage(this.imgUrl),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(this.title, style: Theme.of(context).textTheme.headline1),
            Text('say Something',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    ?.copyWith(color: Theme.of(context).accentColor))
          ],
        )
      ],
    );
  }
}