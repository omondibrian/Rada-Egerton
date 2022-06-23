import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rada_egerton/data/entities/auth_dto.dart';
import 'package:rada_egerton/presentation/widgets/RadaButton.dart';
import 'package:rada_egerton/presentation/widgets/defaultInput.dart';
import 'package:rada_egerton/resources/constants.dart';
import 'package:rada_egerton/data/services/auth_service.dart';
import 'package:rada_egerton/resources/sizeConfig.dart';

class Register extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This value is required';
      // } else if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
      //   return 'This value must contain only letters or numbers';
      // }
      // return null;
    }
    return null;
  }

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
        //TODO fix register
        await AuthService.registerNewUser(user);
        context.pushNamed(AppRoutes.login);
      }
    } catch (e) {
      // print(e);
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
                        fill: true,
                      ),
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
                              onTap: () => context.go(AppRoutes.login),
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
