import 'package:flutter/material.dart';
import 'package:rada_egerton/constants.dart';
import 'package:rada_egerton/utils/main.dart';
import 'package:rada_egerton/theme.dart';

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
      Navigator.of(context).pushReplacementNamed(AppRoutes.welcome);
    } else {
      Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
    }
  }
}
