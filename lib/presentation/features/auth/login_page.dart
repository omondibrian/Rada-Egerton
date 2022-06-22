import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/data/entities/UserDTO.dart';
import 'package:rada_egerton/data/providers/authentication_provider.dart';
import 'package:rada_egerton/presentation/widgets/RadaButton.dart';
import 'package:rada_egerton/presentation/widgets/defaultInput.dart';
import 'package:rada_egerton/presentation/widgets/password_field.dart';
import 'package:rada_egerton/resources/constants.dart';
import 'package:rada_egerton/data/services/auth/auth_service.dart';
import 'package:rada_egerton/resources/sizeConfig.dart';
import 'package:rada_egerton/resources/utils/validators.dart';

class Login extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final userController = TextEditingController();
  final passwordController = TextEditingController();

  void _handleSubmit(BuildContext context) async {
    try {
      if (_formKey.currentState!.validate()) {
        await AuthService.logInUser(
          userController.text,
          passwordController.text,
        );
        // context.read<AuthenticationProvider>().loginUser(
        //       user: User(
        //           profilePic: "",
        //           email: "test@gmail.com",
        //           id: 100,
        //           name: "test"),
        //       AuthToken: "iUUUS",
        //     );
        // context.go(AppRoutes.dashboard);
      }
    } catch (e) {
      print(e);
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
                        child: PasswordField(passwordController),
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
                                context.pushNamed(AppRoutes.register);
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
