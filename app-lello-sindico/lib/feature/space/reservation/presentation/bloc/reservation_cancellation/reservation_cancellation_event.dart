import 'package:lello/feature/space/reservation/domain/entity/reservation.dart';

abstract class ReservationCancellationEvent {}

class ReservationCancellationCancelEvent extends ReservationCancellationEvent {
  final String condominiumId;
  final Reservation reservation;

  ReservationCancellationCancelEvent(
      {required this.condominiumId, required this.reservation});
}
