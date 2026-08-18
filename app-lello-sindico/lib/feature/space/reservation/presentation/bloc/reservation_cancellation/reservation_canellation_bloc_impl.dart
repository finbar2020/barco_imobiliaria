import 'dart:async';

import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation.dart';
import 'package:lello/feature/space/reservation/domain/use_case/cancel_reservation/cancel_reservation.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_cancellation/reservation_cancellation_bloc.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_cancellation/reservation_cancellation_event.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_cancellation/reservation_cancellation_state.dart';

class ReservationCancellationBlocImpl extends ReservationCancellationBloc {
  final SessionBloc sessionBloc;
  final CancelReservation cancelReservation;
  Reservation? pendingCancellation;

  StreamSubscription? _subscription;

  ReservationCancellationBlocImpl(
      {required this.sessionBloc, required this.cancelReservation})
      : super(ReservationCancellationIdleState()) {
    if (sessionBloc.state is SessionLoadedState) {
      _onSessionChanged(sessionBloc.state);
    } else {
      _subscription = this.sessionBloc.stream.listen(_onSessionChanged);
    }
  }
  @override
  Stream<ReservationCancellationState> mapEventToState(
      ReservationCancellationEvent event) async* {
    if (event is ReservationCancellationCancelEvent) yield* _mapLoad(event);
  }

  Stream<ReservationCancellationState> _mapLoad(
      ReservationCancellationCancelEvent event) async* {
    final condominiumId = event.condominiumId;
    final data = event.reservation;

    yield ReservationCancellationLoadingState(data, condominiumId);

    final result = await cancelReservation.call(CancelReservationParam(
        condominiumId: condominiumId, reservationId: data.id!));
    yield result.fold(
        (err) =>
            ReservationCancellationCancelFailedState(data, condominiumId, err),
        (res) => ReservationCancellationCancelledState(
            event.reservation, condominiumId));
  }

  void _onSessionChanged(SessionState sessionState) {
    if (sessionState is SessionLoadedState && pendingCancellation != null) {
      beginCancel(pendingCancellation!);
    }
  }

  @override
  void beginCancel(Reservation reservation) {
    final sessionState = sessionBloc.state;
    if (sessionState is SessionLoadedState) {
      final condominium = sessionState.session?.selectedCondominium;
      if (condominium != null) {
        add(ReservationCancellationCancelEvent(
            condominiumId: condominium.id, reservation: reservation));
      }
      pendingCancellation = null;
    } else {
      pendingCancellation = reservation;
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
