import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/domain/entity/employee.dart';
import 'package:shared_features/feature/gdp/domain/repository/employee_repository.dart';
import 'package:shared_features/feature/gdp/domain/use_case/get_employee/get_employee.dart';

class GetEmployeeImpl extends GetEmployee {
  final EmployeeRepository repository;

  GetEmployeeImpl({required this.repository});

  @override
  Future<Try<Employee>> call(GetEmployeeParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.get(params.condominiumId, params.employeeId);
  }

  Failure? _validate(GetEmployeeParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    if (param.employeeId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
