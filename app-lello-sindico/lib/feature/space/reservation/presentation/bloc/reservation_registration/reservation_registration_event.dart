import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_type.dart';

abstract class ReservationRegistrationEvent {}

class ReservationRegistrationSetupEvent extends ReservationRegistrationEvent {
  final String condominiumId;
  final ReservationRegistration registration;

  ReservationRegistrationSetupEvent(
      {required this.condominiumId, required this.registration});
}

class ReservationRegistrationSetTypeEvent extends ReservationRegistrationEvent {
  final ReservationType type;
  ReservationRegistrationSetTypeEvent({required this.type});
}
