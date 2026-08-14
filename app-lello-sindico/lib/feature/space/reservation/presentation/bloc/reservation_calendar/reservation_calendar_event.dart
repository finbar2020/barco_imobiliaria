import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/domain/entity/space.dart';
import 'package:lello/feature/space/reservation/domain/entity/space_available_hours.dart';

abstract class ReservationCalendarEvent extends Equatable {
  const ReservationCalendarEvent();

  @override
  List<Object?> get props => [];
}

class ReservationCalendarLoadEvent extends ReservationCalendarEvent {
  final String? condominiumId;
  final String? spaceId;
  final DateTime? periodStart;
  final DateTime? periodEnd;

  const ReservationCalendarLoadEvent(
      {this.condominiumId, this.spaceId, this.periodStart, this.periodEnd});

  @override
  List<Object?> get props =>
      [condominiumId, spaceId, periodStart, periodEnd];
}

class ReservationCalendarHistoryEvent extends ReservationCalendarEvent {
  final String? condominiumId;
  final DateTime? periodStart;
  final DateTime? periodEnd;

  const ReservationCalendarHistoryEvent(
      {this.condominiumId, this.periodStart, this.periodEnd});

  @override
  List<Object?> get props => [condominiumId, periodStart, periodEnd];
}

class ReservationCalendarLoadHoursEvent extends ReservationCalendarEvent {
  final String? condominiumId;
  final String? spaceId;
  final String? unitId;
  final SpaceAvailableHours? hoursResponse;
  final DateTime? date;

  const ReservationCalendarLoadHoursEvent(
      {this.condominiumId,
      this.spaceId,
      this.unitId,
      this.hoursResponse,
      this.date});

  @override
  List<Object?> get props =>
      [condominiumId, spaceId, unitId, hoursResponse, date];
}

class CreateReservationEvent extends ReservationCalendarEvent {
  final String? condominiumId;
  final String? spaceId;
  final String? unitId;
  final Space? space;
  final DateTime? reservationStartDate;
  final DateTime? reservationEndDate;

  const CreateReservationEvent({
    this.condominiumId,
    this.spaceId,
    this.space,
    this.unitId,
    this.reservationStartDate,
    this.reservationEndDate,
  });

  @override
  List<Object?> get props => [
        condominiumId,
        spaceId,
        space,
        unitId,
        reservationStartDate,
        reservationEndDate,
      ];
}

class DeleteEvent extends ReservationCalendarEvent {
  final String? reservationId;
  final String? reservationType;

  const DeleteEvent({this.reservationId, this.reservationType});

  @override
  List<Object?> get props => [reservationId, reservationType];
}
