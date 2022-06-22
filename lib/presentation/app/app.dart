import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/data/providers/authentication_provider.dart';
import 'package:rada_egerton/data/status.dart';
import 'package:rada_egerton/presentation/features/auth/login_page.dart';
import 'package:rada_egerton/presentation/features/auth/register_page.dart';
import 'package:rada_egerton/presentation/features/chat/view/forum_chats_page.dart';
import 'package:rada_egerton/presentation/features/chat/view/forum_page.dart';
import 'package:rada_egerton/presentation/features/chat/view/peer_counseling_chats.dart';
import 'package:rada_egerton/presentation/features/chat/view/private_chats.dart';
import 'package:rada_egerton/presentation/features/contributors.dart';
import 'package:rada_egerton/presentation/features/counseling/counseling.dart';
import 'package:rada_egerton/presentation/features/dashboard.dart';
import 'package:rada_egerton/presentation/features/help/help.dart';
import 'package:rada_egerton/presentation/features/information/information_list.dart';
import 'package:rada_egerton/presentation/features/information/notification.dart';
import 'package:rada_egerton/presentation/features/mentorship/mentorship.dart';
import 'package:rada_egerton/presentation/features/splash.dart';
import 'package:rada_egerton/presentation/features/user_account/profile.dart';
import 'package:rada_egerton/presentation/features/user_account/view_profile.dart';
import 'package:rada_egerton/presentation/features/welcome.dart';
import 'package:rada_egerton/resources/constants.dart';
import 'package:rada_egerton/resources/theme.dart';

class RadaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      debugLogDiagnostics: true,
      initialLocation: AppRoutes.splash,
      refreshListenable: context.read<AuthenticationProvider>(),
      redirect: (state) {
        String location = state.location;
        AuthenticationStatus status =
            context.read<AuthenticationProvider>().status;

        //Redirect authenticated trying to access the app to login
        if (location.startsWith("/app") &&
            status != AuthenticationStatus.authenticated) {
          return AppRoutes.login;
        }

        //Redirect authenticated users to main page
        if (status == AuthenticationStatus.authenticated &&
            !location.startsWith("/app")) {
          return AppRoutes.dashboard;
        }

        return null;
      },
      routes: [
        GoRoute(
          name: "splash",
          path: AppRoutes.splash,
          builder: (context, state) => SplashScreen(),
        ),
        GoRoute(
          name: "welcome",
          path: AppRoutes.welcome,
          builder: (context, state) => Welcome(),
        ),
        GoRoute(
          name: "login",
          path: AppRoutes.login,
          builder: (context, state) => Login(),
        ),
        GoRoute(
          name: "register",
          path: AppRoutes.register,
          builder: (context, state) => Register(),
        ),
        //------------------------------------------------------------//
        // User must be authenticted to access this pages
        //------------------------------------------------------------//
        GoRoute(
          name: "dashboard",
          path: AppRoutes.dashboard,
          builder: (contex, state) => Dashboard(),
          routes: [
            GoRoute(
              name: "counseling",
              path: AppRoutes.counseling,
              builder: (context, state) => Counseling(),
            ),
            GoRoute(
              name: "mentorship",
              path: AppRoutes.mentorship,
              builder: (context, state) => Mentorship(),
            ),
            GoRoute(
              name: "help",
              path: AppRoutes.help,
              builder: (context, state) => Help(),
            ),
            GoRoute(
              name: "information",
              path: AppRoutes.information,
              builder: (context, state) => Information(),
            ),
            GoRoute(
              name: "forumn",
              path: AppRoutes.forum,
              builder: (context, _) => ForumPage(),
            ),
            GoRoute(
              name: "forumnMessages",
              path: AppRoutes.forumMessages,
              builder: (context, state) => ForumChats(
                forumnId: state.queryParams["id"]!,
              ),
            ),
            GoRoute(
              name: "peerChat",
              path: AppRoutes.peerChat,
              builder: (context, state) => PeerCounsellingChats(
                id: state.queryParams["id"]!,
              ),
            ),
            GoRoute(
              name: "privateChat",
              path: AppRoutes.privateChat,
              builder: (context, state) => PrivateChats(
                receipientId: state.queryParams["id"]!,
              ),
            ),
            GoRoute(
              name: "notification",
              path: AppRoutes.notification,
              builder: (context, state) => UserNotification(),
            ),
            GoRoute(
              name: "profile",
              path: AppRoutes.profile,
              builder: (context, state) => ProfileScreen(),
            ),
            GoRoute(
              name: "contributors",
              path: AppRoutes.contributors,
              builder: (context, state) => ContributorScreen(),
            ),
            GoRoute(
              name: "viewProfile",
              path: AppRoutes.viewProfile,
              builder: (context, state) => ViewProfileScreen("1"),
            ),
          ],
        ),
        //-------------------------------------------------------//
        //-------------------------------------------------------//
      ],
    );
    return MaterialApp.router(
      routeInformationProvider: router.routeInformationProvider,
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      title: 'Rada',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColorLight: Palette.accent,
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
    );
  }
}
