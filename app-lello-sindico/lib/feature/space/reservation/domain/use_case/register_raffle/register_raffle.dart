import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_raffle_data.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';

abstract class RegisterRaffle
    extends UseCase<Reservation, RegisterRaffleParam> {}

class RegisterRaffleParam {
  final String condominiumId;
  final ReservationRegistration registration;
  final ReservationRaffleData data;

  RegisterRaffleParam(
      {required this.condominiumId,
      required this.registration,
      required this.data});
}
