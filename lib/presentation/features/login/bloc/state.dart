part of 'bloc.dart';

class LoginState extends Equatable {
  final String email;
  final String password;
  final ServiceStatus submissionStatus;
  final InfoMessage? message;
  const LoginState({
    this.message,
    this.email = "",
    this.password = "",
    this.submissionStatus = ServiceStatus.initial,
  });

  LoginState copyWith({
    String? email,
    String? password,
    ServiceStatus? status,
    InfoMessage? message,
  }) {
    return LoginState(
      message: message,
      email: email ?? this.email,
      password: password ?? this.password,
      submissionStatus: status ?? submissionStatus,
    );
  }

  @override
  List<Object?> get props => [
        email,
        password,
        submissionStatus,
        message
      ];
}
