import 'dart:async';

import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';
import 'package:lello/feature/space/reservation/domain/use_case/register_maintenance/register_maintenance.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration_maintenance/reservation_registration_maintenance_bloc.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration_maintenance/reservation_registration_maintenance_event.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration_maintenance/reservation_registration_maintenance_state.dart';

class ReservationRegistrationMaintenanceBlocImpl
    extends ReservationRegistrationMaintenanceBloc {
  final SessionBloc sessionBloc;
  final RegisterMaintenance registerMaintenance;

  StreamSubscription? _subscription;
  ReservationRegistration? _pendingRegistration;

  ReservationRegistrationMaintenanceBlocImpl(
      {required this.sessionBloc, required this.registerMaintenance})
      : super(ReservationRegistrationMaintenanceIdleState(null, null)) {
    if (sessionBloc.state is SessionLoadedState) {
      _onSessionChanged(sessionBloc.state);
    } else {
      _subscription = this.sessionBloc.stream.listen(_onSessionChanged);
    }
  }
  @override
  Stream<ReservationRegistrationMaintenanceState> mapEventToState(
      ReservationRegistrationMaintenanceEvent event) async* {
    if (event is ReservationRegistrationMaintenanceSetupEvent)
      yield ReservationRegistrationMaintenanceIdleState(
          event.registration, event.condominiumId);
    if (event is ReservationRegistrationMaintenanceRegisterEvent)
      yield* _mapRegister(event);
  }

  Stream<ReservationRegistrationMaintenanceState> _mapRegister(
      ReservationRegistrationMaintenanceRegisterEvent event) async* {
    final condominiumId = state.condominiumId!;
    final registration = state.registration!;

    yield ReservationRegistrationMaintenanceRegisteringState(
        registration, condominiumId);

    // registration.time.from = registration.date ?? DateTime.now();
    // registration.time.to = registration.dateTo ?? DateTime.now();

    final result = await registerMaintenance.call(RegisterMaintenanceParam(
        condominiumId: condominiumId, registration: registration));
    yield result.fold(
        (err) => ReservationRegistrationMaintenanceRegisterFailedState(
            registration, condominiumId, err),
        (res) => ReservationRegistrationMaintenanceRegisteredState(
            res, registration, condominiumId));
  }

  void _onSessionChanged(SessionState sessionState) {
    if (sessionState is SessionLoadedState && _pendingRegistration != null) {
      beginSetup(_pendingRegistration!);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  @override
  void beginRegister() {
    add(ReservationRegistrationMaintenanceRegisterEvent());
  }

  @override
  void beginSetup(ReservationRegistration registration) {
    final sessionState = sessionBloc.state;
    if (sessionState is SessionLoadedState) {
      final condominium = sessionState.session?.selectedCondominium;
      if (condominium != null) {
        add(ReservationRegistrationMaintenanceSetupEvent(
            registration: registration, condominiumId: condominium.id));
      }
      _pendingRegistration = null;
    } else {
      _pendingRegistration = registration;
    }
  }
}
