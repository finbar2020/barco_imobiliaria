import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_time.dart';

abstract class ReservationRegistrationTimeState extends Equatable {
  final List<ReservationTime> data;
  final String? condominiumId;
  final ReservationRegistration? registration;

  const ReservationRegistrationTimeState(
      this.data, this.condominiumId, this.registration);

  @override
  List<Object?> get props => [data, condominiumId, registration];
}

class ReservationRegistrationTimeLoadingState
    extends ReservationRegistrationTimeState {
  const ReservationRegistrationTimeLoadingState(
    List<ReservationTime> data,
    String? condominiumId,
    ReservationRegistration? registration,
  ) : super(data, condominiumId, registration);
}

class ReservationRegistrationTimeLoadFailedState
    extends ReservationRegistrationTimeState {
  final Failure error;

  const ReservationRegistrationTimeLoadFailedState(
      List<ReservationTime> data,
      String condominiumId,
      ReservationRegistration registration,
      this.error)
      : super(data, condominiumId, registration);

  @override
  List<Object?> get props => [data, condominiumId, registration, error];
}

class ReservationRegistrationTimeLoadedState
    extends ReservationRegistrationTimeState {
  const ReservationRegistrationTimeLoadedState(List<ReservationTime> data,
      String condominiumId, ReservationRegistration registration)
      : super(data, condominiumId, registration);
}
