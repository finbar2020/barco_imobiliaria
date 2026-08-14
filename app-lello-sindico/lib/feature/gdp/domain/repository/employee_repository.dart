import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/domain/entity/employee.dart';
import 'package:lello/feature/gdp/domain/entity/employee_list_filter.dart';

abstract class EmployeeRepository {
  Future<Try<List<Employee>>> list(String condominiumId, DataOrigin origin,
      {String? lastEmployeeId, EmployeeListFilter? filter});
  Future<Try<Employee>> get(String condominiumId, String employeeId);
}
