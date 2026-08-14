import 'package:lello/feature/gdp/data/model/employee_model.dart';
import 'package:lello/feature/gdp/domain/entity/employee_list_filter.dart';

abstract class EmployeeRemoteDataSource {
  Future<List<EmployeeModel>> list(String condominiumId,
      {String? lastEmployeeId, EmployeeListFilter? filter});
  Future<EmployeeModel> get(String condominiumId, String employeeId);
}
