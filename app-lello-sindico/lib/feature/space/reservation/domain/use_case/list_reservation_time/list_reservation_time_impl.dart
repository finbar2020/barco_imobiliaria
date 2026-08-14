import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_time.dart';
import 'package:lello/feature/space/reservation/domain/repository/reservation_time_repository.dart';
import 'package:lello/feature/space/reservation/domain/use_case/list_reservation_time/list_reservation_time.dart';

class ListReservationTimeImpl extends ListReservationTime {
  final ReservationTimeRepository repository;

  ListReservationTimeImpl({required this.repository});
  @override
  Future<Try<List<ReservationTime>>> call(
      ListReservationTimeParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.list(
        params.condominiumId, params.spaceId, params.date);
  }

  Failure? _validate(ListReservationTimeParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.spaceId.isEmpty) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();

    return null;
  }
}
