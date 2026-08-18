import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_raffle_data.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration_raffle/reservation_registration_raffle_event.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration_raffle/reservation_registration_raffle_state.dart';

abstract class ReservationRegistrationRaffleBloc extends Bloc<
    ReservationRegistrationRaffleEvent, ReservationRegistrationRaffleState> {
  ReservationRegistrationRaffleBloc(
      ReservationRegistrationRaffleState initialState)
      : super(initialState);

  void beginSetup(ReservationRegistration registration);
  void beginRegister(ReservationRaffleData data);
}
