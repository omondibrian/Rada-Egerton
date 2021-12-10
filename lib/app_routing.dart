import 'package:flutter/material.dart';
import 'package:rada_egerton/constants.dart';
import 'package:rada_egerton/screens/helpScreenTab/issues.dart';
import 'package:rada_egerton/screens/contributors.dart';
import 'package:rada_egerton/screens/counseling.dart';
import 'package:rada_egerton/screens/dashboard.dart';
import 'package:rada_egerton/screens/error_page.dart';
import 'package:rada_egerton/screens/forum.dart';
import 'package:rada_egerton/screens/help.dart';
import 'package:rada_egerton/screens/information/information_detail.dart';
import 'package:rada_egerton/screens/login.dart';
import 'package:rada_egerton/screens/mentorship.dart';
import 'package:rada_egerton/screens/notification.dart';
import 'package:rada_egerton/screens/profile.dart';
import 'package:rada_egerton/screens/register.dart';
import 'package:rada_egerton/screens/splash.dart';
import 'package:rada_egerton/screens/view_profile.dart';

import 'screens/information/information_list.dart';
import 'screens/welcome.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  /*
  This will be used to route different pages in the app

  example
  Navigator.of(context).pushNamed(AppRoutes.login)  - route to login page
   */
  switch (settings.name) {
    case AppRoutes.splash:
      return MaterialPageRoute(builder: (context) => SplashScreen());
    case AppRoutes.welcome:
      return MaterialPageRoute(builder: (context) => Welcome());
    case AppRoutes.login:
      return MaterialPageRoute(builder: (context) => Login());
    case AppRoutes.register:
      return MaterialPageRoute(builder: (context) => Register());
    case AppRoutes.counseling:
      return MaterialPageRoute(builder: (context) => Counseling());

    case AppRoutes.mentorship:
      return MaterialPageRoute(builder: (context) => Mentorship());
    case AppRoutes.help:
      return MaterialPageRoute(builder: (context) => Help());
    case AppRoutes.information:
      return MaterialPageRoute(builder: (context) => Information());
    case AppRoutes.informationDetails:
      return MaterialPageRoute(builder: (context) => InformationDetail());
    case AppRoutes.dashboard:
      return MaterialPageRoute(builder: (context) => Dashboard());
    case AppRoutes.forum:
      return MaterialPageRoute(builder: (context) => Forum());
    case AppRoutes.notification:
      return MaterialPageRoute(builder: (context) => UserNotification());
    case AppRoutes.profile:
      return MaterialPageRoute(builder: (context) => ProfileScreen());
    case AppRoutes.contributors:
      return MaterialPageRoute(builder: (context) => ContributorScreen());
    case AppRoutes.viewProfile:
      String userId = settings.arguments as String;
      return MaterialPageRoute(builder: (context) => ViewProfileScreen(userId));
    default:
      return MaterialPageRoute(builder: (context) => PageNotFound());
  }
}
