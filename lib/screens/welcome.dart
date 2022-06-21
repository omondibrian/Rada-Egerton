import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rada_egerton/resources/constants.dart';
import 'package:rada_egerton/sizeConfig.dart';

import '../widgets/RadaButton.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: SvgPicture.asset(
              'assets/curve_left.svg',
              width: 100,
            ),
          ),
          Center(
            child: Image.asset(
              'assets/welcome.png',
              width: 250,
              height: 250,
            ),
          ),
          Center(
            heightFactor: SizeConfig.isTabletWidth ? 2 : 3,
            child: Text('Welcome to Egerton University \n  rada Application',
                style: Theme.of(context).textTheme.subtitle1),
          ),
          Center(
            child: RadaButton(
                handleClick: () {
                  context.push(AppRoutes.login);
                },
                title: 'Login',
                fill: true),
          ),
          Center(
            child: RadaButton(
                handleClick: () {
                  context.push(AppRoutes.register);
                },
                title: 'Register',
                fill: false),
          ),
        ],
      ),
    );
  }
}
