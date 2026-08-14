import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/domain/entity/employee.dart';
import 'package:lello/feature/gdp/domain/entity/employee_list_filter.dart';

abstract class ListEmployee extends UseCase<List<Employee>, ListEmployeeParam> {
}

class ListEmployeeParam {
  final String condominiumId;
  final String? lastEmployeeId;
  final EmployeeListFilter? filter;
  final DataOrigin origin;

  ListEmployeeParam(
      {required this.condominiumId,
      this.lastEmployeeId,
      required this.origin,
      this.filter});
}
