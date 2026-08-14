import 'package:essentials/essentials.dart';
import 'package:morar/feature/reservation/domain/entity/reservation_scheduled.dart';
import 'package:morar/feature/reservation/domain/repository/reserve_repository.dart';
import 'package:morar/feature/reservation/domain/use_case/get_all_reservation/get_all_reservation.dart';

class GetAllReservationImpl extends GetAllReservation {
  final ReservationRepository repository;

  GetAllReservationImpl({required this.repository});

  @override
  Future<Try<List<ReservationScheduled>>> call(
      GetAllReservationParam params) async {
    final error = validate(params);

    if (error != null) return Rejection(error);

    final result = await repository.getAllReservationScheduled(
        params.condominiumId, params.unitId);

    return result;
  }

  Failure? validate(GetAllReservationParam params) {
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    if (params.unitId.isEmpty) return InvalidParamFailure();

    return null;
  }
}
