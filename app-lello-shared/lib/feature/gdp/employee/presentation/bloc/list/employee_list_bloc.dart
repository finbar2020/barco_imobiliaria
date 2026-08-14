import 'dart:async';

import 'package:essentials/analytics/analytics_log_events.dart';
import 'package:essentials/analytics/events/analytics_events_employee.dart';
import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_features/feature/gdp/domain/entity/employee.dart';
import 'package:shared_features/feature/gdp/domain/entity/employee_list_filter.dart';
import 'package:shared_features/feature/gdp/domain/use_case/list_employee/list_employee.dart';
import 'package:shared_features/feature/gdp/employee/presentation/bloc/list/employee_list_event.dart';
import 'package:shared_features/feature/gdp/employee/presentation/bloc/list/employee_list_state.dart';
import 'package:shared_features/shared_features.dart';

class EmployeeListBloc extends Bloc<EmployeeListEvent, EmployeeListState> {
  final SharedSession? sessionBloc;
  final ListEmployee listEmployee;
  var loadedCache = false;
  final AppOriginEnum appOriginEnum;

  StreamSubscription? _subscription;

  EmployeeListBloc(
      {required this.sessionBloc,
      required this.listEmployee,
      required this.appOriginEnum})
      : super(EmployeeListLoadingState(
            const [], null, EmployeeListFilter(conditionName: 'ativo'))) {
    on<EmployeeListLoadEvent>(_mapLoad);
    on<EmployeeListNextPageEvent>(_mapNextPage);
    _onSessionChanged();
  }

  Future<void> _mapLoad(
    EmployeeListLoadEvent event,
    Emitter<EmployeeListState> emit,
  ) async {
    final condominiumId = event.condominiumId;
    var data = state.data;
    if (!loadedCache) {
      final cache = await listEmployee.call(ListEmployeeParam(
          condominiumId: condominiumId,
          lastEmployeeId: null,
          origin: DataOrigin.local,
          filter: event.filter));
      if (cache is Success<List<Employee>>) {
        data = cache.getOrElse(() => []);
      }
      loadedCache = true;
    }

    emit(EmployeeListLoadingState(data, condominiumId, event.filter));

    final result = await listEmployee.call(ListEmployeeParam(
        condominiumId: condominiumId,
        lastEmployeeId: null,
        origin: DataOrigin.remote,
        filter: event.filter));

    var resultYield = result.fold(
        (err) =>
            EmployeeListLoadFailedState(data, condominiumId, event.filter, err),
        (data) {
      List<Employee> formatedData = data;
      if (event.filter.conditionName == null) {
        formatedData =
            data.where((element) => element.status != 'demitido').toList();
        AnalyticsLogEvents.logEvent(
          event: appOriginEnum == AppOriginEnum.manager
              ? AnalyticsEventsManager.dadosEquipeAcessar()
              : AnalyticsEventsEmployee.dadosEquipeAcessar(),
          unitValue: sessionBloc?.unitId.toString() ?? "",
          referenceValue: sessionBloc?.condominiumReference.toString() ?? "",
          appOrigin: appOriginEnum,
        );
      }
      return EmployeeListLoadedState(
          formatedData, condominiumId, event.filter, data.length == 0);
    });

    emit(resultYield);
  }

  Future<void> _mapNextPage(
    EmployeeListNextPageEvent event,
    Emitter<EmployeeListState> emit,
  ) async {
    final condominiumId = state.condominiumId;
    final filter = state.filter;
    final data = state.data;
    final lastEmployeeId = data.length > 0 ? data.last.id : "";
    emit(EmployeeListPagingState(data, condominiumId!, filter));

    final result = await listEmployee.call(ListEmployeeParam(
        condominiumId: condominiumId,
        lastEmployeeId: lastEmployeeId,
        origin: DataOrigin.remote,
        filter: filter));
    emit(result.fold(
        (err) => EmployeeListPageFailedState(data, condominiumId, filter, err),
        (res) => EmployeeListLoadedState(
            data + res, condominiumId, filter, res.length == 0)));
  }

  void _onSessionChanged() {
    if (sessionBloc?.condominiumId != null) {
      add(EmployeeListLoadEvent(
          condominiumId: sessionBloc!.condominiumId, filter: state.filter));
    }
  }

  void beginRefresh() {
    if (!(state is EmployeeListLoadingState) &&
        !(state is EmployeeListPagingState)) {
      add(EmployeeListLoadEvent(
          condominiumId: state.condominiumId!, filter: state.filter));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  void beginLoadNextPage() {
    final current = state;
    if (!(current is EmployeeListLoadingState) &&
        !(current is EmployeeListPagingState)) {
      if (current is EmployeeListLoadedState && current.donePaging) return;
      add(const EmployeeListNextPageEvent());
    }
  }

  void beginFilter(EmployeeListFilter filter) {
    add(EmployeeListLoadEvent(
        condominiumId: state.condominiumId!, filter: filter));
  }
}
