import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/data/providers/application_provider.dart';
import 'package:rada_egerton/data/providers/chat.provider.dart';
import 'package:rada_egerton/data/providers/counselling.provider.dart';

import 'package:rada_egerton/resources/constants.dart';
import 'package:rada_egerton/resources/sizeConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum FilterOptions { Profile, Contributors, LogOut }

class Dashboard extends StatelessWidget {
  Widget dashBoardBuilder(BuildContext ctx, int index) {
    final style = TextStyle(
      fontSize: SizeConfig.isTabletWidth ? 16 : 14,
    );
    final chatProvider = Provider.of<ChatProvider>(ctx);
    // chatProvider.privateChannel();

    return GestureDetector(
      onTap: () {
        ctx.push(dashboardItems[index]['routeName']);
      },
      child: Card(
        elevation: 5.0,
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          contentPadding: SizeConfig.isTabletWidth
              ? EdgeInsets.all(20)
              : EdgeInsets.only(left: 10, top: 2.0, right: 2.0, bottom: 2.0),
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
              iconSize: 30,
              color: Theme.of(ctx).primaryColor,
              icon: Icon(Icons.arrow_forward_ios),
              onPressed: () {
                ctx.push(dashboardItems[index]['routeName']);
              }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var counsellorProvider = Provider.of<CounsellorProvider>(context);
    var appProvider = Provider.of<RadaApplicationProvider>(context);
    var chatsProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              if (selectedValue == FilterOptions.Profile) {
                context.push(AppRoutes.profile);
              } else if (selectedValue == FilterOptions.LogOut) {
                context.push(AppRoutes.welcome);
              } else {
                context.push(AppRoutes.contributors);
              }
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Logout'),
                value: FilterOptions.LogOut,
                onTap: () async {
                  SharedPreferences _prefs =
                      await SharedPreferences.getInstance();
                  _prefs.clear();
                  context.go(AppRoutes.splash);
                },
              ),
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
        automaticallyImplyLeading: false,
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
    'subtitle': 'Knowledge is power',
    'leadingIcon': 'assets/information.svg',
    'routeName': AppRoutes.information
  },
  {
    'title': 'Counseling',
    'subtitle': 'Free professional Counselling',
    'leadingIcon': 'assets/counseling.svg',
    'routeName': AppRoutes.counseling
  },
  {
    'title': 'Student Forums',
    'subtitle': 'Share with the group',
    'leadingIcon': 'assets/forum.svg',
    'routeName': AppRoutes.forum
  },
  {
    'title': 'Notification',
    'subtitle': 'Instant Notification',
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
];
