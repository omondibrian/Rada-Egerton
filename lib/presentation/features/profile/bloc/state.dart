part of "bloc.dart";

class ProfileState extends Equatable {
  final User? user;
  final bool readOnly;

  final String? emailUpdate;
  final String? phoneUpdate;
  final String? nameUpdate;

  final ServiceStatus status;
  final InfoMessage? message;
  const ProfileState({
    this.message,
    this.status = ServiceStatus.initial,
    this.readOnly = true,
    this.user,
    this.emailUpdate,
    this.phoneUpdate,
    this.nameUpdate,
  });
  ProfileState copyWith({
    User? user,
    bool? readOnly,
    String? emailUpdate,
    String? phoneUpdate,
    String? nameUpdate,
    ServiceStatus? status,
    InfoMessage? message,
  }) {
    return ProfileState(
      emailUpdate: emailUpdate ?? this.emailUpdate,
      user: user ?? this.user,
      message: message,
      status: status ?? this.status,
      phoneUpdate: phoneUpdate ?? this.phoneUpdate,
      readOnly: readOnly ?? this.readOnly,
      nameUpdate: nameUpdate ?? this.nameUpdate,
    );
  }

  @override
  List<Object?> get props => [
        user,
        readOnly,
        emailUpdate,
        phoneUpdate,
        status,
        message,
        nameUpdate,
      ];
}
