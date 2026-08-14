import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:lello/core/analytics/analytics_log_events.dart';
import 'package:lello/feature/gdp/vacation/domain/entity/vacation_created.dart';
import 'package:lello/feature/gdp/vacation/domain/use_case/schedule_vacation/schedule_vacation.dart';
import 'package:lello/feature/gdp/vacation/presentation/bloc/schedule_vacation/schedule_vacation_event.dart';
import 'package:lello/feature/gdp/vacation/presentation/bloc/schedule_vacation/schedule_vacation_state.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';

class ScheduleVacationBloc
    extends Bloc<ScheduleVacationEvent, ScheduleVacationState> {
  final ScheduleVacation scheduleVacation;
  final SessionBloc sessionBloc;

  ScheduleVacationBloc(
      {required this.scheduleVacation, required this.sessionBloc})
      : super(ScheduleVacationLoadedState(null, null)) {
    on<CreateScheduledVacationEvent>(_mapCreateScheduledVacation);
  }

  Future<void> _mapCreateScheduledVacation(
    CreateScheduledVacationEvent event,
    Emitter<ScheduleVacationState> emit,
  ) async {
    String condominiumId =
        sessionBloc.state.session?.selectedCondominium?.id ?? "";
    final data = state.data;

    emit(ScheduleVacationLoadingState(data, condominiumId));

    final result = await scheduleVacation.call(ScheduleVacationParam(
      condominiumId: condominiumId,
      employeeId: event.employeeId,
      vacationCreated: event.vacationCreated,
    ));
    final foldedResult = result.fold(
        (err) => ScheduleVacationLoadFailedState(data, condominiumId, err),
        (res) => ScheduleVacationLoadedState(data, condominiumId));

    if (foldedResult is ScheduleVacationLoadedState) {
      String reference = sessionBloc
              .state.session?.selectedCondominium?.reference
              .toString() ??
          "";
      ManagerAnalyticsLogEvents.logEvent(
          event: AnalyticsEventsManager.agendarFeriasFinalizado(),
          referenceValue: reference);
    }
    emit(foldedResult);
  }

  void createScheduledVacation(
    String employeeId,
    VacationCreated vacationCreated,
  ) {
    add(CreateScheduledVacationEvent(
        employeeId: employeeId, vacationCreated: vacationCreated));
  }
}
