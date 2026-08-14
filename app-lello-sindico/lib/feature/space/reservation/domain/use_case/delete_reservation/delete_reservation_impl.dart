import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/domain/repository/reservation_repository.dart';
import 'package:lello/feature/space/reservation/domain/use_case/delete_reservation/delete_reservation.dart';

class DeleteReservationImpl extends DeleteReservation {
  final ReservationRepository repository;

  DeleteReservationImpl({required this.repository});
  @override
  Future<Try<String>> call(DeleteReservationParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.cancelReservation(
        params.condominiumId, params.reservationId, params.reservationType);
  }

  Failure? _validate(DeleteReservationParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    if (param.reservationId.isEmpty) return InvalidParamFailure();
    if (param.reservationType.isEmpty) return InvalidParamFailure();
    return null;
  }
}
