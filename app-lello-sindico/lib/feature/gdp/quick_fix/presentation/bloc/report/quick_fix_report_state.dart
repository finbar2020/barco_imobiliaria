import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/quick_fix/domain/entity/employee_report.dart';
import 'package:lello/feature/gdp/quick_fix/domain/entity/employee_report_filter.dart';

import '../../../../../condominium/domain/entity/condominium.dart';

abstract class QuickFixReportState extends Equatable {
  final EmployeeReport? data;
  final EmployeeReportFilter? filter;
  final Condominium? condominium;

  const QuickFixReportState(this.data, this.condominium, {this.filter});

  @override
  List<Object?> get props => [data, condominium, filter];
}

class QuickFixReportLoadingState extends QuickFixReportState {
  const QuickFixReportLoadingState(EmployeeReport? data, Condominium? condominium,
      {EmployeeReportFilter? filter})
      : super(data, condominium, filter: filter);
}

class QuickFixReportLoadFailedState extends QuickFixReportState {
  final Failure error;

  const QuickFixReportLoadFailedState(
      EmployeeReport? data, Condominium condominium, this.error,
      {EmployeeReportFilter? filter})
      : super(data, condominium, filter: filter);

  @override
  List<Object?> get props => [...super.props, error];
}

class QuickFixReportLoadedState extends QuickFixReportState {
  const QuickFixReportLoadedState(EmployeeReport data, Condominium condominium,
      {EmployeeReportFilter? filter})
      : super(data, condominium, filter: filter);
}
