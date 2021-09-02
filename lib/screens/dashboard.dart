import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rada_egerton/constants.dart';

import '../sizeConfig.dart';

enum FilterOptions {
  Profile,
  Contributors,
}

class Dashboard extends StatelessWidget {
  Widget dashBoardBuilder(BuildContext ctx, int index) {
    final style = TextStyle(
      fontSize: SizeConfig.isTabletWidth ? 28 : 14,
    );
    return ListTile(
      contentPadding:
          SizeConfig.isTabletWidth ? EdgeInsets.all(20) : EdgeInsets.all(2.0),
      leading: SvgPicture.asset(
        dashboardItems[index]['leadingIcon'],
        width: SizeConfig.isTabletWidth ? 90 : 60,
        height: SizeConfig.isTabletWidth ? 60 : 40,
      ),
      title: Text(
        dashboardItems[index]['title'],
        style: style,
      ),
      subtitle: Text(
        dashboardItems[index]['subtitle'],
        style: style,
      ),
      trailing: IconButton(
        iconSize: SizeConfig.isTabletWidth ? 50 : 30,
        color: Theme.of(ctx).primaryColor,
        icon: Icon(Icons.arrow_forward_ios),
        onPressed: () =>
            Navigator.of(ctx).pushNamed(dashboardItems[index]['routeName']),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              if (selectedValue == FilterOptions.Profile) {
                Navigator.of(context).pushNamed(AppRoutes.profile);
              } else {
                Navigator.of(context).pushNamed(AppRoutes.contributors);
              }
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Profile'),
                value: FilterOptions.Profile,
              ),
              PopupMenuItem(
                child: Text('Contributors'),
                value: FilterOptions.Contributors,
              ),
            ],
          ),
        ],
        title: Text('Rada DashBoard'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemBuilder: dashBoardBuilder,
            itemCount: dashboardItems.length,
          ),
        ),
      ),
    );
  }
}

List dashboardItems = [
  {
    'title': 'Information',
    'subtitle': 'Mentorship Program',
    'leadingIcon': 'assets/information.svg',
    'routeName': AppRoutes.information
  },
  {
    'title': 'Students Counseling',
    'subtitle': 'Mentorship program',
    'leadingIcon': 'assets/counseling.svg',
    'routeName': AppRoutes.counseling
  },
  {
    'title': 'Student Forums',
    'subtitle': 'Mentorship program',
    'leadingIcon': 'assets/forum.svg',
    'routeName': AppRoutes.forum
  },
  {
    'title': 'Notification',
    'subtitle': 'Mentorship program',
    'leadingIcon': 'assets/bell.svg',
    'routeName': AppRoutes.notification
  },
  {
    'title': 'Help',
    'subtitle': 'Location and Contact',
    'leadingIcon': 'assets/help.svg',
    'routeName': AppRoutes.help
  },
  {
    'title': 'Mentorship',
    'subtitle': 'Mentorship Program',
    'leadingIcon': 'assets/mentor.svg',
    'routeName': AppRoutes.mentorship
  },
  {
    'title': 'Group Counseling',
    'subtitle': 'Mentorship program',
    'leadingIcon': 'assets/counseling.svg',
    'routeName': AppRoutes.counseling
  },
];
