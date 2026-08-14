import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation.dart';

abstract class ReservationCancellationEvent extends Equatable {
  const ReservationCancellationEvent();

  @override
  List<Object?> get props => [];
}

class ReservationCancellationCancelEvent extends ReservationCancellationEvent {
  final String condominiumId;
  final Reservation reservation;

  const ReservationCancellationCancelEvent(
      {required this.condominiumId, required this.reservation});

  @override
  List<Object?> get props => [condominiumId, reservation];
}
