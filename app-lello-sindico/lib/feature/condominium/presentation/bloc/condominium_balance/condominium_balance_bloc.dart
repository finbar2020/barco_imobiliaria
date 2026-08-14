import 'dart:async';

import 'package:essentials/essentials.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_balance.dart';
import 'package:lello/feature/condominium/domain/use_case/load_condominium_balance/load_condominium_balance.dart';
import 'package:lello/feature/condominium/presentation/bloc/condominium_balance/condominium_balance_event.dart';
import 'package:lello/feature/condominium/presentation/bloc/condominium_balance/condominium_balance_state.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';

class CondominiumBalanceBloc
    extends Bloc<CondominiumBalanceEvent, CondominiumBalanceState> {
  final SessionBloc sessionBloc;
  final LoadCondominiumBalance loadCondominiumBalance;

  StreamSubscription? subscription;

  CondominiumBalanceBloc({
    required this.sessionBloc,
    required this.loadCondominiumBalance,
  }) : super(const CondominiumBalanceInitialState()) {
    on<CondominiumBalanceLoadEvent>(_mapLoad);
    if (sessionBloc.state is SessionLoadedState) {
      _onSessionChanged(sessionBloc.state);
    } else {
      subscription = sessionBloc.stream.listen(_onSessionChanged);
    }
  }

  Future<void> _mapLoad(
    CondominiumBalanceLoadEvent event,
    Emitter<CondominiumBalanceState> emit,
  ) async {
    emit(const CondominiumBalanceLoadingState());

    var selectedCondominium = sessionBloc.state.session?.selectedCondominium;

    if (selectedCondominium == null) {
      emit(const CondominiumBalanceFailedState());
      return;
    }

    //buscaCache
    final resultCache = await loadCondominiumBalance.call(
        CondominiumBalanceParam(
            id: selectedCondominium.id,
            reference: selectedCondominium.reference,
            origin: DataOrigin.local));

    CondominiumBalance? localBalance;
    if (resultCache is Success<CondominiumBalance?>) {
      localBalance = resultCache.get();
      if (localBalance != null) {
        emit(CondominiumBalanceLoadedState(
            balance: localBalance, isUpdating: true));
      }
    }

    final resultRemote = await loadCondominiumBalance.call(
        CondominiumBalanceParam(
            id: selectedCondominium.id,
            reference: selectedCondominium.reference,
            origin: DataOrigin.remote));

    emit(resultRemote.fold(
        (err) => localBalance == null
            ? CondominiumBalanceFailedState(failure: err)
            : CondominiumBalanceLoadedState(
                balance: localBalance, remoteFail: true),
        (balance) => CondominiumBalanceLoadedState(balance: balance!)));
  }

  void _onSessionChanged(SessionState state) {
    if (state is SessionLoadedState) {
      add(const CondominiumBalanceLoadEvent());
    }
  }

  @override
  Future<void> close() {
    subscription?.cancel();
    return super.close();
  }
}
