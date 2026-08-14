import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/data/data_source/remote/employee_api.dart';
import 'package:lello/feature/gdp/data/data_source/remote/employee_remote_data_source.dart';
import 'package:lello/feature/gdp/data/model/employee_model.dart';
import 'package:lello/feature/gdp/domain/entity/employee_list_filter.dart';

class EmployeeRemoteDataSourceImpl extends EmployeeRemoteDataSource {
  final EmployeeApi api;

  EmployeeRemoteDataSourceImpl({required this.api});
  @override
  Future<List<EmployeeModel>> list(String condominiumId,
      {String? lastEmployeeId, EmployeeListFilter? filter}) async {
    final response = await api.list(condominiumId, lastEmployeeId,
        name: filter?.name,
        role: filter?.role,
        salaryFrom: filter?.salaryFrom == null || filter?.salaryFrom == 0
            ? null
            : filter!.salaryFrom,
        salaryTo: filter?.salaryTo == null || filter!.salaryTo == 0
            ? null
            : filter.salaryTo,
        dobFrom: filter?.dobFrom,
        dobTo: filter?.dobTo,
        hiringDateFrom: filter?.hiringDateFrom,
        hiringDateTo: filter?.hiringDateTo,
        conditionName: filter?.conditionName,
        status: filter?.status);

    return ApiMapper.mapList(response, (json) => EmployeeModel.fromJson(json));
  }

  @override
  Future<EmployeeModel> get(String condominiumId, String employeeId) async {
    final response = await api.get(condominiumId, employeeId);
    var employee =
        ApiMapper.map(response, (json) => EmployeeModel.fromJson(json));
    return employee;
  }
}
