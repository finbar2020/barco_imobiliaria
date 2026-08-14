import 'package:colaborador/feature/authentication_tablet/domain/entity/condo_info.dart';
import 'package:colaborador/feature/authentication_tablet/domain/entity/employee_info.dart';

class CondominiumCodeInfo {
  final String condoCode;
  final CondoInfo condominium;
  final List<EmployeeInfo> employees;

  CondominiumCodeInfo({
    required this.condoCode,
    required this.condominium,
    required this.employees,
  });
}
