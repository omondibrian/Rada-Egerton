import '../sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'CounselingTabs/CounselorsTab.dart';
import 'CounselingTabs/PrivateSessions.dart';
import 'CounselingTabs/GroupSessionsTab.dart';
import 'CounselingTabs/PeerCounselorsTab.dart';
import 'package:rada_egerton/providers/counselors.provider.dart';


class Counseling extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: SizeConfig.isTabletWidth ? 16 : 14,
    );

    Future<void> _refreshChat() async {
      //TODO : api call to refresh chat
      await Future.delayed(Duration(milliseconds: 1000));
    }

    return ChangeNotifierProvider(
      create: (_) => CounselorProvider(),
      child: Scaffold(
          body: DefaultTabController(
        length: 4,
        child: RefreshIndicator(
          onRefresh: () => _refreshChat(),
          backgroundColor: Theme.of(context).primaryColor,
          color: Colors.white,
          displacement: 20.0,
          edgeOffset: 5.0,
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
                      Tab(child: Text('private Sessions', style: style)),
                      Tab(child: Text('Group Sessions', style: style)),
                      Tab(child: Text('Counselors', style: style)),
                      Tab(child: Text('Peer Counselors', style: style)),
                    ],
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: <Widget>[
                PrivateSessionsTab(),
                GroupSessionsTab(),
                CounselorsTab(),
                PeerCounselorsTab()
              ],
            ),
          ),
        ),
      )),
    );
  }
}
//TODO : Modify SmartRefresher and use Refresh Indicator instead
// https://w7.pngwing.com/pngs/402/235/png-transparent-businessperson-computer-icons-avatar-passport-miscellaneous-purple-heroes.png