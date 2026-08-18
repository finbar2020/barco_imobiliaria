import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';

abstract class ReservationRegistrationTimeEvent {}

class ReservationRegistrationTimeLoadEvent
    extends ReservationRegistrationTimeEvent {
  final String condominiumId;
  final ReservationRegistration registration;
  ReservationRegistrationTimeLoadEvent(
      {required this.condominiumId, required this.registration});
}
