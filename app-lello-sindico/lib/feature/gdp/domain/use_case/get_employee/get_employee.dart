import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/domain/entity/employee.dart';

abstract class GetEmployee extends UseCase<Employee, GetEmployeeParam> {}

class GetEmployeeParam {
  final String condominiumId;
  final String employeeId;

  GetEmployeeParam({required this.condominiumId, required this.employeeId});
}
