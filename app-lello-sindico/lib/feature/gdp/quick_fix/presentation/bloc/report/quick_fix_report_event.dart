import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/quick_fix/domain/entity/employee_report_filter.dart';

import '../../../../../condominium/domain/entity/condominium.dart';

abstract class QuickFixReportEvent extends Equatable {
  const QuickFixReportEvent();

  @override
  List<Object?> get props => [];
}

class QuickFixReportLoadEvent extends QuickFixReportEvent {
  final Condominium condominium;
  final EmployeeReportFilter? filter;

  const QuickFixReportLoadEvent({required this.condominium, this.filter});

  @override
  List<Object?> get props => [condominium, filter];
}
