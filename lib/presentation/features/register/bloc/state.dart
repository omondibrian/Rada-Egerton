part of 'bloc.dart';

class RegisterState extends Equatable {
  final String email;
  final String password;
  final ServiceStatus submissionStatus;
  final InfoMessage? message;
  final String username;
  const RegisterState({
    this.username = "",
    this.message,
    this.email = "",
    this.password = "",
    this.submissionStatus = ServiceStatus.initial,
  });

  RegisterState copyWith({
    String? email,
    String? password,
    String? userName,
    ServiceStatus? status,
    InfoMessage? message,
  }) {
    return RegisterState(
      username: userName ?? username,
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
        username,
        message
      ];
}
