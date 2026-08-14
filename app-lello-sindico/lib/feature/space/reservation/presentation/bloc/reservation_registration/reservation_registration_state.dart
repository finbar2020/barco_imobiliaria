import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';

abstract class ReservationRegistrationState extends Equatable {
  final ReservationRegistration? registration;
  final String? condominiumId;

  const ReservationRegistrationState(this.registration, this.condominiumId);

  @override
  List<Object?> get props => [registration, condominiumId];
}

class ReservationRegistrationInitialState extends ReservationRegistrationState {
  const ReservationRegistrationInitialState(
    ReservationRegistration? registration,
    String? condominiumId,
  ) : super(registration, condominiumId);
}

class ReservationRegistrationFormState extends ReservationRegistrationState {
  const ReservationRegistrationFormState(
    ReservationRegistration registration,
    String condominiumId,
  ) : super(registration, condominiumId);
}
