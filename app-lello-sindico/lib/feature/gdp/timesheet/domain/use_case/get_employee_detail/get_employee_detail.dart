import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_employee_detail_entity.dart';

abstract class GetEmployeeDetail
    extends UseCase<TimesheetEmployeeDetailEntity, GetEmployeeDetailParam> {}

class GetEmployeeDetailParam {
  final DateTime date;
  final String numCra;

  GetEmployeeDetailParam({required this.date, required this.numCra});
}
