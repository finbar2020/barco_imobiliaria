import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/quick_fix/data/data_source/remote/employee_report_api.dart';
import 'package:shared_features/feature/gdp/quick_fix/data/data_source/remote/employee_report_remote_data_source.dart';
import 'package:shared_features/feature/gdp/quick_fix/data/model/employee_report_model.dart';
import 'package:shared_features/feature/gdp/quick_fix/domain/entity/employee_report_type.dart';

class EmployeeReportRemoteDataSourceImpl
    extends EmployeeReportRemoteDataSource {
  final EmployeeReportApi api;

  EmployeeReportRemoteDataSourceImpl({required this.api});

  @override
  Future<EmployeeReportModel> get(String condominiumId, String employeeId,
      EmployeeReportType reportType) async {
    final response =
        await api.get(condominiumId, employeeId, reportType.getValue());
    return ApiMapper.map(
        response, (json) => EmployeeReportModel.fromJson(json));
  }
}
