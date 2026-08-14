import 'package:essentials/essentials.dart';
import 'package:morar/feature/reservation/domain/entity/reservation_registration.dart';
import 'package:morar/feature/reservation/domain/entity/reservation_scheduled.dart';

abstract class PostReservation
    extends UseCase<ReservationScheduled, PostReservationParam> {}

class PostReservationParam {
  final String condominiumId;
  final String spaceId;
  final ReservationRegistration reservationRegistration;

  PostReservationParam({
    required this.condominiumId,
    required this.spaceId,
    required this.reservationRegistration,
  });
}
