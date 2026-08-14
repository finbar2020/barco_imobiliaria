import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/domain/entity/employee.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/repository/timesheet_repository.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/list_timesheet_employee/list_timesheet_employee.dart';

class ListTimesheetEmployeeImpl extends ListTimesheetEmployee {
  final TimesheetGDPRepository repository;

  ListTimesheetEmployeeImpl({required this.repository});

  @override
  Future<Try<List<Employee>>> call(ListTimesheetEmployeeParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.listEmployees(params.condominiumId);
  }

  Failure? _validate(ListTimesheetEmployeeParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
