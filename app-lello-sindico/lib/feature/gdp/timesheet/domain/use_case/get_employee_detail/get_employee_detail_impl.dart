import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_employee_detail_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/repository/timesheet_repository.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_employee_detail/get_employee_detail.dart';

class GetEmployeeDetailImpl extends GetEmployeeDetail {
  final TimesheetRepository repository;

  GetEmployeeDetailImpl({required this.repository});

  @override
  Future<Try<TimesheetEmployeeDetailEntity>> call(
      GetEmployeeDetailParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.getEmployeeDetail(params.numCra, params.date);
  }

  Failure? _validate(GetEmployeeDetailParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.numCra.isEmpty) return InvalidParamFailure();
    return null;
  }
}
