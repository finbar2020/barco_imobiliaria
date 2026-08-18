import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration_data.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration_reservation/reservation_registration_reservation_event.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration_reservation/reservation_registration_reservation_state.dart';

abstract class ReservationRegistrationReservationBloc extends Bloc<
    ReservationRegistrationReservationEvent,
    ReservationRegistrationReservationState> {
  ReservationRegistrationReservationBloc(
      ReservationRegistrationReservationState initialState)
      : super(initialState);

  void beginSetup(ReservationRegistration registration);
  void beginRegister(ReservationRegistrationData data);
}
