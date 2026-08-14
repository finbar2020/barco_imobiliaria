import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_raffle_detail.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_raffle_result.dart';

abstract class ReservationRaffleDrawState extends Equatable {
  final ReservationRaffleDetail? data;
  final String? condominiumId;
  final String? spaceId;
  final String? reservationId;

  const ReservationRaffleDrawState(
      this.data, this.condominiumId, this.spaceId, this.reservationId);

  @override
  List<Object?> get props => [data, condominiumId, spaceId, reservationId];
}

class ReservationRaffleDrawLoadingState extends ReservationRaffleDrawState {
  const ReservationRaffleDrawLoadingState(
    ReservationRaffleDetail? data,
    String? condominiumId,
    String? spaceId,
    String? reservationId,
  ) : super(data, condominiumId, spaceId, reservationId);
}

class ReservationRaffleDrawLoadFailedState extends ReservationRaffleDrawState {
  final Failure error;

  const ReservationRaffleDrawLoadFailedState(
      ReservationRaffleDetail data,
      String condominiumId,
      String spaceId,
      String reservationId,
      this.error)
      : super(data, condominiumId, spaceId, reservationId);

  @override
  List<Object?> get props =>
      [data, condominiumId, spaceId, reservationId, error];
}

class ReservationRaffleDrawLoadedState extends ReservationRaffleDrawState {
  const ReservationRaffleDrawLoadedState(ReservationRaffleDetail data,
      String condominiumId, String spaceId, String reservationId)
      : super(data, condominiumId, spaceId, reservationId);
}

class ReservationRaffleDrawingState extends ReservationRaffleDrawState {
  const ReservationRaffleDrawingState(ReservationRaffleDetail data,
      String condominiumId, String spaceId, String reservationId)
      : super(data, condominiumId, spaceId, reservationId);
}

class ReservationRaffleDrawSucceededState extends ReservationRaffleDrawState {
  final ReservationRaffleResult result;

  const ReservationRaffleDrawSucceededState(
      this.result,
      ReservationRaffleDetail data,
      String condominiumId,
      String spaceId,
      String reservationId)
      : super(data, condominiumId, spaceId, reservationId);

  @override
  List<Object?> get props =>
      [data, condominiumId, spaceId, reservationId, result];
}
