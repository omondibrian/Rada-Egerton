import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:rada_egerton/data/providers/application_provider.dart';
import 'package:rada_egerton/data/providers/authentication_provider.dart';
import 'package:rada_egerton/data/services/auth_service.dart';
import 'package:rada_egerton/data/status.dart';
import 'package:rada_egerton/resources/utils/main.dart';

part 'state.dart';

class LoginCubit extends Cubit<LoginState> {
  final GlobalKey<FormState> loginFormKey;
  final AuthenticationProvider authenticationProvider;
  final RadaApplicationProvider applicationProvider;
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  LoginCubit(
    this.loginFormKey,
    this.authenticationProvider,
    this.applicationProvider,
  ) : super(
          const LoginState(),
        );

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
    if (loginFormKey.currentState?.validate() == true) {
      emit(
        state.copyWith(
          status: ServiceStatus.submiting,
          message: InfoMessage(
            "Submiting please wait ...",
            MessageType.success,
          ),
        ),
      );
      final res = await AuthService.logInUser(
        state.email,
        state.password,
      );

      res.fold(
        (data) {
          emit(
            state.copyWith(
              status: ServiceStatus.submissionSucess,
              message: InfoMessage(
                "Login success",
                MessageType.success,
              ),
            ),
          );
          authenticationProvider.loginUser(
            user: data.user,
            authToken: data.authToken,
          );
          applicationProvider.init();
          
          //Register user device token for firebase messaging
          messaging.getToken().then(
            (value) {
              if (value != null) {
                AuthService.registerDeviceToken(value).then(
                  (res) => res.fold(
                    (l) => print(l),
                    (r) => print(r),
                  ),
                );
              }
            },
          );
        },
        (r) {
          emit(
            state.copyWith(
              status: ServiceStatus.submissionFailure,
              message: InfoMessage(r.message, MessageType.error),
            ),
          );
        },
      );
    }
  }
}
