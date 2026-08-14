import 'dart:async';

import 'package:essentials/analytics/analytics_log_events.dart';
import 'package:essentials/analytics/events/analytics_events_employee.dart';
import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_features/feature/gdp/domain/entity/employee_list_filter.dart';
import 'package:shared_features/feature/gdp/domain/use_case/list_employee/list_employee.dart';
import 'package:shared_features/feature/gdp/quick_fix/presentation/bloc/quick_fix/quick_fix_event.dart';
import 'package:shared_features/feature/gdp/quick_fix/presentation/bloc/quick_fix/quick_fix_state.dart';
import 'package:shared_features/shared_features.dart';

class QuickFixBloc extends Bloc<QuickFixEvent, QuickFixState> {
  final SharedSession? sessionBloc;
  final ListEmployee listEmployee;
  final AppOriginEnum appOriginEnum;

  StreamSubscription? _subscription;

  QuickFixBloc(
      {required this.sessionBloc,
      required this.listEmployee,
      required this.appOriginEnum})
      : super(QuickFixLoadingState(null, null)) {
    on<QuickFixLoadEvent>(_mapLoad);
    _onSessionChanged();
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
      AnalyticsLogEvents.logEvent(
        event: appOriginEnum == AppOriginEnum.manager
            ? AnalyticsEventsManager.resolvaRapidoAcessar()
            : AnalyticsEventsEmployee.resolvaRapidoAcessar(),
        unitValue: sessionBloc?.unitId.toString() ?? "",
        referenceValue: sessionBloc?.condominiumReference.toString() ?? "",
        appOrigin: appOriginEnum,
      );
      return QuickFixLoadedState(res, condominiumId);
    });

    emit(resultYield);
  }

  void _onSessionChanged() {
    if (sessionBloc?.condominiumId != null) {
      add(QuickFixLoadEvent(condominiumId: sessionBloc!.condominiumId));
    }
  }

  void beginLoad() {
    if (!(state is QuickFixLoadingState)) {
      add(QuickFixLoadEvent(condominiumId: state.condominiumId!));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
