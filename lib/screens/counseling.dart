import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/providers/counselors.provider.dart';

import 'CounselingTabs/ConversationsTab.dart';
import 'CounselingTabs/CounselorsTab.dart';
import 'CounselingTabs/PeerCounselorsTab.dart';

class Counseling extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CounselorProvider(),
      child: Scaffold(
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
                  indicatorColor: Theme.of(context).primaryColor,
                  isScrollable: true,
                  tabs: [
                    Tab(child: Text('Conversations')),
                    Tab(child: Text('Counselors')),
                    Tab(child: Text('Peer Counselors')),
                  ],
                ),
              ),
            ];
                  },
                  body: TabBarView(
            children: <Widget>[
              ConversationsTab(),
              CounselorsTab(),
              PeerCounselorsTab()
            ],
                  ),
                ),
          )),
    );
  }
}






