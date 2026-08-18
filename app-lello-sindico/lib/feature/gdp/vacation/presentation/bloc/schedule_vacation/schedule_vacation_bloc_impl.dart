import 'dart:async';

import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:lello/core/analytics/analytics_log_events.dart';
import 'package:lello/feature/gdp/vacation/domain/entity/vacation_created.dart';
import 'package:lello/feature/gdp/vacation/domain/use_case/schedule_vacation/schedule_vacation.dart';
import 'package:lello/feature/gdp/vacation/presentation/bloc/schedule_vacation/schedule_vacation_bloc.dart';
import 'package:lello/feature/gdp/vacation/presentation/bloc/schedule_vacation/schedule_vacation_event.dart';
import 'package:lello/feature/gdp/vacation/presentation/bloc/schedule_vacation/schedule_vacation_state.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';

class ScheduleVacationBlocImpl extends ScheduleVacationBloc {
  final ScheduleVacation scheduleVacation;
  final SessionBloc sessionBloc;

  ScheduleVacationBlocImpl(
      {required this.scheduleVacation, required this.sessionBloc})
      : super(ScheduleVacationLoadedState(null, null));

  @override
  Stream<ScheduleVacationState> mapEventToState(
      ScheduleVacationEvent event) async* {
    if (event is CreateScheduledVacationEvent)
      yield* _mapCreateScheduledVacation(event);
  }

  Stream<ScheduleVacationState> _mapCreateScheduledVacation(
      CreateScheduledVacationEvent event) async* {
    String condominiumId =
        sessionBloc.state.session?.selectedCondominium?.id ?? "";
    final data = state.data;

    yield ScheduleVacationLoadingState(data, condominiumId);

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
    yield foldedResult;
  }

  @override
  void createScheduledVacation(
    String employeeId,
    VacationCreated vacationCreated,
  ) {
    add(CreateScheduledVacationEvent(
        employeeId: employeeId, vacationCreated: vacationCreated));
  }
}
