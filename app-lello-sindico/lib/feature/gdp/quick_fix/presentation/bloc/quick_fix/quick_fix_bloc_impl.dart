import 'dart:async';

import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/core/analytics/analytics_log_events.dart';
import 'package:lello/feature/gdp/domain/entity/employee_list_filter.dart';
import 'package:lello/feature/gdp/domain/use_case/list_employee/list_employee.dart';
import 'package:lello/feature/gdp/quick_fix/presentation/bloc/quick_fix/quick_fix_bloc.dart';
import 'package:lello/feature/gdp/quick_fix/presentation/bloc/quick_fix/quick_fix_event.dart';
import 'package:lello/feature/gdp/quick_fix/presentation/bloc/quick_fix/quick_fix_state.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';

class QuickFixBlocImpl extends QuickFixBloc {
  final SessionBloc sessionBloc;
  final ListEmployee listEmployee;

  StreamSubscription? _subscription;

  QuickFixBlocImpl({required this.sessionBloc, required this.listEmployee})
      : super(QuickFixLoadingState(null, null)) {
    if (sessionBloc.state is SessionLoadedState) {
      _onSessionChanged(sessionBloc.state);
    } else {
      _subscription = sessionBloc.stream.listen(_onSessionChanged);
    }
  }

  @override
  Stream<QuickFixState> mapEventToState(QuickFixEvent event) async* {
    if (event is QuickFixLoadEvent) yield* _mapLoad(event);
  }

  Stream<QuickFixState> _mapLoad(QuickFixLoadEvent event) async* {
    final condominiumId = event.condominiumId;
    final data = state.data;
    EmployeeListFilter filter = EmployeeListFilter();
    filter.conditionName = "ativo";
    yield QuickFixLoadingState(data, condominiumId);

    final result = await listEmployee.call(ListEmployeeParam(
        condominiumId: condominiumId,
        origin: DataOrigin.remote,
        filter: filter));
    var resultYield = result.fold(
        (err) => QuickFixLoadFailedState(data, condominiumId, err), (res) {
      String reference = sessionBloc
              .state.session!.selectedCondominium?.reference
              .toString() ??
          "";
      ManagerAnalyticsLogEvents.logEvent(
          event: AnalyticsEventsManager.resolvaRapidoAcessar(),
          referenceValue: reference);

      return QuickFixLoadedState(res, condominiumId);
    });

    yield resultYield;
  }

  void _onSessionChanged(SessionState sessionState) {
    if (sessionState is SessionLoadedState) {
      final condominium = sessionState.session?.selectedCondominium;
      if (condominium != null) {
        add(QuickFixLoadEvent(condominiumId: condominium.id));
      }
    }
  }

  @override
  void beginLoad() {
    if (state is! QuickFixLoadingState) {
      add(QuickFixLoadEvent(condominiumId: state.condominiumId!));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
