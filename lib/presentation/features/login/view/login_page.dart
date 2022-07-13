import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rada_egerton/data/providers/authentication_provider.dart';
import 'package:rada_egerton/data/status.dart';
import 'package:rada_egerton/presentation/features/help/help.dart';
import 'package:rada_egerton/presentation/features/login/bloc/bloc.dart';
import 'package:rada_egerton/presentation/widgets/button.dart';
import 'package:rada_egerton/presentation/widgets/input.dart';
import 'package:rada_egerton/presentation/widgets/password_field.dart';
import 'package:rada_egerton/resources/constants.dart';
import 'package:rada_egerton/resources/size_config.dart';
import 'package:rada_egerton/resources/utils/main.dart';
import 'package:rada_egerton/resources/utils/validators.dart';

class LoginPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BlocProvider(
          create: (_) => LoginCubit(
            _formKey,
            context.read<AuthenticationProvider>(),
          ),
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
              const SizedBox(
                height: 50,
              ),
              Text(
                'Login',
                style: Theme.of(context).textTheme.headline1,
                textAlign: TextAlign.center,
              ),
              _LoginForm(_formKey),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  const _LoginForm(this.formKey, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(
                state.message!.message,
                style: TextStyle(color: state.message!.messageTypeColor),
              ),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(
                width: SizeConfig.isTabletWidth ? 600 : 290.0,
                child: DefaultInput(
                  hintText: 'Username',
                  validator: emailValidator,
                  icon: Icons.person,
                  onChange: (value) =>
                      context.read<LoginCubit>().emailChanged(value),
                ),
              ),
              SizedBox(
                width: SizeConfig.isTabletWidth ? 600 : 290.0,
                child: PasswordField(
                  onChanged: (value) =>
                      context.read<LoginCubit>().passwordChanged(value),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const _SubmitButton(),
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
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          current.submissionStatus != previous.submissionStatus,
      builder: (context, state) {
        if (state.submissionStatus == ServiceStatus.submiting) {
          return const RadaButtonProgress(title: "Login");
        }
        return RadaButton(
          title: 'Login',
          handleClick: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => Help())),
          // context.read<LoginCubit>().submit(),
          fill: true,
        );
      },
    );
  }
}
