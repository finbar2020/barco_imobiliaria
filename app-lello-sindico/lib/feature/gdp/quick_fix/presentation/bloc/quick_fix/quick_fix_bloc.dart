import 'dart:async';

import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/core/analytics/analytics_log_events.dart';
import 'package:lello/feature/gdp/domain/entity/employee_list_filter.dart';
import 'package:lello/feature/gdp/domain/use_case/list_employee/list_employee.dart';
import 'package:lello/feature/gdp/quick_fix/presentation/bloc/quick_fix/quick_fix_event.dart';
import 'package:lello/feature/gdp/quick_fix/presentation/bloc/quick_fix/quick_fix_state.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';

class QuickFixBloc extends Bloc<QuickFixEvent, QuickFixState> {
  final SessionBloc sessionBloc;
  final ListEmployee listEmployee;

  StreamSubscription? _subscription;

  QuickFixBloc({required this.sessionBloc, required this.listEmployee})
      : super(QuickFixLoadingState(null, null)) {
    on<QuickFixLoadEvent>(_mapLoad);
    if (sessionBloc.state is SessionLoadedState) {
      _onSessionChanged(sessionBloc.state);
    } else {
      _subscription = sessionBloc.stream.listen(_onSessionChanged);
    }
  }

  Future<void> _mapLoad(
    QuickFixLoadEvent event,
    Emitter<QuickFixState> emit,
  ) async {
    final condominiumId = event.condominiumId;
    final data = state.data;
    EmployeeListFilter filter = EmployeeListFilter();
    filter.conditionName = "ativo";
    emit(QuickFixLoadingState(data, condominiumId));

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

    emit(resultYield);
  }

  void _onSessionChanged(SessionState sessionState) {
    if (sessionState is SessionLoadedState) {
      final condominium = sessionState.session?.selectedCondominium;
      if (condominium != null) {
        add(QuickFixLoadEvent(condominiumId: condominium.id));
      }
    }
  }

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
