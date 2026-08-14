import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation.dart';

abstract class ReservationCancellationState extends Equatable {
  final Reservation? data;
  final String? condominiumId;

  const ReservationCancellationState(this.data, this.condominiumId);

  @override
  List<Object?> get props => [data, condominiumId];
}

class ReservationCancellationInitialState extends ReservationCancellationState {
  const ReservationCancellationInitialState() : super(null, null);
}

class ReservationCancellationLoadingState extends ReservationCancellationState {
  const ReservationCancellationLoadingState(
      Reservation data, String condominiumId)
      : super(data, condominiumId);
}

class ReservationCancellationCancelFailedState
    extends ReservationCancellationState {
  final Failure error;

  const ReservationCancellationCancelFailedState(
      Reservation data, String condominiumId, this.error)
      : super(data, condominiumId);

  @override
  List<Object?> get props => [data, condominiumId, error];
}

class ReservationCancellationCancelledState
    extends ReservationCancellationState {
  const ReservationCancellationCancelledState(
      Reservation data, String condominiumId)
      : super(data, condominiumId);
}
