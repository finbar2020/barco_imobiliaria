import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_raffle_detail.dart';
import 'package:lello/feature/space/reservation/domain/repository/reservation_repository.dart';
import 'package:lello/feature/space/reservation/domain/use_case/get_raffle/get_raffle.dart';

class GetRaffleImpl extends GetRaffle {
  final ReservationRepository repository;

  GetRaffleImpl({required this.repository});

  @override
  Future<Try<ReservationRaffleDetail>> call(GetRaffleParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.selectRaffleDetail(
        params.condominiumId, params.spaceId, params.reservationId);
  }

  Failure? _validate(GetRaffleParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.reservationId.isEmpty) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    if (param.spaceId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
