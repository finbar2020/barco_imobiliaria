import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';
import 'package:lello/feature/space/reservation/domain/use_case/register_maintenance/register_maintenance.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration_maintenance/reservation_registration_maintenance_event.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration_maintenance/reservation_registration_maintenance_state.dart';

class ReservationRegistrationMaintenanceBloc extends Bloc<
    ReservationRegistrationMaintenanceEvent,
    ReservationRegistrationMaintenanceState> {
  final SessionBloc sessionBloc;
  final RegisterMaintenance registerMaintenance;

  StreamSubscription? _subscription;
  ReservationRegistration? _pendingRegistration;

  ReservationRegistrationMaintenanceBloc(
      {required this.sessionBloc, required this.registerMaintenance})
      : super(ReservationRegistrationMaintenanceInitialState(null, null)) {
    on<ReservationRegistrationMaintenanceSetupEvent>((event, emit) {
      emit(ReservationRegistrationMaintenanceInitialState(
          event.registration, event.condominiumId));
    });
    on<ReservationRegistrationMaintenanceRegisterEvent>(_mapRegister);
    if (sessionBloc.state is SessionLoadedState) {
      _onSessionChanged(sessionBloc.state);
    } else {
      _subscription = this.sessionBloc.stream.listen(_onSessionChanged);
    }
  }

  Future<void> _mapRegister(
    ReservationRegistrationMaintenanceRegisterEvent event,
    Emitter<ReservationRegistrationMaintenanceState> emit,
  ) async {
    final condominiumId = state.condominiumId!;
    final registration = state.registration!;

    emit(ReservationRegistrationMaintenanceRegisteringState(
        registration, condominiumId));

    // registration.time.from = registration.date ?? DateTime.now();
    // registration.time.to = registration.dateTo ?? DateTime.now();

    final result = await registerMaintenance.call(RegisterMaintenanceParam(
        condominiumId: condominiumId, registration: registration));
    emit(result.fold(
        (err) => ReservationRegistrationMaintenanceRegisterFailedState(
            registration, condominiumId, err),
        (res) => ReservationRegistrationMaintenanceRegisteredState(
            res, registration, condominiumId)));
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

  void beginRegister() {
    add(ReservationRegistrationMaintenanceRegisterEvent());
  }

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
