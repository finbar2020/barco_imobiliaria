import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';

abstract class ReservationRegistrationMaintenanceState {
  final ReservationRegistration? registration;
  final String? condominiumId;

  ReservationRegistrationMaintenanceState(
      this.registration, this.condominiumId);
}

class ReservationRegistrationMaintenanceIdleState
    extends ReservationRegistrationMaintenanceState {
  ReservationRegistrationMaintenanceIdleState(
      ReservationRegistration? registration, String? condominiumId)
      : super(registration, condominiumId);
}

class ReservationRegistrationMaintenanceRegisteringState
    extends ReservationRegistrationMaintenanceState {
  ReservationRegistrationMaintenanceRegisteringState(
      ReservationRegistration registration, String condominiumId)
      : super(registration, condominiumId);
}

class ReservationRegistrationMaintenanceRegisterFailedState
    extends ReservationRegistrationMaintenanceState {
  final Failure error;
  ReservationRegistrationMaintenanceRegisterFailedState(
      ReservationRegistration registration, String condominiumId, this.error)
      : super(registration, condominiumId);
}

class ReservationRegistrationMaintenanceRegisteredState
    extends ReservationRegistrationMaintenanceState {
  final Reservation reservation;
  ReservationRegistrationMaintenanceRegisteredState(this.reservation,
      ReservationRegistration registration, String condominiumId)
      : super(registration, condominiumId);
}
