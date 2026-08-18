import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation.dart';

abstract class ReservationCancellationState {
  final Reservation? data;
  final String? condominiumId;

  ReservationCancellationState(this.data, this.condominiumId);
}

class ReservationCancellationIdleState extends ReservationCancellationState {
  ReservationCancellationIdleState() : super(null, null);
}

class ReservationCancellationLoadingState extends ReservationCancellationState {
  ReservationCancellationLoadingState(Reservation data, String condominiumId)
      : super(data, condominiumId);
}

class ReservationCancellationCancelFailedState
    extends ReservationCancellationState {
  final Failure error;
  ReservationCancellationCancelFailedState(
      Reservation data, String condominiumId, this.error)
      : super(data, condominiumId);
}

class ReservationCancellationCancelledState
    extends ReservationCancellationState {
  ReservationCancellationCancelledState(Reservation data, String condominiumId)
      : super(data, condominiumId);
}
