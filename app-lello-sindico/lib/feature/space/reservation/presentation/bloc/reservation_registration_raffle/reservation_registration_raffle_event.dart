import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_raffle_data.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';

abstract class ReservationRegistrationRaffleEvent extends Equatable {
  const ReservationRegistrationRaffleEvent();

  @override
  List<Object?> get props => [];
}

class ReservationRegistrationRaffleSetupEvent
    extends ReservationRegistrationRaffleEvent {
  final ReservationRegistration registration;
  final String condominiumId;

  const ReservationRegistrationRaffleSetupEvent(
      {required this.registration, required this.condominiumId});

  @override
  List<Object?> get props => [registration, condominiumId];
}

class ReservationRegistrationRaffleRegisterEvent
    extends ReservationRegistrationRaffleEvent {
  final ReservationRaffleData data;

  const ReservationRegistrationRaffleRegisterEvent({required this.data});

  @override
  List<Object?> get props => [data];
}
