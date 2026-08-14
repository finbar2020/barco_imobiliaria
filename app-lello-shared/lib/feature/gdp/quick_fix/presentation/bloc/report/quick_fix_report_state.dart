import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/domain/entity/condominium.dart';
import 'package:shared_features/feature/gdp/quick_fix/domain/entity/employee_report.dart';
import 'package:shared_features/feature/gdp/quick_fix/domain/entity/employee_report_filter.dart';

abstract class QuickFixReportState extends Equatable {
  final EmployeeReport? data;
  final EmployeeReportFilter? filter;
  final CondominiumGDP? condominium;

  const QuickFixReportState(this.data, this.condominium, {this.filter});

  @override
  List<Object?> get props => [data, condominium, filter];
}

class QuickFixReportLoadingState extends QuickFixReportState {
  const QuickFixReportLoadingState(
      EmployeeReport? data, CondominiumGDP? condominium,
      {EmployeeReportFilter? filter})
      : super(data, condominium);
}

class QuickFixReportLoadFailedState extends QuickFixReportState {
  final Failure error;

  const QuickFixReportLoadFailedState(
      EmployeeReport? data, CondominiumGDP condominium, this.error,
      {EmployeeReportFilter? filter})
      : super(data, condominium, filter: filter);

  @override
  List<Object?> get props => [...super.props, error];
}

class QuickFixReportLoadedState extends QuickFixReportState {
  const QuickFixReportLoadedState(
      EmployeeReport data, CondominiumGDP condominium,
      {EmployeeReportFilter? filter})
      : super(data, condominium, filter: filter);
}
