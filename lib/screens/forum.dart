import 'package:flutter/material.dart';

class Forum extends StatelessWidget {
  final List _forums = [
    {
      'title': 'Covid 19',
      'imageUrl':
          'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse2.mm.bing.net%2Fth%3Fid%3DOIP.hfxGfUIe6333mIDDyqqnOgHaFb%26pid%3DApi&f=1',
    }
  ];
  Widget forumBuilder(BuildContext context, int index) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape:BoxShape.circle ,
          borderRadius: BorderRadius.circular(5),
          image: DecorationImage(
            image: NetworkImage(
              this._forums[index]['imageUrl'],
            ),
          ),
        ),
      ),
      title: Text(this._forums[index]['title'],
          style: Theme.of(context).textTheme.headline6),
      subtitle: Text('hello there say something',
          style: Theme.of(context).textTheme.headline6),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: forumBuilder,
      itemCount: this._forums.length,
    );
  }
}
