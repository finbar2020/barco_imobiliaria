import 'package:essentials/essentials.dart';
import 'package:lello/feature/resident/domain/entity/resident.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';

abstract class ReservationRegistrationRaffleState {
  final ReservationRegistration? registration;
  final String? condominiumId;

  ReservationRegistrationRaffleState(this.registration, this.condominiumId);
}

class ReservationRegistrationRaffleLoadingState
    extends ReservationRegistrationRaffleState {
  ReservationRegistrationRaffleLoadingState(
      ReservationRegistration? registration, String? condominiumId)
      : super(registration, condominiumId);
}

class ReservationRegistrationRaffleLoadedState
    extends ReservationRegistrationRaffleState {
  final List<Unit> units;
  final List<Resident> residents;
  ReservationRegistrationRaffleLoadedState(ReservationRegistration registration,
      String condominiumId, this.residents, this.units)
      : super(registration, condominiumId);
}

class ReservationRegistrationRaffleLoadFailedState
    extends ReservationRegistrationRaffleState {
  final Failure err;
  ReservationRegistrationRaffleLoadFailedState(
      ReservationRegistration registration, String condominiumId, this.err)
      : super(registration, condominiumId);
}

class ReservationRegistrationRaffleRegisteringState
    extends ReservationRegistrationRaffleLoadedState {
  ReservationRegistrationRaffleRegisteringState(
      ReservationRegistration registration,
      String condominiumId,
      List<Resident> residents,
      List<Unit> units)
      : super(registration, condominiumId, residents, units);
}

class ReservationRegistrationRaffleRegisterFailedState
    extends ReservationRegistrationRaffleLoadedState {
  final Failure error;
  ReservationRegistrationRaffleRegisterFailedState(
      ReservationRegistration registration,
      String condominiumId,
      List<Resident> residents,
      List<Unit> units,
      this.error)
      : super(registration, condominiumId, residents, units);
}

class ReservationRegistrationRaffleRegisteredState
    extends ReservationRegistrationRaffleLoadedState {
  final Reservation reservation;
  ReservationRegistrationRaffleRegisteredState(
      this.reservation,
      ReservationRegistration registration,
      List<Resident> residents,
      List<Unit> units,
      String condominiumId)
      : super(registration, condominiumId, residents, units);
}
