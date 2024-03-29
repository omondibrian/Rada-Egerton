import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/data/providers/authentication_provider.dart';
import 'package:rada_egerton/data/status.dart';
import 'package:rada_egerton/main.dart';
import 'package:rada_egerton/presentation/features/chat/group_chat/view/group_chats_page.dart';
import 'package:rada_egerton/presentation/features/chat/private_chat/view/private_chats_page.dart';
import 'package:rada_egerton/presentation/features/contributors.dart';
import 'package:rada_egerton/presentation/features/counseling/counseling.dart';
import 'package:rada_egerton/presentation/features/counsellor_schedule/view/schedule_page.dart';
import 'package:rada_egerton/presentation/features/dashboard.dart';
import 'package:rada_egerton/presentation/features/forum_page.dart';
import 'package:rada_egerton/presentation/features/help/help.dart';
import 'package:rada_egerton/presentation/features/information/information_detail.dart';
import 'package:rada_egerton/presentation/features/information/information_list.dart';
import 'package:rada_egerton/presentation/features/information/notification.dart';
import 'package:rada_egerton/presentation/features/login/view/login_page.dart';
import 'package:rada_egerton/presentation/features/mentorship/mentorship.dart';
import 'package:rada_egerton/presentation/features/profile/view/profile_page.dart';
import 'package:rada_egerton/presentation/features/register/view/register_page.dart';
import 'package:rada_egerton/presentation/features/splash.dart';
import 'package:rada_egerton/presentation/features/welcome.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/resources/constants.dart';
import 'package:rada_egerton/resources/theme.dart';

class RadaApp extends StatefulWidget {
  const RadaApp({Key? key}) : super(key: key);

  @override
  State<RadaApp> createState() => _RadaAppState();
}

class _RadaAppState extends State<RadaApp> {
  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin.initialize(
        const InitializationSettings(
          android: AndroidInitializationSettings("launch_background"),
        ), onSelectNotification: (payload) {
      if (payload == null) return;
      try {
        Map data = jsonDecode(payload);
        if (data["Groups_id"] != null && data["Groups_id"] != "") {
          context.pushNamed(
            AppRoutes.goupChat,
            params: {
              "groupId": data["Groups_id"],
            },
          );
        } else if (data["sender_id"] != null && data["sender_id"] != "") {
         
          context.pushNamed(
            AppRoutes.privateChat,
            params: {
              "recepientId": data["sender_id"],
            },
          );
        } else {
          print("Not chat");
          // TODO: show notification
        }
      } catch (e) {}
    });
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        if (notification != null) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                androidChannel.id,
                androidChannel.name,
                channelDescription: androidChannel.description,
                color: Palette.primary,
                sound: androidChannel.sound,
                icon: "launch_background",
              ),
              // TODO: configure ios notification details
            ),
            payload: jsonEncode(message.data),
          );
        }
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        if (message.data["Groups_id"] != null &&
            message.data["Groups_id"] != "") {
          context.pushNamed(
            AppRoutes.goupChat,
            params: {
              "groupId": message.data["Groups_id"].toString(),
            },
          );
        } else if (message.data["recepient"] != null &&
            message.data["recepient"] != "") {
          context.pushNamed(
            AppRoutes.privateChat,
            params: {
              "recepientId": message.data["recepient"].toString(),
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      debugLogDiagnostics: true,
      initialLocation: "/",
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
          name: AppRoutes.splash,
          path: "/",
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
          builder: (context, state) => LoginPage(),
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
          builder: (contex, state) => const Dashboard(),
          routes: [
            GoRoute(
              path: AppRoutes.counseling,
              name: AppRoutes.counseling,
              builder: (context, state) => const Counseling(),
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
              routes: [
                GoRoute(
                  path: "information/:id",
                  name: AppRoutes.informationDetails,
                  builder: (context, state) => InformationDetailPage(
                    state.params["id"]!,
                  ),
                ),
              ],
            ),
            GoRoute(
              path: AppRoutes.forum,
              name: AppRoutes.forum,
              builder: (context, _) => const ForumPage(),
            ),
            GoRoute(
              path: "${AppRoutes.goupChat}/:groupId",
              name: AppRoutes.goupChat,
              builder: (context, state) => GroupChatPage(
                state.params["groupId"]!,
              ),
            ),
            GoRoute(
              path: "chat/:recepientId",
              name: AppRoutes.privateChat,
              builder: (context, state) => PrivateChatPage(
                state.params["recepientId"]!,
              ),
            ),
            GoRoute(
              path: AppRoutes.notification,
              name: AppRoutes.notification,
              builder: (context, state) => const UserNotification(),
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
              path: "profile/:userId",
              name: AppRoutes.viewProfile,
              builder: (context, state) => ProfileScreen(
                userId: int.parse(state.params["userId"]!),
              ),
            ),
            GoRoute(
              path: "schedule/:userId",
              name: AppRoutes.schedule,
              builder: (context, state) => CounsellorSchedulePage(
                userId: int.parse(state.params["userId"]!),
              ),
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
