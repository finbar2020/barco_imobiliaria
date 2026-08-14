import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_raffle_result.dart';

abstract class DrawRaffle
    extends UseCase<ReservationRaffleResult, DrawRaffleParam> {}

class DrawRaffleParam {
  final String condominiumId;
  final String reservationId;
  final String spaceId;
  DrawRaffleParam(
      {required this.condominiumId,
      required this.reservationId,
      required this.spaceId});
}
