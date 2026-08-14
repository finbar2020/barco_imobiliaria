import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/domain/repository/reservation_repository.dart';
import 'package:lello/feature/space/reservation/domain/use_case/cancel_reservation/cancel_reservation.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';

class CancelReservationImpl extends CancelReservation {
  final ReservationRepository repository;

  CancelReservationImpl({required this.repository});
  @override
  Future<Try<Unit>> call(CancelReservationParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.delete(
        params.condominiumId, params.reservationId, params.reservationType);
  }

  Failure? _validate(CancelReservationParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    if (param.reservationId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
