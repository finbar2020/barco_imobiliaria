import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/quick_fix/domain/entity/employee_report.dart';
import 'package:lello/feature/gdp/quick_fix/domain/entity/employee_report_type.dart';

abstract class GetEmployeeReport
    extends UseCase<EmployeeReport, GetEmployeeReportParam> {}

class GetEmployeeReportParam {
  final String condominiumId;
  final String employeeId;
  final EmployeeReportType reportType;

  GetEmployeeReportParam(
      {required this.condominiumId,
      required this.employeeId,
      required this.reportType});
}
