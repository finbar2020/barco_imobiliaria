import 'package:essentials/essentials.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';

abstract class CancelReservation extends UseCase<Unit, CancelReservationParam> {
}

class CancelReservationParam {
  final String condominiumId;
  final String reservationId;
  final String? reservationType;

  CancelReservationParam(
      {required this.condominiumId,
      required this.reservationId,
      this.reservationType});
}
