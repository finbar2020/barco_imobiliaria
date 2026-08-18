import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_raffle_detail.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_raffle_result.dart';

abstract class ReservationRaffleDrawState {
  final ReservationRaffleDetail? data;
  final String? condominiumId;
  final String? spaceId;
  final String? reservationId;

  ReservationRaffleDrawState(
      this.data, this.condominiumId, this.spaceId, this.reservationId);
}

class ReservationRaffleDrawLoadingState extends ReservationRaffleDrawState {
  ReservationRaffleDrawLoadingState(
    ReservationRaffleDetail? data,
    String? condominiumId,
    String? spaceId,
    String? reservationId,
  ) : super(data, condominiumId, spaceId, reservationId);
}

class ReservationRaffleDrawLoadFailedState extends ReservationRaffleDrawState {
  final Failure error;
  ReservationRaffleDrawLoadFailedState(ReservationRaffleDetail data,
      String condominiumId, String spaceId, String reservationId, this.error)
      : super(data, condominiumId, spaceId, reservationId);
}

class ReservationRaffleDrawLoadedState extends ReservationRaffleDrawState {
  ReservationRaffleDrawLoadedState(ReservationRaffleDetail data,
      String condominiumId, String spaceId, String reservationId)
      : super(data, condominiumId, spaceId, reservationId);
}

class ReservationRaffleDrawingState extends ReservationRaffleDrawState {
  ReservationRaffleDrawingState(ReservationRaffleDetail data,
      String condominiumId, String spaceId, String reservationId)
      : super(data, condominiumId, spaceId, reservationId);
}

class ReservationRaffleDrawSucceededState extends ReservationRaffleDrawState {
  final ReservationRaffleResult result;
  ReservationRaffleDrawSucceededState(this.result, ReservationRaffleDetail data,
      String condominiumId, String spaceId, String reservationId)
      : super(data, condominiumId, spaceId, reservationId);
}
