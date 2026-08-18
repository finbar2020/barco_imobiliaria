import 'dart:async';

import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';
import 'package:lello/feature/space/reservation/domain/use_case/list_reservation_time/list_reservation_time.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration_time/reservation_registration_time_bloc.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration_time/reservation_registration_time_event.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration_time/reservation_registration_time_state.dart';

class ReservationRegistrationTimeBlocImpl
    extends ReservationRegistrationTimeBloc {
  final SessionBloc sessionBloc;
  final ListReservationTime listReservationTime;

  StreamSubscription? _subscription;
  ReservationRegistration? _pendingRegistration;

  ReservationRegistrationTimeBlocImpl(
      {required this.sessionBloc, required this.listReservationTime})
      : super(ReservationRegistrationTimeLoadingState([], null, null)) {
    if (sessionBloc.state is SessionLoadedState) {
      _onSessionChanged(sessionBloc.state);
    } else {
      _subscription = this.sessionBloc.stream.listen(_onSessionChanged);
    }
  }

  @override
  Stream<ReservationRegistrationTimeState> mapEventToState(
      ReservationRegistrationTimeEvent event) async* {
    if (event is ReservationRegistrationTimeLoadEvent) yield* _mapLoad(event);
  }

  Stream<ReservationRegistrationTimeState> _mapLoad(
      ReservationRegistrationTimeLoadEvent event) async* {
    final condominiumId = event.condominiumId;
    final data = state.data;
    final registration = event.registration;

    yield ReservationRegistrationTimeLoadingState(
        data, condominiumId, registration);

    final result = await listReservationTime.call(ListReservationTimeParam(
        condominiumId: condominiumId,
        spaceId: registration.space!.id!,
        date: DateTime.now()));
    yield result.fold(
        (err) => ReservationRegistrationTimeLoadFailedState(
            data, condominiumId, registration, err),
        (res) => ReservationRegistrationTimeLoadedState(
            res, condominiumId, registration));
  }

  void _onSessionChanged(SessionState sessionState) {
    if (sessionState is SessionLoadedState && _pendingRegistration != null) {
      beginLoad(_pendingRegistration!);
    }
  }

  @override
  void beginLoad(ReservationRegistration registration) {
    final sessionState = sessionBloc.state;
    if (sessionState is SessionLoadedState) {
      final condominium = sessionState.session?.selectedCondominium;
      if (condominium != null) {
        add(ReservationRegistrationTimeLoadEvent(
            condominiumId: condominium.id, registration: registration));
      }
      _pendingRegistration = null;
    } else {
      _pendingRegistration = registration;
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
