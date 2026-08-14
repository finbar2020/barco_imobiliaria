import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_time.dart';

abstract class ListReservationTime
    extends UseCase<List<ReservationTime>, ListReservationTimeParam> {}

class ListReservationTimeParam {
  final String condominiumId;
  final String spaceId;
  final DateTime date;

  ListReservationTimeParam(
      {required this.condominiumId, required this.spaceId, required this.date});
}
