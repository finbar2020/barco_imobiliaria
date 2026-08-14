import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/data/model/timesheet_signature_request_model.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_add_manual_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_day_appointments_check_in_data_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_day_appointments_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_employee.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_employee_detail_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_month_resume_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_occurrence_certificate_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_occurrence_request_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_occurrence_vacation_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_ocurrence_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_periods.dart';

abstract class TimesheetRepository {
  Future<Try<TimesheetMonthResumeEntity>> getMonthResume(String date);
  Future<Try<List<DayAppointmentsEntity>>> getDayAppointments(String date);
  Future<Try<List<TimesheetOccurrenceEntity>>> getOccurrenceDetail(
      String date, String type);
  Future<Try<String>> postControlOccurrence(
      List<TimesheetOccurrenceRequestEntity> actions);
  Future<Try<List<TimesheetOccurrenceVacationEntity>>> getOccurrenceVacation(
      String date);
  Future<Try<File>> getVacationReceipt(String archiveName);
  Future<Try<List<TimesheetOccurrenceCertificateEntity>>>
      getOccurrenceCertificate(String date);
  Future<Try<List<TimesheetOccurrenceEntity>>> getGrouppedOccurrence(
      String date, String type);
  Future<Try<String>> postAddManualAppointments(
      List<TimesheetAddManualEntity> models);
  Future<Try<List<String>>> getManualAppointments(String numCra, DateTime date);
  Future<Try<List<TimesheetEmployee>>> getListEmployees(String id);
  Future<Try<TimesheetEmployeeDetailEntity>> getEmployeeDetail(
      String numCra, DateTime date);
  Future<Try<String>> putSignatureOrNotify(
      TimesheetSignatureRequestModel model);
  Future<Try<List<TimesheetDayAppointmentsCheckInData>>> getCheckInData(
      String numCra, DateTime date);
  Future<Try<List<TimesheetEntity>>> getPointMirrorList(DateTime date);
  Future<Try<List<TimesheetPeriods>>> getTimesheetPeriods(String condominiumId);
}
