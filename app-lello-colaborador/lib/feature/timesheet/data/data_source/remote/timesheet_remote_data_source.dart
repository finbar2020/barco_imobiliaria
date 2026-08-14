import 'package:colaborador/feature/timesheet/data/model/timesheet_element_detail_model.dart';
import 'package:colaborador/feature/timesheet/data/model/timesheet_model.dart';
import 'package:colaborador/feature/timesheet/data/model/timesheet_periods_model.dart';

abstract class TimesheetRemoteDataSource {
  Future<TimesheetModel> getTimesheet(String condominiumId, DateTime period);
  Future<List<TimesheetElementDetailModel>> getTimesheetDetail(
      String condominiumId, DateTime period);
  Future<List<TimesheetPeriodsModel>> getTimesheetPeriods(
      String condominiumId);
  Future<bool> sendEmail(String condominiumId, String email, DateTime period);
  Future<bool> signTimesheet(
      String condominiumId, String timesheetSignType, DateTime period);
}
