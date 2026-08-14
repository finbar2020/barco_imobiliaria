import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/data/data_source/timesheet_api.dart';
import 'package:lello/feature/gdp/timesheet/data/data_source/timesheet_remote_data_source.dart';
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

class TimesheetRemoteDataSourceImpl implements TimesheetRemoteDataSource {
  TimesheetApi api;

  TimesheetRemoteDataSourceImpl({required this.api});

  @override
  Future<TimesheetMonthResumeModel> getMonthResume(String date) async {
    final response = await api.getMonthResume(date);
    return ApiMapper.map(
        response, (json) => TimesheetMonthResumeModel.fromJson(json));
  }

  @override
  Future<List<DayAppointmentsModel>> getDayAppointments(String date) async {
    final response = await api.getDayAppointments(date);
    return ApiMapper.mapList(
        response, (json) => DayAppointmentsModel.fromJson(json));
  }

  @override
  Future<List<TimesheetOccurrenceModel>> getOccurrenceDetail(
      String date, String type) async {
    final response = await api.getOccurrenceDetail(date, type);
    return ApiMapper.mapList(
        response, (json) => TimesheetOccurrenceModel.fromJson(json));
  }

  @override
  Future<String> postControlOccurrence(
      List<TimesheetOccurrenceRequestModel> actions) async {
    final response = await api.postAction(actions);
    if (response.isSuccessful == false) {
      throw response.error ?? "";
    } else {
      return "";
    }
  }

  @override
  Future<List<TimesheetOccurrenceVacationModel>> getOccurrenceVacations(
      String date) async {
    final response = await api.getOccurrenceVacation(date);
    return ApiMapper.mapList(
        response, (json) => TimesheetOccurrenceVacationModel.fromJson(json));
  }

  @override
  Future<File> getVacationReceipt(String archiveName) async {
    final response = await api.getVacationReceipt(archiveName);
    if (response.isSuccessful == false) {
      throw response.error ?? "";
    } else {
      return File("");
    }
  }

  @override
  Future<List<TimesheetOccurrenceCertificateModel>> getOccurrenceCertificate(
      String date) async {
    final response = await api.getOccurrenceCertificate(date);
    return ApiMapper.mapList(
        response, (json) => TimesheetOccurrenceCertificateModel.fromJson(json));
  }

  @override
  Future<List<TimesheetOccurrenceModel>> getGrouppedOccurrence(
      String date, String type) async {
    final response = await api.getGroupedOccurrence(date, type);
    return ApiMapper.mapList(
        response, (json) => TimesheetOccurrenceModel.fromJson(json));
  }

  @override
  Future<String> postAddManualAppointments(
      List<TimesheetAddManualModel> models) async {
    final response = await api.postAddManualAppointment(models);
    if (response.isSuccessful == false) {
      throw response.error ?? "";
    } else {
      return '';
    }
  }

  @override
  Future<TimesheetOccurrenceManualAppontmentListModel> getManualAppointments(
      String numCra, DateTime date) async {
    final response = await api.getManualAppointments(numCra, date);
    return ApiMapper.map(response,
        (json) => TimesheetOccurrenceManualAppontmentListModel.fromJson(json));
  }

  @override
  Future<List<TimesheetEmployeeModel>> getListEmployees(String id) async {
    final response = await api.getListEmployees(id);
    return ApiMapper.mapList(
        response, (json) => TimesheetEmployeeModel.fromJson(json));
  }

  @override
  Future<TimesheetEmployeeDetailModel> getEmployeeDetail(
      String numCra, DateTime date) async {
    final response = await api.getTimesheetEmployeeDetail(numCra, date);
    return ApiMapper.map(
        response, (json) => TimesheetEmployeeDetailModel.fromJson(json));
  }

  @override
  Future<String> putSignatureOrNotify(
      TimesheetSignatureRequestModel model) async {
    final response = await api.putSignatureOrNotify(model);
    if (response.isSuccessful == false) {
      throw response.error ?? "";
    } else {
      return "";
    }
  }

  @override
  Future<List<TimesheetModel>> getPointMirrorList(DateTime date) async {
    final response = await api.getPointMirrorList(date);
    return ApiMapper.mapList(response, (json) => TimesheetModel.fromJson(json));
  }

  @override
  Future<List<TimesheetDayAppointmentsCheckInDataModel>> getCheckInData(
      String numCra, DateTime date) async {
    final response = await api.getCheckInData(numCra, date);
    return ApiMapper.mapList(response,
        (json) => TimesheetDayAppointmentsCheckInDataModel.fromJson(json));
  }
  
  @override
  Future<List<TimesheetPeriodsModel>> getTimesheetPeriods(
      String condominiumId) async {
    Response response = await api.getTimesheetPeriods(condominiumId);
    return ApiMapper.mapList(
        response, (json) => TimesheetPeriodsModel.fromJson(json));
  }
}
