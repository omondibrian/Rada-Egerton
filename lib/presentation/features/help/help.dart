import 'package:flutter/material.dart';
import 'package:rada_egerton/presentation/features/help/help_tabs/ContactTab.dart';
import 'package:rada_egerton/presentation/features/help/help_tabs/issues.dart';
import 'package:rada_egerton/presentation/features/help/help_tabs/locationTab.dart';
import 'package:rada_egerton/resources/sizeConfig.dart';


class Help extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: SizeConfig.isTabletWidth ? 16 : 14,
    );
    return Scaffold(
        body: DefaultTabController(
      length: 3,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext ctx, bool isScrolled) {
          return <Widget>[
            new SliverAppBar(
              title: Text('Location and Contact'),
              pinned: true,
              floating: true,
              bottom: TabBar(
                indicatorColor: Theme.of(context).primaryColor,
                tabs: [
                  Tab(child: Text('Location', style: style)),
                  Tab(child: Text('Contact', style: style)),
                  Tab(child: Text('Issues', style: style)),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          children: [
            LocationTab(),
            ContactTab(),
            Issues(),
          ],
        ),
      ),
    ));
  }
}
