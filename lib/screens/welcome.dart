import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants.dart';
import '../widgets/RadaButton.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: SvgPicture.asset('assets/curve_left.svg'),
          ),
          Center(
              child: SvgPicture.asset(
            'assets/help.svg',
            width: 200,
          )),
          Center(
              child: Text('Welcome to Egerton University \n rada Application')),
          Center(
            child: RadaButton(
                handleClick: () {
                  Navigator.of(context).pushNamed(AppRoutes.login);
                },
                title: 'LogIn',
                fill: true),
          ),
          Center(
            child: RadaButton(
                handleClick: () {
                  Navigator.of(context).pushNamed(AppRoutes.dashboard);
                },
                title: 'Register',
                fill: false),
          ),
        ],
      ),
    );
  }
}
