import 'dart:core';

import 'package:lello/feature/gdp/timesheet/domain/use_case/get_month_resume/get_month_resume.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_timesheet_periods/get_timesheet_periods.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_month_resume/timesheet_menu_bloc.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_month_resume/timesheet_menu_event.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_month_resume/timesheet_menu_state.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';

class TimesheetMenuBlocImpl extends TimesheetMenuBloc {
  final SessionBloc sessionBloc;
  final GetMonthResume monthResume;
  final GetTimesheetPeriodsUsecase getTimesheetPeriods;

  TimesheetMenuBlocImpl({
    required this.sessionBloc,
    required this.monthResume,
    required this.getTimesheetPeriods,
  }) : super(TimesheetLoadingState());

  @override
  Stream<TimesheetMenuState> mapEventToState(TimesheetMenuEvent event) async* {
    if (event is TimesheetGetMonthResumeEvent) yield* _mapGetResume(event);
    if (event is TimesheetGetPeriodsEvent) yield* _mapGetPeriods(event);
  }

  Stream<TimesheetMenuState> _mapGetPeriods(
      TimesheetGetPeriodsEvent event) async* {
    yield TimesheetLoadingState();

    final result = (await getTimesheetPeriods.call(GetTimesheetPeriodsParam(
        condoId: sessionBloc.state.session!.selectedCondominium!.id)));

    yield result.fold((err) => TimesheetMonthResumeFailedState(), (data) {
      listPeriods = data;
      if (data.isEmpty) {
        return TimesheetFailedState();
      }
      selectDate = data.first.periodMonth;
      add(TimesheetGetMonthResumeEvent(date: selectDate));
      return TimesheetLoadedState();
    });
  }

  Stream<TimesheetMenuState> _mapGetResume(
      TimesheetGetMonthResumeEvent event) async* {
    yield TimesheetMonthResumeLoadingState();

    final result =
        await monthResume.call(GetMonthResumeParam(date: setDate(event.date)));

    yield result.fold((err) => TimesheetMonthResumeFailedState(), (data) {
      return TimesheetMonthResumeLoadedState(entity: data, date: event.date);
    });
  }

  @override
  void getPeriods() {
    add(TimesheetGetPeriodsEvent());
  }

  @override
  void getMonthResume(DateTime date) {
    add(TimesheetGetMonthResumeEvent(date: date));
  }

  setMonth(int month) {
    if (month < 10) {
      return "0$month";
    } else {
      return month.toString();
    }
  }

  setDate(DateTime date) {
    return "${date.year}-${setMonth(date.month)}-01";
  }
}
