import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration_data.dart';

abstract class ReservationRegistrationReservationEvent {}

class ReservationRegistrationReservationSetupEvent
    extends ReservationRegistrationReservationEvent {
  final ReservationRegistration registration;
  final String condominiumId;

  ReservationRegistrationReservationSetupEvent(
      {required this.registration, required this.condominiumId});
}

class ReservationRegistrationReservationRegisterEvent
    extends ReservationRegistrationReservationEvent {
  final ReservationRegistrationData data;
  ReservationRegistrationReservationRegisterEvent({required this.data});
}
