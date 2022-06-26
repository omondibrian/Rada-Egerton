import 'package:flutter/material.dart';
import 'package:rada_egerton/presentation/features/help/help_tabs/contact_tab.dart';
import 'package:rada_egerton/presentation/features/help/help_tabs/issues.dart';
import 'package:rada_egerton/presentation/features/help/help_tabs/location_tab.dart';
import 'package:rada_egerton/resources/size_config.dart';


class Help extends StatelessWidget {
  const Help({Key? key}) : super(key: key);

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
            SliverAppBar(
              title: const Text('Location and Contact'),
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
        body: const TabBarView(
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
