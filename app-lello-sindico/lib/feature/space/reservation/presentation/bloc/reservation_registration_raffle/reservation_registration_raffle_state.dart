import 'package:essentials/essentials.dart';
import 'package:lello/feature/resident/domain/entity/resident.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';

abstract class ReservationRegistrationRaffleState extends Equatable {
  final ReservationRegistration? registration;
  final String? condominiumId;

  const ReservationRegistrationRaffleState(
      this.registration, this.condominiumId);

  @override
  List<Object?> get props => [registration, condominiumId];
}

class ReservationRegistrationRaffleLoadingState
    extends ReservationRegistrationRaffleState {
  const ReservationRegistrationRaffleLoadingState(
      ReservationRegistration? registration, String? condominiumId)
      : super(registration, condominiumId);
}

class ReservationRegistrationRaffleLoadedState
    extends ReservationRegistrationRaffleState {
  final List<Unit> units;
  final List<Resident> residents;

  const ReservationRegistrationRaffleLoadedState(
      ReservationRegistration registration,
      String condominiumId,
      this.residents,
      this.units)
      : super(registration, condominiumId);

  @override
  List<Object?> get props => [registration, condominiumId, residents, units];
}

class ReservationRegistrationRaffleLoadFailedState
    extends ReservationRegistrationRaffleState {
  final Failure err;

  const ReservationRegistrationRaffleLoadFailedState(
      ReservationRegistration registration, String condominiumId, this.err)
      : super(registration, condominiumId);

  @override
  List<Object?> get props => [registration, condominiumId, err];
}

class ReservationRegistrationRaffleRegisteringState
    extends ReservationRegistrationRaffleLoadedState {
  const ReservationRegistrationRaffleRegisteringState(
      ReservationRegistration registration,
      String condominiumId,
      List<Resident> residents,
      List<Unit> units)
      : super(registration, condominiumId, residents, units);
}

class ReservationRegistrationRaffleRegisterFailedState
    extends ReservationRegistrationRaffleLoadedState {
  final Failure error;

  const ReservationRegistrationRaffleRegisterFailedState(
      ReservationRegistration registration,
      String condominiumId,
      List<Resident> residents,
      List<Unit> units,
      this.error)
      : super(registration, condominiumId, residents, units);

  @override
  List<Object?> get props =>
      [registration, condominiumId, residents, units, error];
}

class ReservationRegistrationRaffleRegisteredState
    extends ReservationRegistrationRaffleLoadedState {
  final Reservation reservation;

  const ReservationRegistrationRaffleRegisteredState(
      this.reservation,
      ReservationRegistration registration,
      List<Resident> residents,
      List<Unit> units,
      String condominiumId)
      : super(registration, condominiumId, residents, units);

  @override
  List<Object?> get props =>
      [registration, condominiumId, residents, units, reservation];
}
