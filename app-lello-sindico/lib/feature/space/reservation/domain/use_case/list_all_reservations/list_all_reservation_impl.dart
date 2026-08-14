import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_response.dart';
import 'package:lello/feature/space/reservation/domain/repository/reservation_repository.dart';

import './list_all_reservation.dart';

class ListAllReservationsImpl extends ListAllReservation {
  final ReservationRepository repository;

  ListAllReservationsImpl({required this.repository});

  @override
  Future<Try<List<ReservationResponse>>> call(
      ListAllReservationParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.listAllReservations(params.condominiumId,
        startDate: params.startDate, endDate: params.endDate);
  }

  Failure? _validate(ListAllReservationParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
