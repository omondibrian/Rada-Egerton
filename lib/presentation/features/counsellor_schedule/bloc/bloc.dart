import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rada_egerton/data/entities/counsellors_dto.dart';
import 'package:rada_egerton/data/providers/authentication_provider.dart';
import 'package:rada_egerton/data/providers/counseling_provider.dart';
import 'package:rada_egerton/data/rest/client.dart';
import 'package:rada_egerton/data/status.dart';
import 'package:rada_egerton/resources/utils/main.dart';

part 'state.dart';

class CounsellorScheduleCubit extends Cubit<ScheduleState> {
  ///userId is provided to view a profile of a given user
  int? userId;
  final CounsellingProvider provider;
  CounsellorScheduleCubit({
    this.userId,
    required this.provider,
  }) : super(const ScheduleState()) {
    userId ??= AuthenticationProvider.instance.user.id;
    final councellor = provider.getCounsellor(userId: userId!);
    emit(
      state.copyWith(
        canEdit: userId == AuthenticationProvider.instance.user.id,
        counsellor: councellor,
        status: ServiceStatus.loadingSuccess,
      ),
    );
  }
  delete(Schedule schedule) {
    emit(
      state.copyWith(
        message: InfoMessage(
          "Updating, please wait...",
          MessageType.success,
        ),
      ),
    );
    List<Schedule> schedules =
        state.counsellor!.schedule.where((s) => s != schedule).toList();
    _updateSchedule(schedules);
  }

  _updateSchedule(List<Schedule> schedules) async {
    final res = await Client.counselling.updateSchedule(
      schedules,
      retryLog: (_) => emit(
        state.copyWith(
          message: InfoMessage(
            "An error occured, retying...",
            MessageType.error,
          ),
        ),
      ),
    );
    res.fold(
      (_) {
        final counsellor = state.counsellor?.copyWith(
          schedule: schedules,
        );
        provider.updateCounsellor(counsellor);
        emit(
          state.copyWith(
            counsellor: counsellor,
            status: ServiceStatus.submissionSucess,
            message: InfoMessage("Schedule Updated", MessageType.success),
          ),
        );
      },
      (error) => emit(
        state.copyWith(
          status: ServiceStatus.submissionFailure,
          message: InfoMessage.fromError(error),
        ),
      ),
    );
  }

  updateSchedule({
    required String day,
    required String from,
    required String to,
  }) async {
    emit(
      state.copyWith(
        status: ServiceStatus.submiting,
        message: InfoMessage(
          "Updating, please wait...",
          MessageType.success,
        ),
      ),
    );
    List<Schedule> schedules = state.counsellor?.schedule ?? [];
    final schedule =
        Schedule(day: day.toLowerCase(), activeFrom: from, activeTo: to);
    schedules = schedules.map(
      (s) {
        if (s.day.toLowerCase() == day.toLowerCase()) {
          return schedule;
        }
        return s;
      },
    ).toList();
    if (!schedules.contains(schedule)) {
      schedules.add(schedule);
    }
    await _updateSchedule(schedules);
  }
}
