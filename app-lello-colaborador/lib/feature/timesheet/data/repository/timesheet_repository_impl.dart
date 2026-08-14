import 'package:colaborador/feature/timesheet/data/data_source/remote/timesheet_remote_data_source.dart';
import 'package:colaborador/feature/timesheet/data/model/timesheet_element_detail_model.dart';
import 'package:colaborador/feature/timesheet/data/model/timesheet_model.dart';
import 'package:colaborador/feature/timesheet/data/model/timesheet_periods_model.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_element_detail.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_periods.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_sign_type_enum.dart';
import 'package:colaborador/feature/timesheet/domain/repository/timesheet_repository.dart';
import 'package:essentials/essentials.dart';

class TimesheetRepositoryImpl extends TimesheetRepository {
  final TimesheetRemoteDataSource remoteDataSource;

  TimesheetRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Try<Timesheet>> getTimesheet(
      String condominiumId, DateTime period) async {
    try {
      TimesheetModel response =
          await remoteDataSource.getTimesheet(condominiumId, period);

      return Success(response.toEntity());
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<List<TimesheetElementDetail>>> getTimesheetDetail(
      String condominiumId, DateTime period) async {
    try {
      List<TimesheetElementDetailModel> response =
          await remoteDataSource.getTimesheetDetail(condominiumId, period);
      List<TimesheetElementDetail> entity = response
          .map((e) => e.toEntity())
          .cast<TimesheetElementDetail>()
          .toList();

      return Success(entity);
    } catch (e) {
      return Rejection(UnknownFailure(e));
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

  @override
  Future<Try<bool>> sendEmail(
      String condominiumId, String email, DateTime period) async {
    try {
      bool response =
          await remoteDataSource.sendEmail(condominiumId, email, period);

      return Success(response);
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<bool>> signTimesheet(String condominiumId,
      TimesheetSignTypeEnum timesheetSignTypeEnum, DateTime period) async {
    try {
      bool response = await remoteDataSource.signTimesheet(condominiumId,
          enumToString(timesheetSignTypeEnum) ?? "espelho", period);

      return Success(response);
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }
}
