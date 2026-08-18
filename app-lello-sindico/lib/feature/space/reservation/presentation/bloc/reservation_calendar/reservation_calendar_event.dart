import 'package:lello/feature/space/domain/entity/space.dart';
import 'package:lello/feature/space/reservation/domain/entity/space_available_hours.dart';

abstract class ReservationCalendarEvent {}

class ReservationCalendarLoadEvent extends ReservationCalendarEvent {
  final String? condominiumId;
  final String? spaceId;
  final DateTime? periodStart;
  final DateTime? periodEnd;

  ReservationCalendarLoadEvent(
      {this.condominiumId, this.spaceId, this.periodStart, this.periodEnd});
}

class ReservationCalendarHistoryEvent extends ReservationCalendarEvent {
  final String? condominiumId;

  final DateTime? periodStart;
  final DateTime? periodEnd;

  ReservationCalendarHistoryEvent(
      {this.condominiumId, this.periodStart, this.periodEnd});
}

class ReservationCalendarLoadHoursEvent extends ReservationCalendarEvent {
  final String? condominiumId;
  final String? spaceId;
  final String? unitId;
  final SpaceAvailableHours? hoursResponse;
  final DateTime? date;

  ReservationCalendarLoadHoursEvent(
      {this.condominiumId,
      this.spaceId,
      this.unitId,
      this.hoursResponse,
      this.date});
}

class CreateReservationEvent extends ReservationCalendarEvent {
  final String? condominiumId;
  final String? spaceId;
  final String? unitId;
  final Space? space;

  final DateTime? reservationStartDate;
  final DateTime? reservationEndDate;

  CreateReservationEvent({
    this.condominiumId,
    this.spaceId,
    this.space,
    this.unitId,
    this.reservationStartDate,
    this.reservationEndDate,
  });
}

class DeleteEvent extends ReservationCalendarEvent {
  final String? reservationId;
  final String? reservationType;

  DeleteEvent({this.reservationId, this.reservationType});
}
