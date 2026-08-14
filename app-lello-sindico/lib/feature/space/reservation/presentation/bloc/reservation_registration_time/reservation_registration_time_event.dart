import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';

abstract class ReservationRegistrationTimeEvent extends Equatable {
  const ReservationRegistrationTimeEvent();

  @override
  List<Object?> get props => [];
}

class ReservationRegistrationTimeLoadEvent
    extends ReservationRegistrationTimeEvent {
  final String condominiumId;
  final ReservationRegistration registration;

  const ReservationRegistrationTimeLoadEvent(
      {required this.condominiumId, required this.registration});

  @override
  List<Object?> get props => [condominiumId, registration];
}
