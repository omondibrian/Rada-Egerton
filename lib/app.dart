import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/providers/ApplicationProvider.dart';
import 'package:rada_egerton/providers/chat.provider.dart';
import 'package:rada_egerton/providers/counselling.provider.dart';
import 'package:rada_egerton/providers/information.content.dart';
import 'package:rada_egerton/resources/constants.dart';
import 'package:rada_egerton/resources/theme.dart';
import 'package:rada_egerton/screens/chat/view/counseling.dart';
import 'package:rada_egerton/screens/chat/view/forum_chats_page.dart';
import 'package:rada_egerton/screens/chat/view/forum_page.dart';
import 'package:rada_egerton/screens/chat/view/peer_counseling_chats.dart';
import 'package:rada_egerton/screens/chat/view/private_chats.dart';
import 'package:rada_egerton/screens/contributors.dart';
import 'package:rada_egerton/screens/dashboard.dart';
import 'package:rada_egerton/screens/help.dart';
import 'package:rada_egerton/screens/information/information_list.dart';
import 'package:rada_egerton/screens/login.dart';
import 'package:rada_egerton/screens/mentorship.dart';
import 'package:rada_egerton/screens/notification.dart';
import 'package:rada_egerton/screens/profile.dart';
import 'package:rada_egerton/screens/register.dart';
import 'package:rada_egerton/screens/splash.dart';
import 'package:rada_egerton/screens/view_profile.dart';
import 'package:rada_egerton/screens/welcome.dart';

class RadaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: AppRoutes.splash,
          builder: (context, state) => SplashScreen(),
        ),
        GoRoute(
          path: AppRoutes.welcome,
          builder: (context, state) => Welcome(),
        ),
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => Login(),
        ),
        GoRoute(
          path: AppRoutes.register,
          builder: (context, state) => Register(),
        ),
        GoRoute(
          path: AppRoutes.counseling,
          builder: (context, state) => Counseling(),
        ),
        GoRoute(
          path: AppRoutes.mentorship,
          builder: (context, state) => Mentorship(),
        ),
        GoRoute(
          path: AppRoutes.help,
          builder: (context, state) => Help(),
        ),
        GoRoute(
          path: AppRoutes.information,
          builder: (context, state) => Information(),
        ),
        GoRoute(
          path: AppRoutes.dashboard,
          builder: (contex, state) => Dashboard(),
        ),
        GoRoute(
          path: AppRoutes.forum,
          builder: (context, _) => ForumPage(),
        ),
        GoRoute(
          path: AppRoutes.forumMessages,
          builder: (context, state) => ForumChats(
            forumnId: state.queryParams["id"]!,
          ),
        ),
        GoRoute(
          path: AppRoutes.peerChat,
          builder: (context, state) => PeerCounsellingChats(
            id: state.queryParams["id"]!,
          ),
        ),
        GoRoute(
          path: AppRoutes.peerChat,
          builder: (context, state) => PrivateChats(
            receipientId: state.queryParams["id"]!,
          ),
        ),
        GoRoute(
          path: AppRoutes.notification,
          builder: (context, state) => UserNotification(),
        ),
        GoRoute(
          path: AppRoutes.profile,
          builder: (context, state) => ProfileScreen(),
        ),
        GoRoute(
          path: AppRoutes.contributors,
          builder: (context, state) => ContributorScreen(),
        ),
        GoRoute(
          path: AppRoutes.viewProfile,
          builder: (context, state) => ViewProfileScreen("1"),
        ),
      ],
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CounsellorProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => RadaApplicationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => InformationProvider(),
        )
      ],
      child: MaterialApp.router(
        routerDelegate: router.routerDelegate,
        routeInformationParser: router.routeInformationParser,
        title: 'Rada',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          accentColor: Palette.accent,
          primaryColor: Palette.primary,
          cardColor: Palette.backgroundColor,
          canvasColor: Colors.white,
          textTheme: TextTheme(
            headline1: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Palette.headerColor),
            headline2: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Palette.headerColor),
            headline3: TextStyle(
                fontSize: 16.0,
                color: Palette.headerColor,
                fontWeight: FontWeight.bold),
            subtitle1: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: Palette.lightTextColor),
            subtitle2: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: Color(0xff9e9e9e)),
            bodyText1: TextStyle(fontSize: 14.0, color: Palette.lightTextColor),
            bodyText2: TextStyle(fontSize: 14.0, color: Color(0xff9e9e9e)),
          ),
          appBarTheme: AppBarTheme(
            color: Palette.primary,
            iconTheme: IconThemeData(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
