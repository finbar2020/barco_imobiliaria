import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/data/data_source/timesheet_remote_data_source.dart';
import 'package:lello/feature/gdp/timesheet/data/model/timesheet_add_manual_model.dart';
import 'package:lello/feature/gdp/timesheet/data/model/timesheet_occurrence_request_model.dart';
import 'package:lello/feature/gdp/timesheet/data/model/timesheet_periods_model.dart';
import 'package:lello/feature/gdp/timesheet/data/model/timesheet_signature_request_model.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_add_manual_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_day_appointments_check_in_data_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_day_appointments_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_employee.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_employee_detail_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_periods.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_month_resume_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_occurrence_certificate_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_occurrence_request_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_occurrence_vacation_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_ocurrence_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/repository/timesheet_repository.dart';

class TimesheetRepositoryImpl extends TimesheetRepository {
  final TimesheetRemoteDataSource remoteDataSource;

  TimesheetRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Try<TimesheetMonthResumeEntity>> getMonthResume(String date) async {
    try {
      final result = await remoteDataSource.getMonthResume(date);
      return Success(result.toEntity());
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  @override
  Future<Try<List<DayAppointmentsEntity>>> getDayAppointments(
      String date) async {
    try {
      final result = await remoteDataSource.getDayAppointments(date);
      List<DayAppointmentsEntity> list =
          List.generate(result.length, (index) => result[index].toEntity());
      return Success(list);
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  @override
  Future<Try<List<TimesheetOccurrenceEntity>>> getOccurrenceDetail(
      String date, String type) async {
    try {
      final result = await remoteDataSource.getOccurrenceDetail(date, type);
      List<TimesheetOccurrenceEntity> list =
          List.generate(result.length, (index) => result[index].toEntity());
      return Success(list);
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  @override
  Future<Try<String>> postControlOccurrence(
      List<TimesheetOccurrenceRequestEntity> actions) async {
    try {
      List<TimesheetOccurrenceRequestModel> models = List.generate(
          actions.length,
          (index) =>
              TimesheetOccurrenceRequestModel.fromEntity(actions[index])!);
      final result = await remoteDataSource.postControlOccurrence(models);
      return Success(result);
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  @override
  Future<Try<List<TimesheetOccurrenceVacationEntity>>> getOccurrenceVacation(
      String date) async {
    try {
      final result = await remoteDataSource.getOccurrenceVacations(date);
      List<TimesheetOccurrenceVacationEntity> list =
          List.generate(result.length, (index) => result[index].toEntity());
      return Success(list);
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  @override
  Future<Try<File>> getVacationReceipt(String archiveName) async {
    try {
      final result = await remoteDataSource.getVacationReceipt(archiveName);
      return Success(result);
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  @override
  Future<Try<List<TimesheetOccurrenceCertificateEntity>>>
      getOccurrenceCertificate(String date) async {
    try {
      final result = await remoteDataSource.getOccurrenceCertificate(date);
      List<TimesheetOccurrenceCertificateEntity> list =
          List.generate(result.length, (index) => result[index].toEntity());
      return Success(list);
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  @override
  Future<Try<List<TimesheetOccurrenceEntity>>> getGrouppedOccurrence(
      String date, String type) async {
    try {
      final result = await remoteDataSource.getGrouppedOccurrence(date, type);
      List<TimesheetOccurrenceEntity> list =
          List.generate(result.length, (index) => result[index].toEntity());
      return Success(list);
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  @override
  Future<Try<String>> postAddManualAppointments(
      List<TimesheetAddManualEntity> models) async {
    try {
      List<TimesheetAddManualModel> list = List.generate(models.length,
          (index) => TimesheetAddManualModel.fromEntity(models[index])!);
      final result = await remoteDataSource.postAddManualAppointments(list);
      return Success(result);
    } on ApiFailure catch (error) {
      switch (error.status) {
        case 406:
          return Rejection(KnownFailure(
            error.title ?? "",
            error,
            message: error.detail,
          ));
        default:
          return Rejection(UnknownFailure(error));
      }
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  @override
  Future<Try<List<String>>> getManualAppointments(
      String numCra, DateTime date) async {
    try {
      final result = await remoteDataSource.getManualAppointments(numCra, date);
      return Success(result.times ?? []);
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  @override
  Future<Try<List<TimesheetEmployee>>> getListEmployees(String id) async {
    try {
      final result = await remoteDataSource.getListEmployees(id);
      List<TimesheetEmployee> list =
          List.generate(result.length, (index) => result[index].toEntity());
      return Success(list);
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  @override
  Future<Try<TimesheetEmployeeDetailEntity>> getEmployeeDetail(
      String numCra, DateTime date) async {
    try {
      final result = await remoteDataSource.getEmployeeDetail(numCra, date);
      return Success(result.toEntity());
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  @override
  Future<Try<String>> putSignatureOrNotify(
      TimesheetSignatureRequestModel model) async {
    try {
      final result = await remoteDataSource.putSignatureOrNotify(model);
      return Success(result);
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  @override
  Future<Try<List<TimesheetEntity>>> getPointMirrorList(DateTime date) async {
    try {
      final result = await remoteDataSource.getPointMirrorList(date);
      List<TimesheetEntity> list =
          List.generate(result.length, (index) => result[index].toEntity());
      return Success(list);
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  @override
  Future<Try<List<TimesheetDayAppointmentsCheckInData>>> getCheckInData(
      String numCra, DateTime date) async {
    try {
      final result = await remoteDataSource.getCheckInData(numCra, date);
      return Success(result.map((e) => e.toEntity()).toList());
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  @override
  Future<Try<List<TimesheetPeriods>>> getTimesheetPeriods(
      String condominiumId) async {
    try {
      List<TimesheetPeriodsModel> response =
          await remoteDataSource.getTimesheetPeriods(condominiumId);
      List<TimesheetPeriods> entity =
          response.map((e) => e.toEntity()).cast<TimesheetPeriods>().toList();

      return Success(entity);
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }
}
