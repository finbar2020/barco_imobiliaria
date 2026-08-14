import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';

abstract class ReservationRegistrationMaintenanceEvent extends Equatable {
  const ReservationRegistrationMaintenanceEvent();

  @override
  List<Object?> get props => [];
}

class ReservationRegistrationMaintenanceSetupEvent
    extends ReservationRegistrationMaintenanceEvent {
  final ReservationRegistration registration;
  final String condominiumId;

  const ReservationRegistrationMaintenanceSetupEvent(
      {required this.registration, required this.condominiumId});

  @override
  List<Object?> get props => [registration, condominiumId];
}

class ReservationRegistrationMaintenanceRegisterEvent
    extends ReservationRegistrationMaintenanceEvent {
  const ReservationRegistrationMaintenanceRegisterEvent();
}
