import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_response.dart';

abstract class ListAllReservation
    extends UseCase<List<ReservationResponse>, ListAllReservationParam> {}

class ListAllReservationParam {
  final String condominiumId;
  final DateTime? startDate;
  final DateTime? endDate;

  ListAllReservationParam(
      {required this.condominiumId, this.startDate, this.endDate});
}
