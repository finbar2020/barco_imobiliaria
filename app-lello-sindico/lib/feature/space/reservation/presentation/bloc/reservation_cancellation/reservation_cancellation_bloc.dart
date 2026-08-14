import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation.dart';
import 'package:lello/feature/space/reservation/domain/use_case/cancel_reservation/cancel_reservation.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_cancellation/reservation_cancellation_event.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_cancellation/reservation_cancellation_state.dart';

class ReservationCancellationBloc
    extends Bloc<ReservationCancellationEvent, ReservationCancellationState> {
  final SessionBloc sessionBloc;
  final CancelReservation cancelReservation;
  Reservation? pendingCancellation;

  StreamSubscription? _subscription;

  ReservationCancellationBloc(
      {required this.sessionBloc, required this.cancelReservation})
      : super(ReservationCancellationInitialState()) {
    on<ReservationCancellationCancelEvent>(_mapLoad);
    if (sessionBloc.state is SessionLoadedState) {
      _onSessionChanged(sessionBloc.state);
    } else {
      _subscription = this.sessionBloc.stream.listen(_onSessionChanged);
    }
  }

  Future<void> _mapLoad(
    ReservationCancellationCancelEvent event,
    Emitter<ReservationCancellationState> emit,
  ) async {
    final condominiumId = event.condominiumId;
    final data = event.reservation;

    emit(ReservationCancellationLoadingState(data, condominiumId));

    final result = await cancelReservation.call(CancelReservationParam(
        condominiumId: condominiumId, reservationId: data.id!));
    emit(result.fold(
        (err) =>
            ReservationCancellationCancelFailedState(data, condominiumId, err),
        (res) => ReservationCancellationCancelledState(
            event.reservation, condominiumId)));
  }

  void _onSessionChanged(SessionState sessionState) {
    if (sessionState is SessionLoadedState && pendingCancellation != null) {
      beginCancel(pendingCancellation!);
    }
  }

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
