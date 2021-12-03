import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/providers/counselors.provider.dart';
import 'package:rada_egerton/theme.dart';

import 'app_routing.dart';
import 'constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CounselorProvider(),
      child: MaterialApp(
          title: 'Rada',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              // This is the theme of your application.
              //TODO: Is there a better way to migrate the code on line 22 t colorScheme.secondary
              // TODO and trace its visibility
              // ignore: deprecated_member_use
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
                bodyText1:
                    TextStyle(fontSize: 14.0, color: Palette.lightTextColor),
                bodyText2: TextStyle(fontSize: 14.0, color: Color(0xff9e9e9e)),
              ),
              appBarTheme: AppBarTheme(
                  color: Palette.primary,
                  iconTheme: IconThemeData(color: Colors.white))),
          onGenerateRoute: generateRoute,
          initialRoute: AppRoutes.splash),
    );
  }
}
