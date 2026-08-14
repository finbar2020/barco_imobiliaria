import 'package:colaborador/feature/timesheet/domain/entity/timesheet.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_element_detail.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_periods.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_sign_type_enum.dart';
import 'package:essentials/essentials.dart';

abstract class TimesheetRepository {
  Future<Try<Timesheet>> getTimesheet(String condominiumId, DateTime period);
  Future<Try<List<TimesheetElementDetail>>> getTimesheetDetail(
      String condominiumId, DateTime period);
  Future<Try<List<TimesheetPeriods>>> getTimesheetPeriods(String condominiumId);
  Future<Try<bool>> sendEmail(
      String condominiumId, String email, DateTime period);
  Future<Try<bool>> signTimesheet(String condominiumId,
      TimesheetSignTypeEnum timesheetSignTypeEnum, DateTime period);
}
