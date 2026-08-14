import 'package:morar/feature/reservation/data/model/reservation_registration_model.dart';
import 'package:morar/feature/reservation/data/model/reservation_scheduled_model.dart';
import 'package:morar/feature/reservation/data/model/space_available_hours_model.dart';
import 'package:morar/feature/reservation/data/model/space_calendar_model.dart';
import 'package:morar/feature/reservation/data/model/space_model.dart';

abstract class ReservationRemoteDataSource {
  Future<List<SpaceModel>> getSpaces(String condominiumId);

  Future<SpaceCalendarModel> getCalendar(
    String condominiumId,
    String spaceId,
    DateTime startDate,
    DateTime endDate,
  );

  Future<List<SpaceAvailableHoursModel>> getHours(
    String condominiumId,
    String spaceId,
    DateTime date,
    String unitId,
  );

  Future<List<ReservationScheduledModel>> getAllReservationsScheduled(
    String condominiumId,
    String unitId,
  );

  Future<ReservationScheduledModel> postReservation(
    String condominiumId,
    String spaceId,
    ReservationRegistrationModel body,
  );

  Future<String> deleteReservation(
    String condominiumId,
    String reservationId,
    String reservationType,
  );
}
