import 'package:flutter/material.dart';
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
    return MaterialApp(
        title: 'Rada',
        theme: ThemeData(
            // This is the theme of your application.
            //
            accentColor: Palette.accent,
            primaryColor: Palette.primary,
            cardColor: Palette.backgroundColor,
            shadowColor: Palette.shadowColor,
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
              bodyText1:
                  TextStyle(fontSize: 14.0, color: Palette.lightTextColor),
              bodyText2:
                  TextStyle(fontSize: 14.0, color: Palette.textMutedColor),
            ),
            appBarTheme: AppBarTheme(
                color: Palette.primary,
                iconTheme: IconThemeData(color: Colors.white))),
        onGenerateRoute: generateRoute,
        initialRoute: AppRoutes.welcome);
  }
}
