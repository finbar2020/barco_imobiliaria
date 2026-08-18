import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';

abstract class ReservationRegistrationState {
  final ReservationRegistration? registration;
  final String? condominiumId;

  ReservationRegistrationState(this.registration, this.condominiumId);
}

class ReservationRegistrationIdleState extends ReservationRegistrationState {
  ReservationRegistrationIdleState(
    ReservationRegistration? registration,
    String? condominiumId,
  ) : super(registration, condominiumId);
}

class ReservationRegistrationFormState extends ReservationRegistrationState {
  ReservationRegistrationFormState(
    ReservationRegistration registration,
    String condominiumId,
  ) : super(registration, condominiumId);
}
