import 'dart:core';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_periods.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_month_resume/get_month_resume.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_timesheet_periods/get_timesheet_periods.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_month_resume/timesheet_menu_event.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_month_resume/timesheet_menu_state.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';

class TimesheetMenuBloc extends Bloc<TimesheetMenuEvent, TimesheetMenuState> {
  final SessionBloc sessionBloc;
  final GetMonthResume monthResume;
  final GetTimesheetPeriodsUsecase getTimesheetPeriods;

  late DateTime selectDate;
  late List<TimesheetPeriods> listPeriods;

  TimesheetMenuBloc({
    required this.sessionBloc,
    required this.monthResume,
    required this.getTimesheetPeriods,
  }) : super(TimesheetLoadingState()) {
    on<TimesheetGetMonthResumeEvent>(_mapGetResume);
    on<TimesheetGetPeriodsEvent>(_mapGetPeriods);
  }

  Future<void> _mapGetPeriods(
    TimesheetGetPeriodsEvent event,
    Emitter<TimesheetMenuState> emit,
  ) async {
    emit(TimesheetLoadingState());

    final result = (await getTimesheetPeriods.call(GetTimesheetPeriodsParam(
        condoId: sessionBloc.state.session!.selectedCondominium!.id)));

    emit(result.fold((err) => TimesheetMonthResumeFailedState(), (data) {
      listPeriods = data;
      if (data.isEmpty) {
        return TimesheetFailedState();
      }
      selectDate = data.first.periodMonth;
      add(TimesheetGetMonthResumeEvent(date: selectDate));
      return TimesheetLoadedState();
    }));
  }

  Future<void> _mapGetResume(
    TimesheetGetMonthResumeEvent event,
    Emitter<TimesheetMenuState> emit,
  ) async {
    emit(TimesheetMonthResumeLoadingState());

    final result =
        await monthResume.call(GetMonthResumeParam(date: setDate(event.date)));

    emit(result.fold((err) => TimesheetMonthResumeFailedState(), (data) {
      return TimesheetMonthResumeLoadedState(entity: data, date: event.date);
    }));
  }

  void getPeriods() {
    add(TimesheetGetPeriodsEvent());
  }

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
