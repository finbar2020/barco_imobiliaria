import 'package:shared_features/feature/gdp/data/model/employee_model.dart';
import 'package:shared_features/feature/gdp/timesheet/data/model/timesheet_event_model.dart';
import 'package:shared_features/feature/gdp/timesheet/data/model/timesheet_model.dart';
import 'package:shared_features/feature/gdp/timesheet/data/model/timesheet_report_day_model.dart';
import 'package:shared_features/feature/gdp/timesheet/data/model/timesheet_signature_model.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_filter.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_signature.dart';

abstract class TimesheetGDPRemoteDataSource {
  Future<List<TimesheetModel>> list(
      String condominiumId, TimesheetFilter filter);
  Future<List<EmployeeModel>> listEmployees(String condominiumId);
  Future<TimesheetReportDayModel> getReportDay(
      String condominiumId, TimesheetFilter filter);
  Future<List<TimesheetSignatureModel>> listSignature(
      String condominiumId, TimesheetFilter filter);
  Future<List<TimesheetSignatureModel>> sign(
      String condominiumId, List<TimesheetSignature> signatures);
  Future<TimesheetEventModel> insertTimesheetEvent(
      String condominiumId, TimesheetEventModel events);
  Future<void> requestTimesheet(String condominiumId);
}
