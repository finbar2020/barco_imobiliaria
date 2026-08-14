import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/domain/repository/reservation_repository.dart';
import 'package:lello/feature/space/reservation/domain/use_case/register_reservation/register_reservation.dart';

class RegisterReservationImpl extends RegisterReservation {
  final ReservationRepository repository;
  RegisterReservationImpl({required this.repository});

  @override
  Future<Try<String>> call(RegisterReservationParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.insertReservation(
        params.condominiumId, params.registration, params.registration.unitId!);
  }

  Failure? _validate(RegisterReservationParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();

    return null;
  }
}
