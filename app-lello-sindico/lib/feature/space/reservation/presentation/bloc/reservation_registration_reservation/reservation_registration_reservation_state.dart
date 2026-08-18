import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_rule.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';

abstract class ReservationRegistrationReservationState {
  final ReservationRegistration? registration;
  final String? condominiumId;

  ReservationRegistrationReservationState(
      this.registration, this.condominiumId);
}

class ReservationRegistrationReservationLoadingState
    extends ReservationRegistrationReservationState {
  ReservationRegistrationReservationLoadingState(
      ReservationRegistration? registration, String? condominiumId)
      : super(registration, condominiumId);
}

class ReservationRegistrationReservationLoadedState
    extends ReservationRegistrationReservationState {
  final ReservationRule rule;
  final List<Unit> units;
  ReservationRegistrationReservationLoadedState(
      ReservationRegistration registration,
      String condominiumId,
      this.rule,
      this.units)
      : super(registration, condominiumId);
}

class ReservationRegistrationReservationLoadFailedState
    extends ReservationRegistrationReservationState {
  final Failure err;
  ReservationRegistrationReservationLoadFailedState(
      ReservationRegistration registration, String condominiumId, this.err)
      : super(registration, condominiumId);
}

class ReservationRegistrationReservationRegisteringState
    extends ReservationRegistrationReservationLoadedState {
  ReservationRegistrationReservationRegisteringState(
      ReservationRegistration registration,
      String condominiumId,
      ReservationRule rule,
      List<Unit> units)
      : super(registration, condominiumId, rule, units);
}

class ReservationRegistrationReservationRegisterFailedState
    extends ReservationRegistrationReservationLoadedState {
  final Failure error;
  ReservationRegistrationReservationRegisterFailedState(
      ReservationRegistration registration,
      String condominiumId,
      ReservationRule rule,
      List<Unit> units,
      this.error)
      : super(registration, condominiumId, rule, units);
}

class ReservationRegistrationReservationRegisteredState
    extends ReservationRegistrationReservationLoadedState {
  final Reservation reservation;
  ReservationRegistrationReservationRegisteredState(
      this.reservation,
      ReservationRegistration registration,
      ReservationRule rule,
      List<Unit> units,
      String condominiumId)
      : super(registration, condominiumId, rule, units);
}
