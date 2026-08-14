import 'dart:async';

import 'package:essentials/analytics/analytics_log_events.dart';
import 'package:essentials/analytics/events/analytics_events_employee.dart';
import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_created.dart';
import 'package:shared_features/feature/gdp/vacation/domain/use_case/schedule_vacation/schedule_vacation.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/bloc/schedule_vacation/schedule_vacation_event.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/bloc/schedule_vacation/schedule_vacation_state.dart';
import 'package:shared_features/shared_features.dart';

class ScheduleVacationBloc
    extends Bloc<ScheduleVacationEvent, ScheduleVacationState> {
  final ScheduleVacation scheduleVacation;
  final SharedSession? sessionBloc;
  final AppOriginEnum appOriginEnum;

  ScheduleVacationBloc(
      {required this.scheduleVacation,
      required this.sessionBloc,
      required this.appOriginEnum})
      : super(const ScheduleVacationLoadedState(null, null)) {
    on<CreateScheduledVacationEvent>(_mapCreateScheduledVacation);
  }

  Future<void> _mapCreateScheduledVacation(
    CreateScheduledVacationEvent event,
    Emitter<ScheduleVacationState> emit,
  ) async {
    String condominiumId = sessionBloc?.condominiumId ?? "";
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
      switch (appOriginEnum) {
        case AppOriginEnum.manager:
          AnalyticsLogEvents.logEvent(
            event: AnalyticsEventsManager.agendarFeriasFinalizado(),
            referenceValue: sessionBloc?.condominiumReference.toString() ?? "",
            appOrigin: appOriginEnum,
          );
          break;
        case AppOriginEnum.employee:
          AnalyticsLogEvents.logEvent(
            event: AnalyticsEventsEmployee.agendarFeriasFinalizado(),
            referenceValue: sessionBloc?.condominiumReference.toString() ?? "",
            appOrigin: appOriginEnum,
          );
          break;
        case AppOriginEnum.owner:
          break;
      }
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
