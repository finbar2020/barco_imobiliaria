import 'dart:async';

import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_filter.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_type.dart';
import 'package:lello/feature/space/reservation/domain/use_case/list_reservation/list_reservation.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_list/reservation_list_bloc.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_list/reservation_list_event.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_list/reservation_list_state.dart';

class ReservationListBlocImpl extends ReservationListBloc {
  final SessionBloc sessionBloc;
  final ListReservation listReservation;

  StreamSubscription? _subscription;
  ReservationType? pendingLoad;
  DateTime? pendingDate;
  ReservationFilter? pendingFilter;

  ReservationListBlocImpl(
      {required this.sessionBloc, required this.listReservation})
      : super(ReservationListLoadingState([], null, null, null, null, null)) {
    if (sessionBloc.state is SessionLoadedState) {
      _onSessionChanged(sessionBloc.state);
    } else {
      _subscription = this.sessionBloc.stream.listen(_onSessionChanged);
    }
  }

  @override
  Stream<ReservationListState> mapEventToState(
      ReservationListEvent event) async* {
    if (event is ReservationListLoadEvent) yield* _mapLoad(event);
    if (event is ReservationListNextPageEvent) yield* _mapNextPage(event);
  }

  Stream<ReservationListState> _mapLoad(ReservationListLoadEvent event) async* {
    final condominiumId = event.condominiumId;
    var data = state.data;
    final type = event.type;
    final spaceId = event.spaceId;
    final date = event.date;
    final filter = event.filter;

    yield ReservationListLoadingState(
      data,
      spaceId,
      condominiumId,
      type,
      date,
      filter,
    );

    final result = await listReservation.call(ListReservationParam(
        condominiumId: condominiumId, spaceId: spaceId!, date: date));

    yield result.fold(
        (err) => ReservationListLoadFailedState(
            data, spaceId, condominiumId, type!, date, filter!, err), (data) {
      // TODO: Remove this for raffle - app v2

      return ReservationListLoadedState(
          data, spaceId, condominiumId, type!, date, filter!, true);
    });
  }

  Stream<ReservationListState> _mapNextPage(
      ReservationListNextPageEvent event) async* {
    final condominiumId = state.condominiumId;
    final data = state.data;
    final type = state.type;
    final date = state.date;
    final spaceId = state.spaceId;
    final filter = state.filter;

    yield ReservationListPagingState(
        data, spaceId!, condominiumId!, type!, date!, filter!);

    final result = await listReservation.call(ListReservationParam(
        condominiumId: condominiumId, date: date, spaceId: spaceId));
    yield result.fold(
        (err) => ReservationListPageFailedState(
            data, spaceId, condominiumId, type, date, filter, err),
        (res) => ReservationListLoadedState(data + res, spaceId, condominiumId,
            type, date, filter, res.length == 0));
  }

  void _onSessionChanged(SessionState sessionState) {
    if (sessionState is SessionLoadedState && pendingLoad != null) {
      beginLoad(pendingDate!, "");
    }
  }

  @override
  void beginLoad(DateTime date, String spaceId) {
    final sessionState = sessionBloc.state;
    if (sessionState is SessionLoadedState) {
      final condominium = sessionState.session?.selectedCondominium;
      if (condominium != null) {
        add(ReservationListLoadEvent(
          condominiumId: condominium.id,
          date: date,
          spaceId: spaceId,
        ));
      }
      pendingLoad = null;
      pendingDate = null;
      pendingFilter = null;
    } else {
      pendingDate = date;
    }
  }

  @override
  void beginRefresh() {
    if (!(state is ReservationListLoadingState) &&
        !(state is ReservationListPagingState)) {
      add(ReservationListLoadEvent(
          condominiumId: state.condominiumId!,
          type: state.type,
          date: state.date!,
          filter: state.filter));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  @override
  void beginLoadNextPage() {
    final current = state;
    if (!(current is ReservationListLoadingState) &&
        !(current is ReservationListPagingState)) {
      if (current is ReservationListLoadedState && current.donePaging) return;
      add(ReservationListNextPageEvent());
    }
  }
}
