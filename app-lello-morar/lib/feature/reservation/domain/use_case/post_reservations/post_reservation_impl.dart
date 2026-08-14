import 'package:essentials/essentials.dart';
import 'package:morar/feature/reservation/domain/entity/reservation_scheduled.dart';
import 'package:morar/feature/reservation/domain/repository/reserve_repository.dart';
import 'package:morar/feature/reservation/domain/use_case/post_reservations/post_reservation.dart';

class PostReservationImpl extends PostReservation {
  final ReservationRepository repository;

  PostReservationImpl({required this.repository});

  @override
  Future<Try<ReservationScheduled>> call(PostReservationParam params) async {
    final error = validate(params);

    if (error != null) return Rejection(error);

    final result = await repository.postReservation(
      params.condominiumId,
      params.spaceId,
      params.reservationRegistration,
    );

    return result;
  }

  Failure? validate(PostReservationParam params) {
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    if (params.spaceId.isEmpty) return InvalidParamFailure();

    return null;
  }
}
