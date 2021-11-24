import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rada_egerton/constants.dart';
import 'package:rada_egerton/services/auth/main.dart';
import 'package:rada_egerton/widgets/RadaButton.dart';
import 'package:rada_egerton/widgets/defaultInput.dart';

import '../sizeConfig.dart';

class Login extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final userController = TextEditingController();
  final passwordController = TextEditingController();

  final _authService = AuthServiceProvider();


  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This value is required';
    } else if (!RegExp(
            r'^.+@[a-zA-Z0-9]+\.{1}[a-zA-Z0-9]+(\.{0,1}[a-zA-Z0-9]+)+$')
        .hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }


  void _handleSubmit(BuildContext context) async {
    try {
      if (_formKey.currentState!.validate()) {
        print(userController.text);
        print(passwordController.text);
        //TODO Remove backward navigation and connect to backend
        await this
            ._authService
            .logInUser(userController.text, passwordController.text);
        Navigator.of(context).popAndPushNamed(AppRoutes.dashboard);
      }
    } catch (e) {
    

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This value is required';
    } else if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
      return 'Incorrect password';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                          validator: emailValidator,
                          icon: Icons.person,
                        ),
                      ),
                      SizedBox(
                        width: SizeConfig.isTabletWidth ? 600 : 290.0,
                        child: DefaultInput(
                          isPassword: true,
                          hintText: 'Password',
                          controller: passwordController,
                          validator: passwordValidator,
                          icon: Icons.lock,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      RadaButton(
                        title: 'Login',
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
                                'Forgot Password?',
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
