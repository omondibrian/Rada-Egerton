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
import 'package:rada_egerton/resources/config.dart';
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
          path: AppRoutes.splash,
          name: AppRoutes.splash,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: AppRoutes.welcome,
          name: AppRoutes.welcome,
          builder: (context, state) => const Welcome(),
        ),
        GoRoute(
          path: AppRoutes.login,
          name: AppRoutes.login,
          builder: (context, state) => Login(),
        ),
        GoRoute(
          path: AppRoutes.register,
          name: AppRoutes.register,
          builder: (context, state) => Register(),
        ),
        //------------------------------------------------------------//
        // User must be authenticted to access this pages
        //------------------------------------------------------------//
        GoRoute(
          path: AppRoutes.dashboard,
          name: AppRoutes.dashboard,
          builder: (contex, state) => Dashboard(),
          routes: [
            GoRoute(
              path: AppRoutes.counseling,
              name: AppRoutes.counseling,
              builder: (context, state) => Counseling(),
            ),
            GoRoute(
              path: AppRoutes.mentorship,
              name: AppRoutes.mentorship,
              builder: (context, state) => const Mentorship(),
            ),
            GoRoute(
              path: AppRoutes.help,
              name: AppRoutes.help,
              builder: (context, state) => const Help(),
            ),
            GoRoute(
              path: AppRoutes.information,
              name: AppRoutes.information,
              builder: (context, state) => const Information(),
            ),
            GoRoute(
              path: AppRoutes.forum,
              name: AppRoutes.forum,
              builder: (context, _) => const ForumPage(),
            ),
            GoRoute(
              path: AppRoutes.forumMessages,
              name: AppRoutes.forumMessages,
              builder: (context, state) => ForumChats(
                forumnId: state.queryParams["id"]!,
              ),
            ),
            GoRoute(
              path: AppRoutes.peerChat,
              name: AppRoutes.peerChat,
              builder: (context, state) => PeerCounsellingChats(
                id: state.queryParams["id"]!,
              ),
            ),
            GoRoute(
              path: AppRoutes.privateChat,
              name: AppRoutes.privateChat,
              builder: (context, state) => PrivateChats(
                receipientId: state.queryParams["id"]!,
              ),
            ),
            GoRoute(
              path: AppRoutes.notification,
              name: AppRoutes.notification,
              builder: (context, state) => UserNotification(),
            ),
            GoRoute(
              path: AppRoutes.profile,
              name: AppRoutes.profile,
              builder: (context, state) => const ProfileScreen(),
            ),
            GoRoute(
              path: AppRoutes.contributors,
              name: AppRoutes.contributors,
              builder: (context, state) => const ContributorScreen(),
            ),
            GoRoute(
              path: AppRoutes.viewProfile,
              name: AppRoutes.viewProfile,
              builder: (context, state) => const ViewProfileScreen("1"),
            ),
          ],
        ),
        //-------------------------------------------------------//
        //-------------------------------------------------------//
      ],
    );
    context.read<AuthenticationProvider>().addListener(
      () {
        GlobalConfig.instance.inialize(
          authToken: context.read<AuthenticationProvider>().authToken,
          user: context.read<AuthenticationProvider>().user,
        );
        print(GlobalConfig.instance.user.toMap());
      },
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
        textTheme: const TextTheme(
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
        appBarTheme: const AppBarTheme(
          color: Palette.primary,
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
    );
  }
}
