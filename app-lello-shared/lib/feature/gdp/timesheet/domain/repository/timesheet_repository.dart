import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/domain/entity/employee.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_event.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_filter.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_report_day.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_signature.dart';

abstract class TimesheetGDPRepository {
  Future<Try<List<Timesheet>>> list(
      String condominiumId, TimesheetFilter filter);
  Future<Try<List<Employee>>> listEmployees(String condominiumId);
  Future<Try<TimesheetReportDay>> getReportDay(
      String condominiumId, TimesheetFilter filter);
  Future<Try<List<TimesheetSignature>>> listSignature(
      String condominiumId, TimesheetFilter filter);
  Future<Try<List<TimesheetSignature>>> sign(
      String condominiumId, List<TimesheetSignature> signatures);
  Future<Try<TimesheetEvent>> insertTimesheetEvent(
      String condominiumId, TimesheetEvent events);
  Future<Try<String>> requestTimesheet(String condominiumId);
}
