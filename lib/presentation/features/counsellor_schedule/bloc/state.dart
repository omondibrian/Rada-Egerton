part of "bloc.dart";

class ScheduleState extends Equatable {
  final bool canEdit;
  final Counsellor? counsellor;
  final InfoMessage? message;
  final ServiceStatus status;

  const ScheduleState({
    this.counsellor,
    this.canEdit = false,
    this.status = ServiceStatus.initial,
    this.message,
  });
  ScheduleState copyWith({
    bool? canEdit,
    Counsellor? counsellor,
    InfoMessage? message,
    ServiceStatus? status,
  }) {
    return ScheduleState(
      message: message,
      status: status ?? this.status,
      canEdit: canEdit ?? this.canEdit,
      counsellor: counsellor ?? this.counsellor,
    );
  }

  @override
  List<Object?> get props => [
        counsellor,
        message,
        status,
        canEdit,
      ];
}
