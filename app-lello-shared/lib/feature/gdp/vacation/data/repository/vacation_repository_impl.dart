import 'package:essentials/essentials.dart';
import 'package:essentials/network/api_failure.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:shared_features/feature/gdp/vacation/data/data_source/vacation_remote_data_source.dart';
import 'package:shared_features/feature/gdp/vacation/data/model/vacation_created_model.dart';
import 'package:shared_features/feature/gdp/vacation/data/model/vacation_request_model.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_created.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_locked_days.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_params.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_request.dart';
import 'package:shared_features/feature/gdp/vacation/domain/repository/vacation_repository.dart';

class VacationRepositoryImpl extends VacationRepository {
  final VacationRemoteDataSource remoteDataSource;

  VacationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Try<Vacation>> getVacation(
      String condominiumId, String employeeId) async {
    try {
      final result = await remoteDataSource.find(condominiumId, employeeId);
      return Success(result.toEntity());
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  @override
  Future<Try<VacationParams>> getVacationPeriod(
      String condominiumId, String employeeId) async {
    try {
      final result =
          await remoteDataSource.getVacationPeriod(condominiumId, employeeId);
      return Success(result.toEntity());
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  @override
  Future<Try<VacationLockedDays>> getLockedDays(String condominiumId,
      String employeeId, DateTime startDate, DateTime endDate) async {
    try {
      final result = await remoteDataSource.getLockedDays(
          condominiumId, employeeId, startDate, endDate);
      final entity = result.toEntity();
      return Success(entity);
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  @override
  Future<Try<Vacation>> scheduleVacation(VacationRequest request) async {
    try {
      final result = await remoteDataSource.requestVacation(
          request.condominiumId!,
          request.employeeId!,
          VacationRequestModel()
            ..period = request.period
            ..numberOfDays = request.numberOfDays);
      return Success(result.toEntity());
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  @override
  Future<Try<VacationCreated>> createVacation(
      {required String condominiumId,
      required String employeeId,
      required VacationCreated vacationCreated}) async {
    try {
      VacationCreatedModel? vacationCreatedModel =
          VacationCreatedModel.fromEntity(vacationCreated);
      final result = await remoteDataSource.createVacation(
          condominiumId, employeeId, vacationCreatedModel);
      return Success(result.toEntity());
    } catch (e, stacktrace) {
      if (e is ApiFailure) {
        switch (e.status) {
          case 406:
            return Rejection(KnownFailure(e.title?.toString() ?? "", e));
          default:
            FirebaseCrashlytics.instance.recordError(
              e,
              stacktrace,
              reason:
                  'condominiumId: $condominiumId - employeeId: $employeeId - model: $vacationCreated',
            );
            return Rejection(UnknownFailure(e));
        }
      } else {
        FirebaseCrashlytics.instance.recordError(
          e,
          stacktrace,
          reason: 'condominiumId: $condominiumId - employeeId: $employeeId',
        );
        return Rejection(UnknownFailure(e));
      }
    }
  }
}
