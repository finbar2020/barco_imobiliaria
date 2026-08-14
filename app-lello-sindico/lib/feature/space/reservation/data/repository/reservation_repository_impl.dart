import 'package:essentials/essentials.dart';
import 'package:essentials/network/api_failure.dart';
import 'package:lello/feature/space/reservation/data/data_source/remote/reservation/reservation_api.dart';
import 'package:lello/feature/space/reservation/data/data_source/remote/reservation/reservation_remote_data_source.dart';
import 'package:lello/feature/space/reservation/data/model/reservation_raffle_data_model.dart';
import 'package:lello/feature/space/reservation/data/model/reservation_registration_model.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_raffle_data.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_raffle_detail.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_raffle_result.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_response.dart';
import 'package:lello/feature/space/reservation/domain/entity/space_available_hours.dart';
import 'package:lello/feature/space/reservation/domain/repository/reservation_repository.dart';
import 'package:lello/feature/space/reservation/domain/use_case/list_reservation/list_reservation_failure.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';

class ReservationRepositoryImpl extends ReservationRepository {
  final ReservationRemoteDataSource remoteDataSource;

  ReservationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Try<List<SpaceAvailableHours>>> list(String condominiumId,
      {required String spaceId, String? unitId, required DateTime date}) async {
    try {
      final result = await remoteDataSource.list(
        condominiumId,
        unitId: unitId,
        spaceId: spaceId,
        date: date,
      );
      return Success(result.map((e) => e.toEntity()).toList());
    } catch (ex) {
      return Rejection(_mapApiFailure(ex as ApiFailure));
    }
  }

  @override
  Future<Try<List<ReservationResponse>>> listAllReservations(
      String condominiumId,
      {DateTime? startDate,
      DateTime? endDate}) async {
    try {
      final result = await remoteDataSource.listAllReservations(condominiumId,
          startDate: startDate, endDate: endDate);
      return Success(result.map((e) => e.toEntity()).toList());
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  @override
  Future<Try<Unit>> delete(String condominiumId, String reservationId,
      String? reservationType) async {
    try {
      await remoteDataSource.delete(
          condominiumId, reservationId, reservationType);
      return Success(Unit());
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  @override
  Future<Try<Reservation>> insertMaintenance(
      String condominiumId, ReservationRegistration registration) async {
    try {
      final result = await remoteDataSource.insertMaintenance(condominiumId,
          ReservationRegistrationModel.fromEntity(registration)!);
      return Success(result.toEntity());
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  @override
  Future<Try<String>> insertReservation(
    String condominiumId,
    ReservationRegistration registration,
    String unitId,
  ) async {
    try {
      final result = await remoteDataSource.insertReservation(condominiumId,
          ReservationRegistrationModel.fromEntity(registration)!);
      return Success(result);
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  @override
  Future<Try<Reservation>> insertRaffle(String condominiumId,
      ReservationRegistration registration, ReservationRaffleData data) async {
    try {
      final result = await remoteDataSource.insertRaffle(
          condominiumId,
          ReservationRegistrationModel.fromEntity(registration)!,
          ReservationRaffleDataModel.fromEntity(registration, data)!);
      return Success(result.toEntity());
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  @override
  Future<Try<ReservationRaffleDetail>> selectRaffleDetail(
      String condominiumId, String spaceId, String reservationId) async {
    try {
      final result = await remoteDataSource.selectRaffleDetail(
          condominiumId, spaceId, reservationId);
      return Success(result.toEntity());
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  @override
  Future<Try<ReservationRaffleResult>> insertRaffleExecution(
      String condominiumId, String spaceId, String reservationId) async {
    try {
      final result = await remoteDataSource.insertRaffleExecution(
          condominiumId, spaceId, reservationId);
      return Success(result.toEntity());
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  Failure _mapApiFailure(ApiFailure err) {
    if (err.title == ReservationApi.unit_exceeded_reservation_limit)
      return UnitExceededReservationLimit();

    return UnknownFailure(err);
  }

  @override
  Future<Try<String>> cancelReservation(String condominiumId,
      String reservationId, String? reservationType) async {
    try {
      final result = await remoteDataSource.cancelReservation(
          condominiumId, reservationId, reservationType);
      return Success(result);
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }
}
