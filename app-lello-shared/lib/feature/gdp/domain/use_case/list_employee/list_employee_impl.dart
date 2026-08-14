import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/domain/entity/employee.dart';
import 'package:shared_features/feature/gdp/domain/repository/employee_repository.dart';
import 'package:shared_features/feature/gdp/domain/use_case/list_employee/list_employee.dart';

class ListEmployeeImpl extends ListEmployee {
  final EmployeeRepository repository;

  ListEmployeeImpl({required this.repository});

  @override
  Future<Try<List<Employee>>> call(ListEmployeeParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.list(params.condominiumId, params.origin,
        lastEmployeeId: params.lastEmployeeId, filter: params.filter);
  }

  Failure? _validate(ListEmployeeParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
