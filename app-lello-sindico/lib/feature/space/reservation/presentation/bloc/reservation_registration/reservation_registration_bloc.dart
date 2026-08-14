import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_type.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration/reservation_registration_event.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration/reservation_registration_state.dart';

class ReservationRegistrationBloc
    extends Bloc<ReservationRegistrationEvent, ReservationRegistrationState> {
  final SessionBloc sessionBloc;

  StreamSubscription? _subscription;

  ReservationRegistration? _pendingRegistration;

  ReservationRegistrationBloc({required this.sessionBloc})
      : super(ReservationRegistrationInitialState(null, null)) {
    on<ReservationRegistrationSetupEvent>(_mapSetup);
    on<ReservationRegistrationSetTypeEvent>(_mapSetType);
    if (sessionBloc.state is SessionLoadedState) {
      _onSessionChanged(sessionBloc.state);
    } else {
      _subscription = sessionBloc.stream.listen(_onSessionChanged);
    }
  }

  Future<void> _mapSetup(
    ReservationRegistrationSetupEvent event,
    Emitter<ReservationRegistrationState> emit,
  ) async {
    final condominiumId = event.condominiumId;
    final registration = event.registration;

    emit(ReservationRegistrationInitialState(registration, condominiumId));
  }

  Future<void> _mapSetType(
    ReservationRegistrationSetTypeEvent event,
    Emitter<ReservationRegistrationState> emit,
  ) async {
    final condominiumId = state.condominiumId;
    final registration = state.registration;

    emit(ReservationRegistrationFormState(registration!, condominiumId!));
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

  void beginSetup(ReservationRegistration registration) {
    final sessionState = sessionBloc.state;
    if (sessionState is SessionLoadedState) {
      final condominium = sessionState.session?.selectedCondominium;
      if (condominium != null) {
        add(ReservationRegistrationSetupEvent(
            registration: registration, condominiumId: condominium.id));
      }
      _pendingRegistration = null;
    } else {
      _pendingRegistration = registration;
    }
  }

  void setType(ReservationType type) {
    add(ReservationRegistrationSetTypeEvent(type: type));
  }
}
