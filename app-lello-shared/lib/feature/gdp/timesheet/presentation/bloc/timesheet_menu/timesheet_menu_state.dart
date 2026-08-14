import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/domain/entity/employee.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_filter.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_report_day.dart';

abstract class TimesheetMenuState extends Equatable {
  final List<Employee> list;
  final TimesheetReportDay? report;
  final TimesheetFilter? query;

  final String? condominiumId;
  DateTime? selectedMonth;

  TimesheetMenuState(this.list, this.report, this.query, this.condominiumId,
      this.selectedMonth);

  @override
  List<Object?> get props =>
      [list, report, query, condominiumId, selectedMonth];
}

class TimesheetMenuReportLoadingState extends TimesheetMenuState {
  TimesheetMenuReportLoadingState(
      List<Employee>? list,
      TimesheetReportDay? report,
      TimesheetFilter? query,
      String? condominiumId,
      DateTime? selectedMonth)
      : super(list ?? [], report, query, condominiumId, selectedMonth);
}

class TimesheetMenuReportLoadFailedState extends TimesheetMenuState {
  final Failure error;

  TimesheetMenuReportLoadFailedState(
      List<Employee> list,
      TimesheetReportDay? report,
      TimesheetFilter? query,
      String condominiumId,
      DateTime? selectedMonth,
      this.error)
      : super(list, report, query, condominiumId, selectedMonth);

  @override
  List<Object?> get props => [...super.props, error];
}

class TimesheetMenuReportLoadedState extends TimesheetMenuState {
  TimesheetMenuReportLoadedState(List<Employee> list, TimesheetReportDay report,
      TimesheetFilter? query, String condominiumId, DateTime? selectedMonth)
      : super(list, report, query, condominiumId, selectedMonth);
}

class TimesheetMenuEmployeesLoadingState extends TimesheetMenuState {
  TimesheetMenuEmployeesLoadingState(
      List<Employee> list,
      TimesheetReportDay? report,
      TimesheetFilter? query,
      String condominiumId,
      DateTime? selectedMonth)
      : super(list, report, query, condominiumId, selectedMonth);
}

class TimesheetMenuEmployeesLoadFailedState extends TimesheetMenuState {
  final Failure error;

  TimesheetMenuEmployeesLoadFailedState(
      List<Employee> list,
      TimesheetReportDay report,
      TimesheetFilter query,
      String condominiumId,
      DateTime selectedMonth,
      this.error)
      : super(list, report, query, condominiumId, selectedMonth);

  @override
  List<Object?> get props => [...super.props, error];
}

class TimesheetMenuEmployeesLoadedState extends TimesheetMenuState {
  final bool donePaging;

  TimesheetMenuEmployeesLoadedState(
      List<Employee> list,
      TimesheetReportDay? report,
      TimesheetFilter? query,
      String condominiumId,
      DateTime? selectedMonth,
      this.donePaging)
      : super(list, report, query, condominiumId, selectedMonth);

  @override
  List<Object?> get props => [...super.props, donePaging];
}

class TimesheetMenuWarningState extends TimesheetMenuState {
  final bool donePaging;

  TimesheetMenuWarningState(
      List<Employee> list,
      TimesheetReportDay? report,
      TimesheetFilter? query,
      String condominiumId,
      DateTime? selectedMonth,
      this.donePaging)
      : super(list, report, query, condominiumId, selectedMonth);

  @override
  List<Object?> get props => [...super.props, donePaging];
}

class TimesheetRequestLoadingState extends TimesheetMenuState {
  TimesheetRequestLoadingState(List<Employee> list, TimesheetReportDay? report,
      TimesheetFilter? query, String condominiumId, DateTime? selectedMonth)
      : super(list, report, query, condominiumId, selectedMonth);
}

class TimesheetRequestLoadFailedState extends TimesheetMenuState {
  final Failure error;

  TimesheetRequestLoadFailedState(
      List<Employee> list,
      TimesheetReportDay? report,
      TimesheetFilter? query,
      String condominiumId,
      DateTime? selectedMonth,
      this.error)
      : super(list, report, query, condominiumId, selectedMonth);

  @override
  List<Object?> get props => [...super.props, error];
}

class TimesheetRequestLoadedState extends TimesheetMenuState {
  final bool donePaging;

  TimesheetRequestLoadedState(
      List<Employee> list,
      TimesheetReportDay? report,
      TimesheetFilter? query,
      String condominiumId,
      DateTime? selectedMonth,
      this.donePaging)
      : super(list, report, query, condominiumId, selectedMonth);

  @override
  List<Object?> get props => [...super.props, donePaging];
}
