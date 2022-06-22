import 'package:rada_egerton/presentation/features/counseling/counselling_tabs/counselors_tab.dart';
import 'package:rada_egerton/presentation/features/counseling/counselling_tabs/group_sessions_tab.dart';
import 'package:rada_egerton/presentation/features/counseling/counselling_tabs/peer_counselors_tab.dart';
import 'package:rada_egerton/presentation/features/counseling/counselling_tabs/private_sessions.dart';
import 'package:rada_egerton/resources/sizeConfig.dart';

import 'package:flutter/material.dart';

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
            SliverAppBar(
              title: const Text('Rada Counseling'),
              pinned: true,
              floating: true,
              bottom: TabBar(
                indicatorColor: Theme.of(context).primaryColor,
                isScrollable: true,
                tabs: [
                  Tab(child: Text('Counsellors', style: style)),
                  Tab(child: Text('Peer Counsellors', style: style)),
                  Tab(child: Text('Private Session', style: style)),
                  Tab(child: Text('Group Session', style: style)),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          children: <Widget>[
            const CounsellorsTab(),
            const PeerCounsellorsTab(),
            const PrivateSessionsTab(),
            GroupSessionsTab(),
          ],
        ),
      ),
    ));
  }
}
//TODO : Modify SmartRefresher and use Refresh Indicator instead
// https://w7.pngwing.com/pngs/402/235/png-transparent-businessperson-computer-icons-avatar-passport-miscellaneous-purple-heroes.png