import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_employee.dart';
import 'package:lello/feature/gdp/timesheet/domain/repository/timesheet_repository.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_list_employee/get_list_employee.dart';

class GetListEmployeesImpl extends GetListEmployees {
  final TimesheetRepository repository;

  GetListEmployeesImpl({required this.repository});

  @override
  Future<Try<List<TimesheetEmployee>>> call(
      GetListEmployeesParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.getListEmployees(params.id);
  }

  Failure? _validate(GetListEmployeesParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.id.isEmpty) return InvalidParamFailure();
    return null;
  }
}
