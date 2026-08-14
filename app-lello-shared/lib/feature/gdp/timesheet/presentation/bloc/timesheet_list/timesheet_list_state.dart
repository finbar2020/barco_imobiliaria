import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_filter.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/bloc/timesheet_list/timesheet_list_event.dart';

abstract class TimesheetListState extends Equatable {
  final List<Timesheet> list;
  final TimesheetListEvent? event;
  TimesheetFilter? query;

  final String? condominiumId;
  DateTime selectedMonth;

  TimesheetListState(this.list, this.event, this.query, this.condominiumId,
      this.selectedMonth);

  @override
  List<Object?> get props =>
      [list, event, query, condominiumId, selectedMonth];
}

class TimesheetListLoadingState extends TimesheetListState {
  TimesheetListLoadingState(List<Timesheet>? list, TimesheetListEvent? event,
      TimesheetFilter? query, String? condominiumId, DateTime selectedMonth)
      : super(list ?? [], event, query, condominiumId, selectedMonth);
}

class TimesheetListLoadFailedState extends TimesheetListState {
  final Failure error;

  TimesheetListLoadFailedState(
      List<Timesheet> list,
      TimesheetListEvent? event,
      TimesheetFilter query,
      String condominiumId,
      DateTime selectedMonth,
      this.error)
      : super(list, event, query, condominiumId, selectedMonth);

  @override
  List<Object?> get props => [...super.props, error];
}

class TimesheetListLoadedState extends TimesheetListState {
  final bool donePaging;

  TimesheetListLoadedState(
      List<Timesheet> list,
      TimesheetListEvent? event,
      TimesheetFilter? query,
      String condominiumId,
      DateTime selectedMonth,
      this.donePaging)
      : super(list, event, query, condominiumId, selectedMonth);

  @override
  List<Object?> get props => [...super.props, donePaging];
}

class TimesheetInsertingState extends TimesheetListState {
  final DateTime selectedDate;

  TimesheetInsertingState(
      List<Timesheet> list,
      TimesheetListEvent event,
      TimesheetFilter query,
      String condominiumId,
      DateTime selectedMonth,
      this.selectedDate)
      : super(list, event, query, condominiumId, selectedMonth);

  @override
  List<Object?> get props => [...super.props, selectedDate];
}

class TimesheetInsertFailedState extends TimesheetListState {
  final Failure error;

  TimesheetInsertFailedState(
      List<Timesheet> list,
      TimesheetListEvent event,
      TimesheetFilter query,
      String condominiumId,
      DateTime selectedMonth,
      this.error)
      : super(list, event, query, condominiumId, selectedMonth);

  @override
  List<Object?> get props => [...super.props, error];
}

class TimesheetInsertedState extends TimesheetListState {
  final bool donePaging;

  TimesheetInsertedState(
      List<Timesheet> list,
      TimesheetListEvent event,
      TimesheetFilter query,
      String condominiumId,
      DateTime selectedMonth,
      this.donePaging)
      : super(list, event, query, condominiumId, selectedMonth);

  @override
  List<Object?> get props => [...super.props, donePaging];
}
