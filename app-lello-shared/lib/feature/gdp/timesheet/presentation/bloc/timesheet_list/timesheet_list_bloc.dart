import 'dart:async';
import 'dart:core';

import 'package:essentials/analytics/analytics_log_events.dart';
import 'package:essentials/analytics/events/analytics_events_employee.dart';
import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_event.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/insert_timesheet_event/insert_timesheet_event.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/list_timesheet/list_timesheet.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/bloc/timesheet_list/timesheet_list_event.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/bloc/timesheet_list/timesheet_list_state.dart';
import 'package:shared_features/shared_features.dart';

class TimesheetListBloc extends Bloc<TimesheetListEvent, TimesheetListState> {
  final SharedSession? sessionBloc;
  final ListTimesheet listTimesheet;
  final InsertTimesheetEvent insertTimesheetEvent;
  final AppOriginEnum appOriginEnum;

  StreamSubscription? _subscription;

  TimesheetListBloc(
      {required this.sessionBloc,
      required this.listTimesheet,
      required this.insertTimesheetEvent,
      required this.appOriginEnum})
      : super(
            TimesheetListLoadingState(null, null, null, null, DateTime.now())) {
    on<TimesheetListLoadEvent>(_mapLoad);
    on<TimesheetListInsertEvent>(_mapInsert);
    _onSessionChanged();
  }
  DateTime today = new DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);

  Future<void> _mapLoad(
    TimesheetListLoadEvent event,
    Emitter<TimesheetListState> emit,
  ) async {
    final condominiumId = event.condominiumId ?? state.condominiumId;
    emit(TimesheetListLoadingState(state.list, state.event, state.query,
        condominiumId, state.selectedMonth));

    final result = await listTimesheet.call(ListTimesheetParam(
        condominiumId: condominiumId!, filter: state.query!));

    final foldedResult = result.fold(
        (err) => TimesheetListLoadFailedState(state.list, state.event,
            state.query!, condominiumId, state.selectedMonth, err), (data) {
      AnalyticsLogEvents.logEvent(
        event: appOriginEnum == AppOriginEnum.manager
            ? AnalyticsEventsManager.pontoAcaoOcorrenciaAcessar()
            : AnalyticsEventsEmployee.pontoAcaoOcorrenciaAcessar(),
        unitValue: sessionBloc?.unitId.toString() ?? "",
        referenceValue: sessionBloc?.condominiumReference.toString() ?? "",
        appOrigin: appOriginEnum,
      );
      return TimesheetListLoadedState(data, state.event, state.query,
          condominiumId, state.selectedMonth, data.length == 0);
    });

    emit(foldedResult);
  }

  Future<void> _mapInsert(
    TimesheetListInsertEvent event,
    Emitter<TimesheetListState> emit,
  ) async {
    final condominiumId = state.condominiumId;
    emit(TimesheetInsertingState(
        state.list,
        event,
        state.query!,
        condominiumId!,
        state.selectedMonth,
        event.timesheetEvent.effectiveDate!));

    final result = await insertTimesheetEvent.call(InsertTimesheetEventParam(
        condominiumId: condominiumId, events: event.timesheetEvent));

    final foldedResult = result.fold(
        (err) => TimesheetInsertFailedState(state.list, event, state.query!,
            condominiumId, state.selectedMonth, err), (data) {
      beginRefresh();
      AnalyticsLogEvents.logEvent(
        event: appOriginEnum == AppOriginEnum.manager
            ? AnalyticsEventsManager.pontoAcaoOcorrenciaFinalizado(
                "Descontou ou abonou ocorrencia")
            : AnalyticsEventsEmployee.pontoAcaoOcorrenciaFinalizado(
                "Descontou ou abonou ocorrencia"),
        unitValue: sessionBloc?.unitId.toString() ?? "",
        referenceValue: sessionBloc?.condominiumReference.toString() ?? "",
        appOrigin: appOriginEnum,
      );
      return TimesheetInsertedState(state.list, event, state.query!,
          condominiumId, state.selectedMonth, true);
    });

    emit(foldedResult);
  }

  void _onSessionChanged() {
    if (sessionBloc?.condominiumId != null) {
      add(TimesheetListLoadEvent(condominiumId: sessionBloc!.condominiumId));
    }
  }

  void beginRefresh() {
    if (!(state is TimesheetListLoadingState)) {
      add(TimesheetListLoadEvent(condominiumId: state.condominiumId));
    }
  }

  void insertEvent(TimesheetEvent timesheetEvent) {
    if (!(state is TimesheetListLoadingState)) {
      add(TimesheetListInsertEvent(timesheetEvent: timesheetEvent));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
