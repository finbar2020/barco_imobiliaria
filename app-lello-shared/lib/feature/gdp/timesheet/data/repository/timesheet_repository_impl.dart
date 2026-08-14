import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/domain/entity/employee.dart';
import 'package:shared_features/feature/gdp/timesheet/data/data_source/timesheet_remote_data_source.dart';
import 'package:shared_features/feature/gdp/timesheet/data/model/timesheet_event_model.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_event.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_filter.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_report_day.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_signature.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/repository/timesheet_repository.dart';

class TimesheetGDPRepositoryImpl extends TimesheetGDPRepository {
  final TimesheetGDPRemoteDataSource remoteDataSource;

  TimesheetGDPRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Try<List<Timesheet>>> list(
      String condominiumId, TimesheetFilter filter) async {
    try {
      final result = await remoteDataSource.list(condominiumId, filter);
      return Success(result.map((e) => e.toEntity()).toList());
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  @override
  Future<Try<List<Employee>>> listEmployees(String condominiumId) async {
    try {
      final result = await remoteDataSource.listEmployees(condominiumId);
      return Success(result.map((e) => e.toEntity()).toList());
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  @override
  Future<Try<TimesheetReportDay>> getReportDay(
      String condominiumId, TimesheetFilter filter) async {
    try {
      final result = await remoteDataSource.getReportDay(condominiumId, filter);
      return Success(result.toEntity());
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  @override
  Future<Try<List<TimesheetSignature>>> listSignature(
      String condominiumId, TimesheetFilter filter) async {
    try {
      final result =
          await remoteDataSource.listSignature(condominiumId, filter);
      return Success(result.map((e) => e.toEntity()).toList());
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  @override
  Future<Try<List<TimesheetSignature>>> sign(
      String condominiumId, List<TimesheetSignature> signatures) async {
    try {
      final result = await remoteDataSource.sign(condominiumId, signatures);
      return Success(result.map((e) => e.toEntity()).toList());
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  @override
  Future<Try<TimesheetEvent>> insertTimesheetEvent(
      String condominiumId, TimesheetEvent events) async {
    try {
      final model = TimesheetEventModel.fromEntity(events)!;
      final result =
          await remoteDataSource.insertTimesheetEvent(condominiumId, model);
      return Success(result.toEntity());
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  @override
  Future<Try<String>> requestTimesheet(String condominiumId) async {
    try {
      await remoteDataSource.requestTimesheet(condominiumId);
      return Success("Success");
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }
}
