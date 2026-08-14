import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/domain/entity/space_available_hours.dart';
import 'package:lello/feature/space/reservation/domain/repository/reservation_repository.dart';
import 'package:lello/feature/space/reservation/domain/use_case/list_reservation/list_reservation.dart';

class ListReservationImpl extends ListReservation {
  final ReservationRepository repository;

  ListReservationImpl({required this.repository});

  @override
  Future<Try<List<SpaceAvailableHours>>> call(
      ListReservationParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.list(params.condominiumId,
        unitId: params.unitId, spaceId: params.spaceId, date: params.date);
  }

  Failure? _validate(ListReservationParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    if (param.spaceId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
