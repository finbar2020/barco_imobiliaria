import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/quick_fix/domain/entity/employee_report.dart';
import 'package:shared_features/feature/gdp/quick_fix/domain/entity/employee_report_type.dart';

abstract class EmployeeReportRepository {
  Future<Try<EmployeeReport>> get(
      String condominiumId, String employeeId, EmployeeReportType reportType);
}
