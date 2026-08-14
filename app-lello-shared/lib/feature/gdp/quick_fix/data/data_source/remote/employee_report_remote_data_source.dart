import 'package:shared_features/feature/gdp/quick_fix/data/model/employee_report_model.dart';
import 'package:shared_features/feature/gdp/quick_fix/domain/entity/employee_report_type.dart';

abstract class EmployeeReportRemoteDataSource {
  Future<EmployeeReportModel> get(
      String condominiumId, String employeeId, EmployeeReportType reportType);
}
