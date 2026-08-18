import 'package:lello/feature/space/reservation/domain/entity/reservation_raffle_data.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';

abstract class ReservationRegistrationRaffleEvent {}

class ReservationRegistrationRaffleSetupEvent
    extends ReservationRegistrationRaffleEvent {
  final ReservationRegistration registration;
  final String condominiumId;

  ReservationRegistrationRaffleSetupEvent(
      {required this.registration, required this.condominiumId});
}

class ReservationRegistrationRaffleRegisterEvent
    extends ReservationRegistrationRaffleEvent {
  final ReservationRaffleData data;
  ReservationRegistrationRaffleRegisterEvent({required this.data});
}
