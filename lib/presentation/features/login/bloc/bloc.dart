import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rada_egerton/data/services/auth_service.dart';
import 'package:rada_egerton/data/status.dart';
import 'package:rada_egerton/resources/utils/main.dart';

part 'state.dart';

class LoginCubit extends Cubit<LoginState> {
  final GlobalKey<FormState> loginFormKey;
  LoginCubit(this.loginFormKey) : super(const LoginState());

  emailChanged(String value) {
    emit(
      state.copyWith(email: value),
    );
  }

  passwordChanged(String value) {
    emit(
      state.copyWith(password: value),
    );
  }

  submit() async {
    if (state.submissionStatus != ServiceStatus.submiting &&
        loginFormKey.currentState?.validate() == true) {
      emit(state.copyWith(
        status: ServiceStatus.submiting,
        message: InfoMessage(
          "Submiting please wait ...",
          MessageType.success,
        ),
      ));
      final res = await AuthService.logInUser(
        state.email,
        state.password,
      );
      res.fold(
        (l) {
          //TODO: set authentication state
          emit(
            state.copyWith(
              status: ServiceStatus.success,
              message: InfoMessage(
                "Login success",
                MessageType.success,
              ),
            ),
          );
        },
        (r) {
          emit(
            state.copyWith(
              status: ServiceStatus.failure,
              message: InfoMessage(r.message, MessageType.error),
            ),
          );
        },
      );
    }
  }
}
