import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/data/entities/auth_dto.dart';
import 'package:rada_egerton/data/providers/application_provider.dart';
import 'package:rada_egerton/data/providers/authentication_provider.dart';
import 'package:rada_egerton/data/services/auth_service.dart';
import 'package:rada_egerton/resources/constants.dart';
import 'package:rada_egerton/resources/size_config.dart';
import 'package:rada_egerton/resources/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    //init size config class
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Palette.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const <Widget>[
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

  Future<void> initializeApp() async {
    LoginData? data = await AuthService.loadUserData();
    //inialize app data
    if (!mounted) {
      return;
    }
    if (data == null) {
      context.goNamed(AppRoutes.welcome);
    } else {
      context.read<AuthenticationProvider>().loginUser(
            user: data.user,
            authToken: data.authToken,
          );
      context.read<RadaApplicationProvider>().init();    
    }
  }
}
