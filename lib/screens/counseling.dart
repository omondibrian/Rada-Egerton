import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rada_egerton/providers/counselors.provider.dart';

import '../sizeConfig.dart';
import 'CounselingTabs/ConversationsTab.dart';
import 'CounselingTabs/CounselorsTab.dart';
import 'CounselingTabs/PeerCounselorsTab.dart';

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
        length: 3,
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
                      Tab(child: Text('Conversations', style: style)),
                      Tab(child: Text('Counselors', style: style)),
                      Tab(child: Text('Peer Counselors', style: style)),
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
        ),
      )),
    );
  }
}
//TODO : Modify SmartRefresher and use Refresh Indicator instead
