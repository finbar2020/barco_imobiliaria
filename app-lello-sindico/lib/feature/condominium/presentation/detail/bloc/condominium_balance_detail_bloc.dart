import 'dart:async';

import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/core/analytics/analytics_log_events.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_balance_detail.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_balance_detail_filter.dart';
import 'package:lello/feature/condominium/domain/use_case/load_condominium_balance_detail/load_condominium_balance_detail.dart';
import 'package:lello/feature/condominium/presentation/detail/bloc/condominium_balance_detail_event.dart';
import 'package:lello/feature/condominium/presentation/detail/bloc/condominium_balance_detail_state.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';

class BalanceDetailBloc extends Bloc<BalanceDetailEvent, BalanceDetailState> {
  final SessionBloc sessionBloc;
  final LoadCondominiumBalanceDetail loadCondominiumBalanceDetail;
  String? pendingSearch;

  StreamSubscription? _subscription;

  BalanceDetailBloc({
    required this.sessionBloc,
    required this.loadCondominiumBalanceDetail,
  }) : super(const BalanceDetailLoadingState(null, '', null)) {
    on<BalanceDetailLoadEvent>(_mapLoad);
    if (sessionBloc.state is SessionLoadedState) {
      _onSessionChanged(sessionBloc.state);
    } else {
      _subscription = sessionBloc.stream.listen(_onSessionChanged);
    }
  }

  Future<void> _mapLoad(
    BalanceDetailLoadEvent event,
    Emitter<BalanceDetailState> emit,
  ) async {
    emit(BalanceDetailLoadingState(
        state.data, event.condominiumId, event.filter));
    final condominiumId = event.condominiumId;
    final filter = event.filter;
    final reference = event.reference ??
        sessionBloc.state.session!.selectedCondominium!.reference;

    CondominiumBalanceDetail? localBalance;
    if (filter == null) {
      //buscaCache
      final resultCache = await loadCondominiumBalanceDetail.call(
          LoadCondominiumBalanceDetailParam(
              condominiumId: condominiumId,
              filter: filter,
              reference: reference,
              origin: DataOrigin.local));

      if (resultCache is Success<CondominiumBalanceDetail?>) {
        localBalance = resultCache.get();
      }
    }

    final result = await loadCondominiumBalanceDetail.call(
        LoadCondominiumBalanceDetailParam(
            condominiumId: condominiumId,
            filter: filter,
            reference: reference,
            origin: DataOrigin.remote));
    var resultYield = result.fold(
        (err) => localBalance == null
            ? BalanceDetailLoadFailedState(
                state.data, condominiumId, event.filter, err)
            : BalanceDetailLoadedState(
                localBalance, condominiumId, filter, false,
                remoteFail: true),
        (data) {
      ManagerAnalyticsLogEvents.logEvent(
          event: AnalyticsEventsManager.homeSaldoAcessar(),
          referenceValue: reference);
      return BalanceDetailLoadedState(data!, condominiumId, filter, false);
    });

    emit(resultYield);
  }

  void _onSessionChanged(SessionState sessionState) {
    if (sessionState is SessionLoadedState) {
      final condominium = sessionState.session?.selectedCondominium;
      if (condominium != null) {
        add(BalanceDetailLoadEvent(
            condominiumId: condominium.id, reference: condominium.reference));
      }
    }
  }

  void beginSearch(String query, {bool force = false}) {
    if (!force &&
        (state is BalanceDetailSearchingState ||
            state is BalanceDetailLoadingState ||
            state is BalanceDetailPagingState)) {
      pendingSearch = query;
    } else {
      add(BalanceDetailSearchEvent(query: query));
    }
  }

  void beginRefresh(CondominiumBalanceDetailFilter filter) {
    if (state is! BalanceDetailLoadingState &&
        state is! BalanceDetailPagingState) {
      add(BalanceDetailLoadEvent(
          condominiumId: state.condominiumId!, filter: filter));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  void beginLoadNextPage() {
    final current = state;
    if (current is! BalanceDetailLoadingState &&
        current is! BalanceDetailPagingState) {
      if (current is BalanceDetailLoadedState && current.donePaging) return;
      add(const BalanceDetailNextPageEvent());
    }
  }
}
