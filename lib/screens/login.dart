import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rada_egerton/constants.dart';
import 'package:rada_egerton/theme.dart';
import 'package:rada_egerton/widgets/RadaButton.dart';
import 'package:rada_egerton/widgets/defaultInput.dart';

import '../sizeConfig.dart';

class Login extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This value is required';
    }
    return null;
  }

  void _handleSubmit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      print(userController.text);
      print(passwordController.text);
      //TODO Remove backward navigation and connect to backend
      Navigator.pushNamed(context, AppRoutes.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                'Login',
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
                          icon: Icons.person,
                        ),
                      ),
                      SizedBox(
                        width: SizeConfig.isTabletWidth ? 600 : 290.0,
                        child: DefaultInput(
                          isPassword: true,
                          hintText: 'Password',
                          controller: passwordController,
                          validator: validator,
                          icon: Icons.lock,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      RadaButton(
                        title: 'LogIn',
                        handleClick: () => _handleSubmit(context),
                        fill: true,
                      ),
                      SizedBox(
                        width: SizeConfig.isTabletWidth ? 600 : 290.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              child: Text(
                                'Forgot Password',
                                style: Theme.of(context).textTheme.bodyText1,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account? ',
                              style: Theme.of(context).textTheme.bodyText1,
                                textAlign: TextAlign.center,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, AppRoutes.register);
                              },
                              child: Text(
                                ' Register',
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
