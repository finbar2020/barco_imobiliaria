import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_raffle_result.dart';
import 'package:lello/feature/space/reservation/domain/repository/reservation_repository.dart';
import 'package:lello/feature/space/reservation/domain/use_case/draw_raffle/draw_raffle.dart';

class DrawRaffleImpl extends DrawRaffle {
  final ReservationRepository repository;

  DrawRaffleImpl({required this.repository});

  @override
  Future<Try<ReservationRaffleResult>> call(DrawRaffleParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.insertRaffleExecution(
        params.condominiumId, params.spaceId, params.reservationId);
  }

  Failure? _validate(DrawRaffleParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.reservationId.isEmpty) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    if (param.spaceId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
