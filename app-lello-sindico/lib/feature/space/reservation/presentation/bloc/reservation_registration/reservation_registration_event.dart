import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_type.dart';

abstract class ReservationRegistrationEvent extends Equatable {
  const ReservationRegistrationEvent();

  @override
  List<Object?> get props => [];
}

class ReservationRegistrationSetupEvent extends ReservationRegistrationEvent {
  final String condominiumId;
  final ReservationRegistration registration;

  const ReservationRegistrationSetupEvent(
      {required this.condominiumId, required this.registration});

  @override
  List<Object?> get props => [condominiumId, registration];
}

class ReservationRegistrationSetTypeEvent extends ReservationRegistrationEvent {
  final ReservationType type;

  const ReservationRegistrationSetTypeEvent({required this.type});

  @override
  List<Object?> get props => [type];
}
