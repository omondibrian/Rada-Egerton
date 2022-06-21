import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rada_egerton/resources/constants.dart';
import 'package:rada_egerton/resources/theme.dart';
import 'package:rada_egerton/utils/main.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "RADA",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 40),
            ),
            SizedBox(
              height: 20,
            ),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
            )
          ],
        ),
      ),
    );
  }

  Future initializeApp() async {
    String? _authToken = await ServiceUtility.getAuthToken();
    //inialize app data
    if (_authToken == null) {
      context.go(AppRoutes.welcome);
    } else {
      context.go(AppRoutes.dashboard);
    }
  }
}
