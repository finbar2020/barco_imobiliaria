import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';

abstract class ReservationRegistrationMaintenanceState extends Equatable {
  final ReservationRegistration? registration;
  final String? condominiumId;

  const ReservationRegistrationMaintenanceState(
      this.registration, this.condominiumId);

  @override
  List<Object?> get props => [registration, condominiumId];
}

class ReservationRegistrationMaintenanceInitialState
    extends ReservationRegistrationMaintenanceState {
  const ReservationRegistrationMaintenanceInitialState(
      ReservationRegistration? registration, String? condominiumId)
      : super(registration, condominiumId);
}

class ReservationRegistrationMaintenanceRegisteringState
    extends ReservationRegistrationMaintenanceState {
  const ReservationRegistrationMaintenanceRegisteringState(
      ReservationRegistration registration, String condominiumId)
      : super(registration, condominiumId);
}

class ReservationRegistrationMaintenanceRegisterFailedState
    extends ReservationRegistrationMaintenanceState {
  final Failure error;

  const ReservationRegistrationMaintenanceRegisterFailedState(
      ReservationRegistration registration, String condominiumId, this.error)
      : super(registration, condominiumId);

  @override
  List<Object?> get props => [registration, condominiumId, error];
}

class ReservationRegistrationMaintenanceRegisteredState
    extends ReservationRegistrationMaintenanceState {
  final Reservation reservation;

  const ReservationRegistrationMaintenanceRegisteredState(this.reservation,
      ReservationRegistration registration, String condominiumId)
      : super(registration, condominiumId);

  @override
  List<Object?> get props => [registration, condominiumId, reservation];
}
