import 'package:essentials/essentials.dart';
import 'package:morar/feature/reservation/domain/repository/reserve_repository.dart';
import 'package:morar/feature/reservation/domain/use_case/delete_reservation/delete_reservation.dart';

class DeleteReservationImpl extends DeleteReservation {
  final ReservationRepository repository;

  DeleteReservationImpl({required this.repository});

  @override
  Future<Try<String>> call(DeleteReservationParam params) async {
    final error = validate(params);

    if (error != null) return Rejection(error);

    final result = await repository.deleteReservation(
      params.condominiumId,
      params.reservationId,
      params.reservationType,
    );

    return result;
  }

  Failure? validate(DeleteReservationParam params) {
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    if (params.reservationId.isEmpty) return InvalidParamFailure();
    if (params.reservationType.isEmpty) return InvalidParamFailure();

    return null;
  }
}
