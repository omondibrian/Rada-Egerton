import 'package:flutter/material.dart';
import 'package:rada_egerton/screens/chat/chat.dart';

import '../sizeConfig.dart';
import './helpScreenTab/ContactTab.dart';
import './helpScreenTab/locationTab.dart';

class Help extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: SizeConfig.isTabletWidth ? 24 : 14,
    );
    return Scaffold(
        body: DefaultTabController(
      length: 3,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext ctx, bool isScrolled) {
          return <Widget>[
            new SliverAppBar(
              title: Text('Rada Counseling'),
              pinned: true,
              floating: true,
              bottom: TabBar(
                labelPadding: EdgeInsets.symmetric(horizontal: 50.0),
                indicatorColor: Theme.of(context).primaryColor,
                isScrollable: true,
                tabs: [
                  Tab(child: Text('Location', style: style)),
                  Tab(child: Text('Contact', style: style)),
                  Tab(child: Text('Bot', style: style)),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(children: [
          LocationTab(),
          ContactTab(),
          Chat(
              title: 'moses',
              imgUrl:
                  'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse2.mm.bing.net%2Fth%3Fid%3DOIP.hfxGfUIe6333mIDDyqqnOgHaFb%26pid%3DApi&f=1',
              currentUserName: 'User')
        ]),
      ),
    ));
  }
}
