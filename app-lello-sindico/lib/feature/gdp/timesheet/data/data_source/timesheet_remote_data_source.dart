import 'dart:io';

import 'package:lello/feature/gdp/timesheet/data/model/timesheet_add_manual_model.dart';
import 'package:lello/feature/gdp/timesheet/data/model/timesheet_day_appointments_check_in_data_model.dart';
import 'package:lello/feature/gdp/timesheet/data/model/timesheet_day_appointments_model.dart';
import 'package:lello/feature/gdp/timesheet/data/model/timesheet_employee_detail_model.dart';
import 'package:lello/feature/gdp/timesheet/data/model/timesheet_employee_model.dart';
import 'package:lello/feature/gdp/timesheet/data/model/timesheet_model.dart';
import 'package:lello/feature/gdp/timesheet/data/model/timesheet_periods_model.dart';
import 'package:lello/feature/gdp/timesheet/data/model/timesheet_month_resume_model.dart';
import 'package:lello/feature/gdp/timesheet/data/model/timesheet_occurrence_certificate_model.dart';
import 'package:lello/feature/gdp/timesheet/data/model/timesheet_occurrence_manual_appontment_list_model.dart';
import 'package:lello/feature/gdp/timesheet/data/model/timesheet_occurrence_model.dart';
import 'package:lello/feature/gdp/timesheet/data/model/timesheet_occurrence_request_model.dart';
import 'package:lello/feature/gdp/timesheet/data/model/timesheet_occurrence_vacation_model.dart';
import 'package:lello/feature/gdp/timesheet/data/model/timesheet_signature_request_model.dart';

abstract class TimesheetRemoteDataSource {
  Future<TimesheetMonthResumeModel> getMonthResume(String date);
  Future<List<DayAppointmentsModel>> getDayAppointments(String date);
  Future<List<TimesheetOccurrenceModel>> getOccurrenceDetail(
      String date, String type);
  Future<String> postControlOccurrence(
      List<TimesheetOccurrenceRequestModel> actions);
  Future<List<TimesheetOccurrenceVacationModel>> getOccurrenceVacations(
      String date);
  Future<File> getVacationReceipt(String archiveName);
  Future<List<TimesheetOccurrenceCertificateModel>> getOccurrenceCertificate(
      String date);
  Future<List<TimesheetOccurrenceModel>> getGrouppedOccurrence(
      String date, String type);
  Future<String> postAddManualAppointments(
      List<TimesheetAddManualModel> models);
  Future<TimesheetOccurrenceManualAppontmentListModel> getManualAppointments(
      String numCra, DateTime date);
  Future<List<TimesheetEmployeeModel>> getListEmployees(String id);
  Future<TimesheetEmployeeDetailModel> getEmployeeDetail(
      String numCra, DateTime date);
  Future<String> putSignatureOrNotify(TimesheetSignatureRequestModel model);
  Future<List<TimesheetModel>> getPointMirrorList(DateTime date);

  Future<List<TimesheetDayAppointmentsCheckInDataModel>> getCheckInData(
      String numCra, DateTime date);
  Future<List<TimesheetPeriodsModel>> getTimesheetPeriods(String condominiumId);
}
