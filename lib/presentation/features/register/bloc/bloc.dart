import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rada_egerton/data/entities/auth_dto.dart';
import 'package:rada_egerton/data/rest/client.dart';
import 'package:rada_egerton/data/status.dart';
import 'package:rada_egerton/resources/utils/main.dart';

part 'state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final GlobalKey<FormState> registerForm;
  RegisterCubit(this.registerForm) : super(const RegisterState());

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

  usernameChanged(String value) {
    emit(
      state.copyWith(userName: value),
    );
  }

  submit() async {
    if (registerForm.currentState?.validate() == true) {
      emit(state.copyWith(
        status: ServiceStatus.submiting,
        message: InfoMessage(
          "Submiting please wait ...",
          MessageType.success,
        ),
      ));
      final res = await Client.users.register(
        AuthDTO(
          email: state.email,
          password: state.password,
          userName: state.username,
          university: 'Egerton',
        ),
      );

      res.fold(
        (l) {
          emit(
            state.copyWith(
              status: ServiceStatus.submissionSucess,
              message: InfoMessage(
                "Registration success",
                MessageType.success,
              ),
            ),
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
