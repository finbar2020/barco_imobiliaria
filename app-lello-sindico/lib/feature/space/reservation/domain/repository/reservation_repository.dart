import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_raffle_data.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_raffle_detail.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_raffle_result.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_response.dart';
import 'package:lello/feature/space/reservation/domain/entity/space_available_hours.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';

abstract class ReservationRepository {
  Future<Try<List<SpaceAvailableHours>>> list(String condominiumId,
      {required String spaceId, String? unitId, required DateTime date});

  Future<Try<List<ReservationResponse>>> listAllReservations(
      String condominiumId,
      {DateTime? startDate,
      DateTime? endDate});
  Future<Try<Reservation>> insertMaintenance(
      String condominiumId, ReservationRegistration registration);
  Future<Try<String>> insertReservation(String condominiumId,
      ReservationRegistration registration, String unitId);
  Future<Try<Reservation>> insertRaffle(String condominiumId,
      ReservationRegistration registration, ReservationRaffleData data);
  Future<Try<ReservationRaffleDetail>> selectRaffleDetail(
      String condominiumId, String spaceId, String reservationId);
  Future<Try<ReservationRaffleResult>> insertRaffleExecution(
      String condominiumId, String spaceId, String reservationId);
  Future<Try<Unit>> delete(
      String condominiumId, String reservationId, String? reservationType);
  Future<Try<String>> cancelReservation(
      String condominiumId, String reservationId, String? reservationType);
}
