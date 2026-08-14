import 'package:essentials/essentials.dart';
import 'package:morar/feature/reservation/domain/entity/reservation_scheduled.dart';

abstract class GetAllReservation
    extends UseCase<List<ReservationScheduled>, GetAllReservationParam> {}

class GetAllReservationParam {
  final String condominiumId;
  final String unitId;

  GetAllReservationParam({
    required this.condominiumId,
    required this.unitId,
  });
}
