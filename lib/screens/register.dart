import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rada_egerton/services/auth/main.dart';
import 'package:rada_egerton/sizeConfig.dart';
import 'package:rada_egerton/widgets/RadaButton.dart';
import 'package:rada_egerton/widgets/defaultInput.dart';
import 'package:logger/logger.dart';

import '../constants.dart';

class Register extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  final _authService = AuthServiceProvider();
  String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This value is required';
      // } else if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
      //   return 'This value must contain only letters or numbers';
      // }
      // return null;
    }
  }

  var logger = Logger();
  void _handleRegister(BuildContext context) async {
    try {
      if (_formKey.currentState!.validate()) {
        //view registration details
        print(userController.text);
        print(passwordController.text);

        final AuthDTO user = AuthDTO(
          
            email: userController.text,
            password: passwordController.text,
            userName: userController.text,
            university: 'Egerton');

        await this._authService.registerNewUser(user);
       Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
      }
    } catch (e) {
      // print(e);
      this.logger.e(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: SvgPicture.asset(
                  'assets/curve_top.svg',
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fill,
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
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        width: SizeConfig.isTabletWidth ? 600 : 290.0,
                        child: DefaultInput(
                            hintText: 'Username',
                            controller: userController,
                            validator: validator,
                            icon: Icons.person),
                      ),
                      SizedBox(
                        width: SizeConfig.isTabletWidth ? 600 : 290.0,
                        child: DefaultInput(
                            hintText: 'Password',
                            isPassword: true,
                            controller: passwordController,
                            validator: validator,
                            icon: Icons.lock),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      RadaButton(
                          title: 'Register',
                          handleClick: () => _handleRegister(context),
                          fill: true),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account?',
                              style: Theme.of(context).textTheme.bodyText1,
                              textAlign: TextAlign.center,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, AppRoutes.login);
                              },
                              child: Text(
                                ' Login',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
