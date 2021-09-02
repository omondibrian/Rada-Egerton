import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rada_egerton/sizeConfig.dart';

import '../constants.dart';
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
            child: SvgPicture.asset('assets/curve_left.svg',
              width:SizeConfig.isTabletWidth ? 200 :  100,),
          ),
          Center(
            child: SvgPicture.asset(
              'assets/welcome.svg',
              width:SizeConfig.isTabletWidth ? 600 :  200,
            ),
          ),
          Center(
            heightFactor:SizeConfig.isTabletWidth ? 2:3,
            child: Text('Welcome to Egerton University \n rada Application',style: TextStyle(
              fontSize: SizeConfig.isTabletWidth ? 28:14,
            ),),
          ),
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
                  Navigator.of(context).pushNamed(AppRoutes.register);
                },
                title: 'Register',
                fill: false),
          ),
        ],
      ),
    );
  }
}