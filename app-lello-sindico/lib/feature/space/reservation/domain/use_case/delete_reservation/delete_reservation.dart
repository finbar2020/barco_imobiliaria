import 'package:essentials/essentials.dart';

abstract class DeleteReservation
    extends UseCase<String, DeleteReservationParam> {}

class DeleteReservationParam {
  final String condominiumId;
  final String reservationId;
  final String reservationType;

  DeleteReservationParam(
      {required this.condominiumId,
      required this.reservationId,
      required this.reservationType});
}
