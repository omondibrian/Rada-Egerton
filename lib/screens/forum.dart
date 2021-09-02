import 'package:flutter/material.dart';

class Forum extends StatelessWidget {
  final List _forums = [
    {
      'title': 'Covid 19',
      'imageUrl': 'assets/background_pattern.png',
    },
    {
      'title': 'Hiv/Aids',
      'imageUrl': 'assets/background_pattern.png',
    },
    {
      'title': 'Covid 19',
      'imageUrl': 'assets/background_pattern.png',
    }
  ];
  Widget forumBuilder(BuildContext context, int index) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(
          this._forums[index]['imageUrl'],
        ),
      ),
      title: Text(this._forums[index]['title'],
          style: Theme.of(context).textTheme.headline1),
      subtitle: Text('hello there say something',
          style: Theme.of(context).textTheme.bodyText1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forums'),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemBuilder: forumBuilder,
          itemCount: this._forums.length,
        ),
      ),
    );
  }
}
