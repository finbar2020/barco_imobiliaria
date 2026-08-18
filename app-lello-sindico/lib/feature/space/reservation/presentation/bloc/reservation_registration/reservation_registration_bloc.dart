import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_type.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration/reservation_registration_event.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration/reservation_registration_state.dart';

abstract class ReservationRegistrationBloc
    extends Bloc<ReservationRegistrationEvent, ReservationRegistrationState> {
  ReservationRegistrationBloc(ReservationRegistrationState initialState)
      : super(initialState);

  void beginSetup(ReservationRegistration registration);
  void setType(ReservationType type);
}
