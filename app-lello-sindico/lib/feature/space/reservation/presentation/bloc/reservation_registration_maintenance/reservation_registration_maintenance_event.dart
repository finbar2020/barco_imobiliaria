import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';

abstract class ReservationRegistrationMaintenanceEvent {}

class ReservationRegistrationMaintenanceSetupEvent
    extends ReservationRegistrationMaintenanceEvent {
  final ReservationRegistration registration;
  final String condominiumId;

  ReservationRegistrationMaintenanceSetupEvent(
      {required this.registration, required this.condominiumId});
}

class ReservationRegistrationMaintenanceRegisterEvent
    extends ReservationRegistrationMaintenanceEvent {
  ReservationRegistrationMaintenanceRegisterEvent();
}
