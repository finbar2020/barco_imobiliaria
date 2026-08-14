import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';
import 'package:lello/feature/space/reservation/domain/use_case/draw_raffle/draw_raffle.dart';
import 'package:lello/feature/space/reservation/domain/use_case/get_raffle/get_raffle.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_raffle_draw_bloc/reservation_raffle_draw_event.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_raffle_draw_bloc/reservation_raffle_draw_state.dart';

class ReservationRaffleDrawBloc
    extends Bloc<ReservationRaffleDrawEvent, ReservationRaffleDrawState> {
  final SessionBloc sessionBloc;
  final GetRaffle getRaffle;
  final DrawRaffle drawRaffle;

  StreamSubscription? _subscription;
  String? pendingReservationId;
  String? pendingSpaceId;

  ReservationRaffleDrawBloc(
      {required this.sessionBloc,
      required this.getRaffle,
      required this.drawRaffle})
      : super(ReservationRaffleDrawLoadingState(null, null, null, null)) {
    on<ReservationRaffleDrawLoadEvent>(_mapLoad);
    on<ReservationRaffleDrawExecuteEvent>(_mapExecute);
    if (sessionBloc.state is SessionLoadedState) {
      _onSessionChanged(sessionBloc.state);
    } else {
      _subscription = this.sessionBloc.stream.listen(_onSessionChanged);
    }
  }

  Future<void> _mapExecute(
    ReservationRaffleDrawExecuteEvent event,
    Emitter<ReservationRaffleDrawState> emit,
  ) async {
    final condominiumId = state.condominiumId;
    final reservationId = state.reservationId;
    final spaceId = state.spaceId;
    final data = state.data!;

    emit(ReservationRaffleDrawLoadingState(
        data, condominiumId, spaceId, reservationId));

    final result = await drawRaffle.call(DrawRaffleParam(
        condominiumId: condominiumId!,
        reservationId: reservationId!,
        spaceId: spaceId!));
    emit(result.fold(
        (err) => ReservationRaffleDrawLoadFailedState(
            data, condominiumId, spaceId, reservationId, err),
        (res) => ReservationRaffleDrawSucceededState(
            res, data, spaceId, reservationId, condominiumId)));
  }

  Future<void> _mapLoad(
    ReservationRaffleDrawLoadEvent event,
    Emitter<ReservationRaffleDrawState> emit,
  ) async {
    final condominiumId = event.condominiumId;
    final reservationId = event.reservationId;
    final spaceId = event.spaceId;
    final data = state.data!;

    emit(ReservationRaffleDrawLoadingState(
        data, condominiumId, spaceId, reservationId));

    final result = await getRaffle.call(GetRaffleParam(
        condominiumId: condominiumId,
        reservationId: reservationId,
        spaceId: spaceId));
    emit(result.fold(
        (err) => ReservationRaffleDrawLoadFailedState(
            data, condominiumId, spaceId, reservationId, err),
        (res) => ReservationRaffleDrawLoadedState(
            res, condominiumId, spaceId, reservationId)));
  }

  void _onSessionChanged(SessionState sessionState) {
    if (sessionState is SessionLoadedState) {
      final condominium = sessionState.session?.selectedCondominium;
      if (condominium != null && pendingReservationId != null) {
        beginLoad(pendingReservationId!, pendingSpaceId!);
      }
    }
  }

  void beginDraw() {
    add(ReservationRaffleDrawExecuteEvent());
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  void beginLoad(String reservationId, String spaceId) {
    final sessionState = sessionBloc.state;
    if (sessionState is SessionLoadedState) {
      final condominium = sessionState.session?.selectedCondominium;
      if (condominium != null) {
        add(ReservationRaffleDrawLoadEvent(
            condominiumId: condominium.id,
            reservationId: reservationId,
            spaceId: spaceId));
      }
      pendingReservationId = null;
      pendingSpaceId = null;
    } else {
      pendingReservationId = reservationId;
      pendingSpaceId = spaceId;
    }
  }
}
