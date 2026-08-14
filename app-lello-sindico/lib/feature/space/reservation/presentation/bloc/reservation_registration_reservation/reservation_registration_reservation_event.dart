import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration_data.dart';

abstract class ReservationRegistrationReservationEvent extends Equatable {
  const ReservationRegistrationReservationEvent();

  @override
  List<Object?> get props => [];
}

class ReservationRegistrationReservationSetupEvent
    extends ReservationRegistrationReservationEvent {
  final ReservationRegistration registration;
  final String condominiumId;

  const ReservationRegistrationReservationSetupEvent(
      {required this.registration, required this.condominiumId});

  @override
  List<Object?> get props => [registration, condominiumId];
}

class ReservationRegistrationReservationRegisterEvent
    extends ReservationRegistrationReservationEvent {
  final ReservationRegistrationData data;

  const ReservationRegistrationReservationRegisterEvent({required this.data});

  @override
  List<Object?> get props => [data];
}
