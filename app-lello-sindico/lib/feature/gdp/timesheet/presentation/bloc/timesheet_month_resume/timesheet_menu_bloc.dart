import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_periods.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_month_resume/timesheet_menu_event.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_month_resume/timesheet_menu_state.dart';

abstract class TimesheetMenuBloc
    extends Bloc<TimesheetMenuEvent, TimesheetMenuState> {
  TimesheetMenuBloc(TimesheetMenuState initialState) : super(initialState);

  void getPeriods();

  void getMonthResume(DateTime date);

  late DateTime selectDate;
  late List<TimesheetPeriods> listPeriods;
}
