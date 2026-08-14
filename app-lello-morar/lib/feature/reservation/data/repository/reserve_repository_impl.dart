import 'package:essentials/essentials.dart';
import 'package:essentials/network/api_failure.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:morar/feature/reservation/data/data_source/reservation_data_source.dart';
import 'package:morar/feature/reservation/data/model/reservation_registration_model.dart';
import 'package:morar/feature/reservation/domain/entity/reservation_registration.dart';
import 'package:morar/feature/reservation/domain/entity/reservation_scheduled.dart';
import 'package:morar/feature/reservation/domain/entity/space.dart';
import 'package:morar/feature/reservation/domain/entity/space_available_hours.dart';
import 'package:morar/feature/reservation/domain/entity/space_calendar_response.dart';
import 'package:morar/feature/reservation/domain/repository/reserve_repository.dart';

class ReservationRepositoryImpl extends ReservationRepository {
  final ReservationRemoteDataSource dataSource;

  ReservationRepositoryImpl({required this.dataSource});

  @override
  Future<Try<List<Space>>> getSpaces(String condominiumId) async {
    try {
      final data = await dataSource.getSpaces(condominiumId);
      final entity = data.map((model) => model.toEntity()).toList();
      return Success(entity);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'contentId: $condominiumId',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<SpaceCalendarResponse>> getCalendar(String condominiumId,
      String spaceId, DateTime startDate, DateTime endDate) async {
    try {
      final data = await dataSource.getCalendar(
          condominiumId, spaceId, startDate, endDate);
      final entity = data.toEntity();
      return Success(entity);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason:
            'contentId: $condominiumId - spaceId: $spaceId - startDate: ${startDate.toIso8601String()} - endDate: ${endDate.toIso8601String()}',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<List<ReservationScheduled>>> getAllReservationScheduled(
      String condominiumId, String unitId) async {
    try {
      final data =
          await dataSource.getAllReservationsScheduled(condominiumId, unitId);

      final entity = data.map((model) => model.toEntity()).toList();
      return Success(entity);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'contentId: $condominiumId - unitId: $unitId',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<List<SpaceAvailableHours>>> getHours(
    String condominiumId,
    String spaceId,
    DateTime date,
    String unitId,
  ) async {
    try {
      final data =
          await dataSource.getHours(condominiumId, spaceId, date, unitId);
      final entity = data.map((model) => model.toEntity()).toList();
      return Success(entity);
    } catch (e, stacktrace) {
      if (e is ApiFailure) {
        switch (e.status) {
          case 406:
            return Rejection(KnownFailure(
                e.detail ?? e.failure?.toString() ?? "not_acceptable", e));
          default:
            FirebaseCrashlytics.instance.recordError(
              e,
              stacktrace,
              reason: 'condominiumId: $condominiumId - spaceId: $spaceId',
            );
            return Rejection(UnknownFailure(e));
        }
      } else {
        FirebaseCrashlytics.instance.recordError(
          e,
          stacktrace,
          reason:
              'contentId: $condominiumId - spaceId: $spaceId - date: ${date.toIso8601String()} - unitId: $unitId',
        );
        return Rejection(UnknownFailure(e));
      }
    }
  }

  @override
  Future<Try<ReservationScheduled>> postReservation(String condominiumId,
      String spaceId, ReservationRegistration body) async {
    try {
      ReservationRegistrationModel reserve =
          ReservationRegistrationModel.fromEntity(body)!;
      final result = await dataSource.postReservation(
        condominiumId,
        spaceId,
        reserve,
      );
      return Success(result.toEntity());
    } catch (e, stacktrace) {
      if (e is ApiFailure) {
        switch (e.status) {
          case 406:
            return Rejection(KnownFailure(
                e.detail ?? e.failure?.toString() ?? "not_acceptable", e));
          default:
            FirebaseCrashlytics.instance.recordError(
              e,
              stacktrace,
              reason: 'condominiumId: $condominiumId - spaceId: $spaceId',
            );
            return Rejection(UnknownFailure(e));
        }
      } else {
        FirebaseCrashlytics.instance.recordError(
          e,
          stacktrace,
          reason: 'condominiumId: $condominiumId - spaceId: $spaceId',
        );
        return Rejection(UnknownFailure(e));
      }
    }
  }

  @override
  Future<Try<String>> deleteReservation(String condominiumId,
      String reservationId, String reservationType) async {
    try {
      final result = await dataSource.deleteReservation(
          condominiumId, reservationId, reservationType);
      return Success(result);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason:
            'condominiumId: $condominiumId - reservationId: $reservationId - reservationType: $reservationType',
      );
      return Rejection(UnknownFailure(e));
    }
  }
}
