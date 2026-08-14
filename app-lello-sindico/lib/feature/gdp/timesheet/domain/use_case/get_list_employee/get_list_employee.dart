import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_employee.dart';

abstract class GetListEmployees
    extends UseCase<List<TimesheetEmployee>, GetListEmployeesParam> {}

class GetListEmployeesParam {
  final String id;

  GetListEmployeesParam({required this.id});
}
