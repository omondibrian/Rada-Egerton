import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rada_egerton/data/status.dart';
import 'package:rada_egerton/presentation/features/register/bloc/bloc.dart';
import 'package:rada_egerton/presentation/widgets/RadaButton.dart';
import 'package:rada_egerton/presentation/widgets/defaultInput.dart';
import 'package:rada_egerton/resources/constants.dart';
import 'package:rada_egerton/resources/sizeConfig.dart';
import 'package:rada_egerton/resources/utils/main.dart';

class Register extends StatelessWidget {
  Register({Key? key}) : super(key: key);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BlocProvider(
          create: (context) => RegisterCubit(_formKey),
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
              const SizedBox(
                height: 50,
              ),
              Text(
                'Register',
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
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state.message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message!.message,
                style: TextStyle(color: state.message!.messageTypeColor),
              ),
            ),
          );
        }
        if (state.submissionStatus == ServiceStatus.success) {
          context.goNamed(AppRoutes.login);
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
                  validator: validator,
                  icon: Icons.person,
                  onChange: (value) =>
                      context.read<RegisterCubit>().usernameChanged(
                            value,
                          ),
                ),
              ),
              SizedBox(
                width: SizeConfig.isTabletWidth ? 600 : 290.0,
                child: DefaultInput(
                  hintText: 'Password',
                  isPassword: true,
                  validator: validator,
                  icon: Icons.lock,
                  onChange: (value) =>
                      context.read<RegisterCubit>().passwordChanged(
                            value,
                          ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const _SubmitButton(),
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
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) =>
          current.submissionStatus != previous.submissionStatus,
      builder: (context, state) {
        if (state.submissionStatus == ServiceStatus.submiting) {
          return const RadaButtonProgress(title: "Register");
        }
        return RadaButton(
          title: 'Register',
          handleClick: () => context.read<RegisterCubit>().submit(),
          fill: true,
        );
      },
    );
  }
}

String? validator(String? value) {
  if (value == null || value.isEmpty) {
    return 'This value is required';
  }
  return null;
}
