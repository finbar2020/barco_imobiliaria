import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation.dart';
import 'package:lello/feature/space/reservation/domain/repository/reservation_repository.dart';
import 'package:lello/feature/space/reservation/domain/use_case/register_raffle/register_raffle.dart';

class RegisterRaffleImpl extends RegisterRaffle {
  final ReservationRepository repository;
  RegisterRaffleImpl({required this.repository});

  @override
  Future<Try<Reservation>> call(RegisterRaffleParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.insertRaffle(
        params.condominiumId, params.registration, params.data);
  }

  Failure? _validate(RegisterRaffleParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();

    return null;
  }
}
