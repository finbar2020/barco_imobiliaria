import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_raffle_detail.dart';

abstract class GetRaffle
    extends UseCase<ReservationRaffleDetail, GetRaffleParam> {}

class GetRaffleParam {
  final String condominiumId;
  final String reservationId;
  final String spaceId;

  GetRaffleParam({required this.condominiumId, required this.spaceId, required this.reservationId});
}
