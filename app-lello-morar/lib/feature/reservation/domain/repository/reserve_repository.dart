import 'package:morar/feature/reservation/domain/entity/reservation_registration.dart';
import 'package:morar/feature/reservation/domain/entity/reservation_scheduled.dart';
import 'package:morar/feature/reservation/domain/entity/space.dart';
import 'package:morar/feature/reservation/domain/entity/space_available_hours.dart';
import 'package:morar/feature/reservation/domain/entity/space_calendar_response.dart';
import 'package:essentials/essentials.dart';

abstract class ReservationRepository {
  Future<Try<List<Space>>> getSpaces(String condominiumId);
  Future<Try<List<ReservationScheduled>>> getAllReservationScheduled(
    String condominiumId,
    String unitId,
  );

  Future<Try<SpaceCalendarResponse>> getCalendar(
    String condominiumId,
    String spaceId,
    DateTime startDate,
    DateTime endDate,
  );

  Future<Try<List<SpaceAvailableHours>>> getHours(
    String condominiumId,
    String spaceId,
    DateTime date,
    String unitId,
  );

  Future<Try<ReservationScheduled>> postReservation(
    String condominiumId,
    String spaceId,
    ReservationRegistration body,
  );

  Future<Try<String>> deleteReservation(
    String condominiumId,
    String reservationId,
    String reservationType,
  );
}
