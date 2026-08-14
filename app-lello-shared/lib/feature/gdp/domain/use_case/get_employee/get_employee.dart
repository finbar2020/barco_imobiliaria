import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/domain/entity/employee.dart';

abstract class GetEmployee extends UseCase<Employee, GetEmployeeParam> {}

class GetEmployeeParam {
  final String condominiumId;
  final String employeeId;

  GetEmployeeParam({required this.condominiumId, required this.employeeId});
}
