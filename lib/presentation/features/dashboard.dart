import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/data/providers/authentication_provider.dart';
import 'package:rada_egerton/data/providers/counseling_provider.dart';
import 'package:rada_egerton/resources/config.dart';

import 'package:rada_egerton/resources/constants.dart';
import 'package:rada_egerton/resources/size_config.dart';

// ignore: constant_identifier_names
enum FilterOptions { Profile, Contributors, LogOut, schedule }

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  Widget dashBoardBuilder(BuildContext ctx, int index) {
    final style = TextStyle(
      fontSize: SizeConfig.isTabletWidth ? 16 : 14,
    );

    return GestureDetector(
      onTap: () {
        ctx.pushNamed(dashboardItems[index]['routeName']);
      },
      child: Card(
        elevation: 5.0,
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          contentPadding: SizeConfig.isTabletWidth
              ? const EdgeInsets.all(20)
              : const EdgeInsets.only(
                  left: 10, top: 2.0, right: 2.0, bottom: 2.0),
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
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: () {
              ctx.pushNamed(dashboardItems[index]['routeName']);
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isCounsellor = context.watch<CounsellingProvider>().isCounsellor(
          userId: GlobalConfig.instance.user.id,
        );
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              if (selectedValue == FilterOptions.Profile) {
                context.pushNamed(AppRoutes.profile);
              } else if (selectedValue == FilterOptions.LogOut) {
                context.read<AuthenticationProvider>().logout();
              } else if (selectedValue == FilterOptions.schedule) {
                context.pushNamed(AppRoutes.schedule, params: {
                  "userId": GlobalConfig.instance.user.id.toString()
                });
              } else {
                context.pushNamed(AppRoutes.contributors);
              }
            },
            icon: const Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: FilterOptions.LogOut,
                onTap: () => context.read<AuthenticationProvider>().logout(),
                child: const Text('Logout'),
              ),
              const PopupMenuItem(
                value: FilterOptions.Profile,
                child: Text('Profile'),
              ),
              if (isCounsellor)
                const PopupMenuItem(
                  value: FilterOptions.schedule,
                  child: Text('Schedule'),
                ),
              const PopupMenuItem(
                value: FilterOptions.Contributors,
                child: Text('Contributors'),
              ),
            ],
          ),
        ],
        title: const Text('Rada DashBoard'),
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
