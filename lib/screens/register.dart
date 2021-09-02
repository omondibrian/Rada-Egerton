import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rada_egerton/widgets/defaultInput.dart';

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: SvgPicture.asset(
                'assets/curve_top.svg',
                width: MediaQuery.of(context).size.width,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              'Register',
              style: Theme.of(context).textTheme.headline1,
              textAlign: TextAlign.center,
            ),
            Form(child: Column(
              children: [
                // DefaultInput(hintText: 'Username', controller: userController, validator: validator, icon: icon)
              ],
            ))
          ],
        ),
      ),
    );
  }
}
