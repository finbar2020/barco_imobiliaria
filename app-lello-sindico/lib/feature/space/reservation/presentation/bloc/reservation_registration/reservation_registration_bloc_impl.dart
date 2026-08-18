import 'dart:async';

import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_type.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration/reservation_registration_bloc.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration/reservation_registration_event.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration/reservation_registration_state.dart';

class ReservationRegistrationBlocImpl extends ReservationRegistrationBloc {
  final SessionBloc sessionBloc;

  StreamSubscription? _subscription;

  ReservationRegistration? _pendingRegistration;

  ReservationRegistrationBlocImpl({required this.sessionBloc})
      : super(ReservationRegistrationIdleState(null, null)) {
    if (sessionBloc.state is SessionLoadedState) {
      _onSessionChanged(sessionBloc.state);
    } else {
      _subscription = sessionBloc.stream.listen(_onSessionChanged);
    }
  }

  @override
  Stream<ReservationRegistrationState> mapEventToState(
      ReservationRegistrationEvent event) async* {
    if (event is ReservationRegistrationSetupEvent) yield* _mapSetup(event);
    if (event is ReservationRegistrationSetTypeEvent) yield* _mapSetType(event);
  }

  Stream<ReservationRegistrationState> _mapSetup(
      ReservationRegistrationSetupEvent event) async* {
    final condominiumId = event.condominiumId;
    final registration = event.registration;

    yield ReservationRegistrationIdleState(registration, condominiumId);
  }

  Stream<ReservationRegistrationState> _mapSetType(
      ReservationRegistrationSetTypeEvent event) async* {
    final condominiumId = state.condominiumId;
    final registration = state.registration;

    yield ReservationRegistrationFormState(registration!, condominiumId!);
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

  @override
  void setType(ReservationType type) {
    add(ReservationRegistrationSetTypeEvent(type: type));
  }
}
