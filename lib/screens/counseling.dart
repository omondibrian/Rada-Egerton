import '../sizeConfig.dart';
import 'package:flutter/material.dart';
import 'CounselingTabs/CounselorsTab.dart';
import 'CounselingTabs/PrivateSessions.dart';
import 'CounselingTabs/GroupSessionsTab.dart';
import 'CounselingTabs/PeerCounselorsTab.dart';

class Counseling extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: SizeConfig.isTabletWidth ? 16 : 14,
    );

    return Scaffold(
        body: DefaultTabController(
      length: 4,
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
                  Tab(child: Text('Counselors', style: style)),
                  Tab(child: Text('Peer Counselors', style: style)),
                  Tab(child: Text('private Sessions', style: style)),
                  Tab(child: Text('Group Sessions', style: style)),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          children: <Widget>[
            CounselorsTab(),
            PeerCounselorsTab(),
            PrivateSessionsTab(),
            GroupSessionsTab(),
          ],
        ),
      ),
    ));
  }
}
//TODO : Modify SmartRefresher and use Refresh Indicator instead
// https://w7.pngwing.com/pngs/402/235/png-transparent-businessperson-computer-icons-avatar-passport-miscellaneous-purple-heroes.png