import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/domain/entity/condominium.dart';
import 'package:shared_features/feature/gdp/quick_fix/domain/entity/employee_report_filter.dart';

abstract class QuickFixReportEvent extends Equatable {
  const QuickFixReportEvent();

  @override
  List<Object?> get props => [];
}

class QuickFixReportLoadEvent extends QuickFixReportEvent {
  final CondominiumGDP condominium;
  final EmployeeReportFilter? filter;

  const QuickFixReportLoadEvent({required this.condominium, this.filter});

  @override
  List<Object?> get props => [condominium, filter];
}
