import 'package:flutter/material.dart';

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
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext ctx, bool isScrolled) {
          return <Widget>[
            new SliverAppBar(
              title: Text('Rada Counseling'),
              pinned: true,
              floating: true,
              bottom: TabBar(
                indicatorColor: Theme.of(context).primaryColor,
                isScrollable: true,
                tabs: [
                  Tab(child: Text('Location', style: style)),
                  Tab(child: Text('Contact', style: style)),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(children: [
          LocationTab(),
          ContactTab(),
        ]),
      ),
    ));
  }
}
