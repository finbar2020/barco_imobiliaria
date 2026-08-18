import 'package:lello/feature/gdp/quick_fix/domain/entity/employee_report_filter.dart';

import '../../../../../condominium/domain/entity/condominium.dart';

abstract class QuickFixReportEvent {}

class QuickFixReportLoadEvent extends QuickFixReportEvent {
  final Condominium condominium;
  final EmployeeReportFilter? filter;

  QuickFixReportLoadEvent({required this.condominium, this.filter});
}
