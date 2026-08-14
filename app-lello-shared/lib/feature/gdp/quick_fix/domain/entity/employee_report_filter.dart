import 'package:shared_features/feature/gdp/domain/entity/employee.dart';
import 'package:shared_features/feature/gdp/quick_fix/domain/entity/employee_report_type.dart';

class EmployeeReportFilter {
  EmployeeReportType? reportType;
  Employee? employee;

  EmployeeReportFilter({this.reportType, this.employee});
}
