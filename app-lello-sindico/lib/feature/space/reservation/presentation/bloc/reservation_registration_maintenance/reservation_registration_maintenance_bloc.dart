import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration_maintenance/reservation_registration_maintenance_event.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration_maintenance/reservation_registration_maintenance_state.dart';

abstract class ReservationRegistrationMaintenanceBloc extends Bloc<
    ReservationRegistrationMaintenanceEvent,
    ReservationRegistrationMaintenanceState> {
  ReservationRegistrationMaintenanceBloc(
      ReservationRegistrationMaintenanceState initialState)
      : super(initialState);

  void beginSetup(ReservationRegistration registration);
  void beginRegister();
}
