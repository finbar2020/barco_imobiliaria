import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';

abstract class RegisterReservation
    extends UseCase<String, RegisterReservationParam> {}

class RegisterReservationParam {
  final String condominiumId;
  final ReservationRegistration registration;

  RegisterReservationParam({
    required this.condominiumId,
    required this.registration,
  });
}
