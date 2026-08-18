import 'dart:async';

import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/domain/entity/employee.dart';
import 'package:lello/feature/gdp/domain/entity/employee_list_filter.dart';
import 'package:lello/feature/gdp/domain/use_case/list_employee/list_employee.dart';
import 'package:lello/feature/gdp/vacation/presentation/bloc/employees/vacation_employees_bloc.dart';
import 'package:lello/feature/gdp/vacation/presentation/bloc/employees/vacation_employees_event.dart';
import 'package:lello/feature/gdp/vacation/presentation/bloc/employees/vacation_employees_state.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';

class VacationEmployeesBlocImpl extends VacationEmployeesBloc {
  final SessionBloc sessionBloc;
  final ListEmployee listEmployee;
  var loadedCache = false;
  String? pendingSearch;

  StreamSubscription? _subscription;

  VacationEmployeesBlocImpl(
      {required this.sessionBloc, required this.listEmployee})
      : super(VacationEmployeesLoadingState([])) {
    if (sessionBloc.state is SessionLoadedState) {
      _onSessionChanged(sessionBloc.state);
    } else {
      _subscription = sessionBloc.stream.listen(_onSessionChanged);
    }
  }

  @override
  Stream<VacationEmployeesState> mapEventToState(
      VacationEmployeesEvent event) async* {
    if (event is VacationEmployeesLoadEvent) yield* _mapLoad(event);
    if (event is VacationEmployeesSearchEvent) yield* _mapSearch(event);
    if (event is VacationEmployeesNextPageEvent) yield* _mapNextPage(event);
  }

  EmployeeListFilter _getFilter(String query) {
    return EmployeeListFilter()..name = query;
  }

  Stream<VacationEmployeesState> _mapLoad(
      VacationEmployeesLoadEvent event) async* {
    yield VacationEmployeesLoadingState([]);
    final query = state.query;
    final condominiumId = event.condominiumId;
    final filter = _getFilter(query);
    filter.conditionName = "ativo";
    var data = state.data;
    if (!loadedCache) {
      final cache = await listEmployee.call(ListEmployeeParam(
          condominiumId: condominiumId,
          lastEmployeeId: null,
          filter: filter,
          origin: DataOrigin.local));
      if (cache is Success<List<Employee>>) {
        data = cache.getOrElse(() => []);
      }
      loadedCache = true;
    }

    final result = await listEmployee.call(ListEmployeeParam(
        condominiumId: condominiumId,
        lastEmployeeId: null,
        filter: filter,
        origin: DataOrigin.remote));
    yield result.fold(
        (err) =>
            VacationEmployeesLoadFailedState(data, query, condominiumId, err),
        (data) {
      return VacationEmployeesLoadedState(
          data, query, condominiumId, data.isEmpty);
    });
  }

  Stream<VacationEmployeesState> _mapNextPage(
      VacationEmployeesNextPageEvent event) async* {
    final query = state.query;
    final condominiumId = state.condominiumId;
    final data = state.data;
    final lastVacationId = data.isNotEmpty ? data.last.id : "";
    yield VacationEmployeesPagingState(data, query, condominiumId);
    final filter = _getFilter(query);
    filter.conditionName = "ativo";

    final result = await listEmployee.call(ListEmployeeParam(
        condominiumId: condominiumId,
        lastEmployeeId: lastVacationId,
        filter: filter,
        origin: DataOrigin.remote));
    yield result.fold(
        (err) =>
            VacationEmployeesPageFailedState(data, query, condominiumId, err),
        (res) => VacationEmployeesLoadedState(
            data + res, query, condominiumId, res.isEmpty));
  }

  Stream<VacationEmployeesState> _mapSearch(
      VacationEmployeesSearchEvent event) async* {
    final condominiumId = state.condominiumId;
    final data = state.data;
    yield VacationEmployeesSearchingState(data, event.query, condominiumId);

    final result = await listEmployee.call(ListEmployeeParam(
        condominiumId: condominiumId,
        lastEmployeeId: null,
        filter: _getFilter(event.query),
        origin: DataOrigin.remote));
    yield result.fold(
        (err) => VacationEmployeesLoadFailedState(
            data, event.query, condominiumId, err),
        (data) => VacationEmployeesLoadedState(
            data, event.query, condominiumId, data.isEmpty));

    _handlePendingSearch(event.query);
  }

  void _handlePendingSearch(String query) {
    if (pendingSearch != null) {
      beginSearch(pendingSearch!, force: true);
      if (pendingSearch == query) pendingSearch = null;
    }
  }

  void _onSessionChanged(SessionState sessionState) {
    if (sessionState is SessionLoadedState) {
      final condominium = sessionState.session?.selectedCondominium;
      if (condominium != null) {
        add(VacationEmployeesLoadEvent(condominiumId: condominium.id));
      }
    }
  }

  @override
  void beginSearch(String query, {bool force = false}) {
    if (!force &&
        (state is VacationEmployeesSearchingState ||
            state is VacationEmployeesLoadingState ||
            state is VacationEmployeesPagingState)) {
      pendingSearch = query;
    } else {
      add(VacationEmployeesSearchEvent(query: query));
    }
  }

  @override
  void beginRefresh() {
    if (state is! VacationEmployeesLoadingState &&
        state is! VacationEmployeesPagingState) {
      add(VacationEmployeesLoadEvent(condominiumId: state.condominiumId));
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
    if (current is! VacationEmployeesLoadingState &&
        current is! VacationEmployeesPagingState) {
      if (current is VacationEmployeesLoadedState && current.donePaging) return;
      add(VacationEmployeesNextPageEvent());
    }
  }
}
