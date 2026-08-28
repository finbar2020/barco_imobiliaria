import 'dart:async';
import 'dart:core';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_filter.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/get_report_day/get_report_day.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/list_timesheet_employee/list_timesheet_employee.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/request_timesheet/request_timesheet.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/bloc/timesheet_menu/timesheet_menu_event.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/bloc/timesheet_menu/timesheet_menu_state.dart';
import 'package:shared_features/shared_features.dart';

class TimesheetMenuBloc extends Bloc<TimesheetMenuEvent, TimesheetMenuState> {
  final SharedSession? sessionBloc;
  final ListTimesheetEmployee listTimesheetEmployee;
  final GetReportDay getReportDay;
  final RequestTimesheet requestTimesheet;

  StreamSubscription? _subscription;

  TimesheetMenuBloc(
      {required this.sessionBloc,
      required this.listTimesheetEmployee,
      required this.getReportDay,
      required this.requestTimesheet})
      : super(TimesheetMenuReportLoadingState(null, null, null, null, null)) {
    on<TimesheetMenuLoadEvent>(_mapLoad);
    on<TimesheetRequestEvent>(_mapRequestTimesheet);
    _onSessionChanged();
  }
  DateTime today = new DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);

  Future<void> _mapLoad(
    TimesheetMenuLoadEvent event,
    Emitter<TimesheetMenuState> emit,
  ) async {
    final condominiumId = event.condominiumId ?? state.condominiumId;
    TimesheetFilter filter = TimesheetFilter(dobTo: today, dobFrom: today);
    emit(TimesheetMenuReportLoadingState(state.list, state.report, state.query,
        condominiumId, state.selectedMonth));

    final result = await getReportDay
        .call(GetReportDayParam(condominiumId: condominiumId!, filter: filter));

    emit(result.fold(
        (err) => TimesheetMenuReportLoadFailedState(state.list, state.report,
            state.query, condominiumId, state.selectedMonth, err), (data) {
      return TimesheetMenuReportLoadedState(
          state.list, data, state.query, condominiumId, state.selectedMonth);
    }));

    await _mapLoadEmployees(event, emit);
  }

  Future<void> _mapLoadEmployees(
    TimesheetMenuLoadEvent event,
    Emitter<TimesheetMenuState> emit,
  ) async {
    final condominiumId = event.condominiumId ?? state.condominiumId;

    emit(TimesheetMenuEmployeesLoadingState(state.list, state.report,
        state.query, condominiumId!, state.selectedMonth));

    final resultEmployees = await listTimesheetEmployee
        .call(ListTimesheetEmployeeParam(condominiumId: condominiumId));

    emit(resultEmployees.fold(
        (err) => TimesheetMenuEmployeesLoadFailedState(
            state.list,
            state.report,
            state.query,
            condominiumId,
            state.selectedMonth,
            err), (data) {
      if (data.length == 0) {
        return TimesheetMenuWarningState(data, state.report, state.query,
            condominiumId, state.selectedMonth, data.length == 0);
      }
      return TimesheetMenuEmployeesLoadedState(data, state.report, state.query,
          condominiumId, state.selectedMonth, data.length == 0);
    }));
  }

  Future<void> _mapRequestTimesheet(
    TimesheetRequestEvent event,
    Emitter<TimesheetMenuState> emit,
  ) async {
    final condominiumId = event.condominiumId ?? state.condominiumId;

    emit(TimesheetRequestLoadingState(state.list, state.report, state.query,
        condominiumId!, state.selectedMonth));

    final resultRequest = await requestTimesheet
        .call(RequestTimesheetParam(condominiumId: condominiumId));

    emit(resultRequest.fold(
        (err) => TimesheetRequestLoadFailedState(state.list, state.report,
            state.query, condominiumId, state.selectedMonth, err), (data) {
      return TimesheetRequestLoadedState(state.list, state.report, state.query,
          condominiumId, state.selectedMonth, data.length == 0);
    }));
  }

  void _onSessionChanged() {
    if (sessionBloc?.condominiumId != null) {
      add(TimesheetMenuLoadEvent(condominiumId: sessionBloc!.condominiumId));
    }
  }

  void beginRefresh() {
    if (!(state is TimesheetMenuReportLoadingState) &&
        !(state is TimesheetMenuEmployeesLoadingState)) {
      add(TimesheetMenuLoadEvent(condominiumId: state.condominiumId));
    }
  }

  void beginRequest() {
    if (!(state is TimesheetMenuReportLoadingState) &&
        !(state is TimesheetMenuEmployeesLoadingState)) {
      add(TimesheetRequestEvent(condominiumId: state.condominiumId));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
