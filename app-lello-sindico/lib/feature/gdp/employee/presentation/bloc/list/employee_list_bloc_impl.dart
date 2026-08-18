import 'dart:async';

import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/core/analytics/analytics_log_events.dart';
import 'package:lello/feature/gdp/domain/entity/employee.dart';
import 'package:lello/feature/gdp/domain/entity/employee_list_filter.dart';
import 'package:lello/feature/gdp/domain/use_case/list_employee/list_employee.dart';
import 'package:lello/feature/gdp/employee/presentation/bloc/list/employee_list_bloc.dart';
import 'package:lello/feature/gdp/employee/presentation/bloc/list/employee_list_event.dart';
import 'package:lello/feature/gdp/employee/presentation/bloc/list/employee_list_state.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';

class EmployeeListBlocImpl extends EmployeeListBloc {
  final SessionBloc sessionBloc;
  final ListEmployee listEmployee;
  var loadedCache = false;

  StreamSubscription? _subscription;

  EmployeeListBlocImpl({required this.sessionBloc, required this.listEmployee})
      : super(
          EmployeeListLoadingState(
            [],
            null,
            EmployeeListFilter(conditionName: 'ativo'),
          ),
        ) {
    if (sessionBloc.state is SessionLoadedState) {
      _onSessionChanged(sessionBloc.state);
    } else {
      _subscription = sessionBloc.stream.listen(_onSessionChanged);
    }
  }

  @override
  Stream<EmployeeListState> mapEventToState(EmployeeListEvent event) async* {
    if (event is EmployeeListLoadEvent) yield* _mapLoad(event);
    if (event is EmployeeListNextPageEvent) yield* _mapNextPage(event);
  }

  Stream<EmployeeListState> _mapLoad(EmployeeListLoadEvent event) async* {
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

    yield EmployeeListLoadingState(data, condominiumId, event.filter);

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
      }
      ManagerAnalyticsLogEvents.logEvent(
          event: AnalyticsEventsManager.dadosEquipeAcessar(),
          referenceValue: sessionBloc
                  .state.session?.selectedCondominium?.reference
                  .toString() ??
              "");
      return EmployeeListLoadedState(
          formatedData, condominiumId, event.filter, data.isEmpty);
    });

    yield resultYield;
  }

  Stream<EmployeeListState> _mapNextPage(
      EmployeeListNextPageEvent event) async* {
    final condominiumId = state.condominiumId;
    final filter = state.filter;
    final data = state.data;
    final lastEmployeeId = data.isNotEmpty ? data.last.id : "";
    yield EmployeeListPagingState(data, condominiumId!, filter);

    final result = await listEmployee.call(ListEmployeeParam(
        condominiumId: condominiumId,
        lastEmployeeId: lastEmployeeId,
        origin: DataOrigin.remote,
        filter: filter));
    yield result.fold(
        (err) => EmployeeListPageFailedState(data, condominiumId, filter, err),
        (res) => EmployeeListLoadedState(
            data + res, condominiumId, filter, res.isEmpty));
  }

  void _onSessionChanged(SessionState sessionState) {
    if (sessionState is SessionLoadedState) {
      final condominium = sessionState.session?.selectedCondominium;
      if (condominium != null) {
        add(EmployeeListLoadEvent(
            condominiumId: condominium.id, filter: state.filter));
      }
    }
  }

  @override
  void beginRefresh() {
    if (state is! EmployeeListLoadingState &&
        state is! EmployeeListPagingState) {
      add(EmployeeListLoadEvent(
          condominiumId: state.condominiumId!, filter: state.filter));
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
    if (current is! EmployeeListLoadingState &&
        current is! EmployeeListPagingState) {
      if (current is EmployeeListLoadedState && current.donePaging) return;
      add(EmployeeListNextPageEvent());
    }
  }

  @override
  void beginFilter(EmployeeListFilter filter) {
    add(EmployeeListLoadEvent(
        condominiumId: state.condominiumId!, filter: filter));
  }
}
