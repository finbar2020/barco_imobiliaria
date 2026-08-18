import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration_time/reservation_registration_time_event.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration_time/reservation_registration_time_state.dart';

abstract class ReservationRegistrationTimeBloc extends Bloc<
    ReservationRegistrationTimeEvent, ReservationRegistrationTimeState> {
  ReservationRegistrationTimeBloc(ReservationRegistrationTimeState initialState)
      : super(initialState);

  void beginLoad(ReservationRegistration registration);
}
