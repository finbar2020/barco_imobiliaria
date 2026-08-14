import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';

abstract class RegisterMaintenance
    extends UseCase<Reservation, RegisterMaintenanceParam> {}

class RegisterMaintenanceParam {
  final String condominiumId;
  final ReservationRegistration registration;

  RegisterMaintenanceParam(
      {required this.condominiumId, required this.registration});
}
