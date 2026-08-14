import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/quick_fix/domain/entity/employee_report.dart';
import 'package:shared_features/feature/gdp/quick_fix/domain/repository/employee_report_repository.dart';
import 'package:shared_features/feature/gdp/quick_fix/domain/use_case/get_report/get_employee_report.dart';

class GetEmployeeReportImpl extends GetEmployeeReport {
  final EmployeeReportRepository repository;

  GetEmployeeReportImpl({required this.repository});

  @override
  Future<Try<EmployeeReport>> call(GetEmployeeReportParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.get(
        params.condominiumId, params.employeeId, params.reportType);
  }

  Failure? _validate(GetEmployeeReportParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    if (param.employeeId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
