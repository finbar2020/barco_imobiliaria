import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/quick_fix/domain/entity/employee_report.dart';
import 'package:lello/feature/gdp/quick_fix/domain/entity/employee_report_filter.dart';

import '../../../../../condominium/domain/entity/condominium.dart';

abstract class QuickFixReportState {
  final EmployeeReport? data;
  final EmployeeReportFilter? filter;
  final Condominium? condominium;

  QuickFixReportState(this.data, this.condominium, {this.filter});
}

class QuickFixReportLoadingState extends QuickFixReportState {
  QuickFixReportLoadingState(EmployeeReport? data, Condominium? condominium,
      {EmployeeReportFilter? filter})
      : super(data, condominium);
}

class QuickFixReportLoadFailedState extends QuickFixReportState {
  final Failure error;

  QuickFixReportLoadFailedState(
      EmployeeReport? data, Condominium condominium, this.error,
      {EmployeeReportFilter? filter})
      : super(data, condominium, filter: filter);
}

class QuickFixReportLoadedState extends QuickFixReportState {
  QuickFixReportLoadedState(EmployeeReport data, Condominium condominium,
      {EmployeeReportFilter? filter})
      : super(data, condominium, filter: filter);
}
