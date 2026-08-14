import 'package:shared_features/feature/gdp/domain/entity/employee.dart';
import 'package:shared_features/feature/gdp/quick_fix/domain/entity/employee_report_item.dart';

import 'employee_report_type.dart';

class EmployeeReport {
  EmployeeReportType? type;
  Employee? employee;
  List<EmployeeReportItem>? items;
  String? stabilityDescription;
  DateTime? stabilityEnd;
  DateTime? stabilityStart;

  EmployeeReport(
      {this.employee,
      this.items,
      this.stabilityDescription,
      this.stabilityEnd,
      this.stabilityStart,
      this.type});
}
