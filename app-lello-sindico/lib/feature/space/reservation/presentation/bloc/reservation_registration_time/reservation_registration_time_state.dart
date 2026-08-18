import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_time.dart';

abstract class ReservationRegistrationTimeState {
  final List<ReservationTime> data;
  final String? condominiumId;
  final ReservationRegistration? registration;

  ReservationRegistrationTimeState(
      this.data, this.condominiumId, this.registration);
}

class ReservationRegistrationTimeLoadingState
    extends ReservationRegistrationTimeState {
  ReservationRegistrationTimeLoadingState(
    List<ReservationTime> data,
    String? condominiumId,
    ReservationRegistration? registration,
  ) : super(data, condominiumId, registration);
}

class ReservationRegistrationTimeLoadFailedState
    extends ReservationRegistrationTimeState {
  final Failure error;
  ReservationRegistrationTimeLoadFailedState(List<ReservationTime> data,
      String condominiumId, ReservationRegistration registration, this.error)
      : super(data, condominiumId, registration);
}

class ReservationRegistrationTimeLoadedState
    extends ReservationRegistrationTimeState {
  ReservationRegistrationTimeLoadedState(List<ReservationTime> data,
      String condominiumId, ReservationRegistration registration)
      : super(data, condominiumId, registration);
}
