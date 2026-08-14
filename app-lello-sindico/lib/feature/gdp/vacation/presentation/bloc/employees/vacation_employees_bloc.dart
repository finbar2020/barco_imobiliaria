import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/domain/entity/employee.dart';
import 'package:lello/feature/gdp/domain/entity/employee_list_filter.dart';
import 'package:lello/feature/gdp/domain/use_case/list_employee/list_employee.dart';
import 'package:lello/feature/gdp/vacation/presentation/bloc/employees/vacation_employees_event.dart';
import 'package:lello/feature/gdp/vacation/presentation/bloc/employees/vacation_employees_state.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';

class VacationEmployeesBloc
    extends Bloc<VacationEmployeesEvent, VacationEmployeesState> {
  final SessionBloc sessionBloc;
  final ListEmployee listEmployee;
  var loadedCache = false;
  String? pendingSearch;

  StreamSubscription? _subscription;

  VacationEmployeesBloc(
      {required this.sessionBloc, required this.listEmployee})
      : super(VacationEmployeesLoadingState([])) {
    on<VacationEmployeesLoadEvent>(_mapLoad);
    on<VacationEmployeesSearchEvent>(_mapSearch);
    on<VacationEmployeesNextPageEvent>(_mapNextPage);
    if (sessionBloc.state is SessionLoadedState) {
      _onSessionChanged(sessionBloc.state);
    } else {
      _subscription = sessionBloc.stream.listen(_onSessionChanged);
    }
  }

  EmployeeListFilter _getFilter(String query) {
    return EmployeeListFilter()..name = query;
  }

  Future<void> _mapLoad(
    VacationEmployeesLoadEvent event,
    Emitter<VacationEmployeesState> emit,
  ) async {
    emit(VacationEmployeesLoadingState([]));
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
    emit(result.fold(
        (err) =>
            VacationEmployeesLoadFailedState(data, query, condominiumId, err),
        (data) {
      return VacationEmployeesLoadedState(
          data, query, condominiumId, data.isEmpty);
    }));
  }

  Future<void> _mapNextPage(
    VacationEmployeesNextPageEvent event,
    Emitter<VacationEmployeesState> emit,
  ) async {
    final query = state.query;
    final condominiumId = state.condominiumId;
    final data = state.data;
    final lastVacationId = data.isNotEmpty ? data.last.id : "";
    emit(VacationEmployeesPagingState(data, query, condominiumId));
    final filter = _getFilter(query);
    filter.conditionName = "ativo";

    final result = await listEmployee.call(ListEmployeeParam(
        condominiumId: condominiumId,
        lastEmployeeId: lastVacationId,
        filter: filter,
        origin: DataOrigin.remote));
    emit(result.fold(
        (err) =>
            VacationEmployeesPageFailedState(data, query, condominiumId, err),
        (res) => VacationEmployeesLoadedState(
            data + res, query, condominiumId, res.isEmpty)));
  }

  Future<void> _mapSearch(
    VacationEmployeesSearchEvent event,
    Emitter<VacationEmployeesState> emit,
  ) async {
    final condominiumId = state.condominiumId;
    final data = state.data;
    emit(VacationEmployeesSearchingState(data, event.query, condominiumId));

    final result = await listEmployee.call(ListEmployeeParam(
        condominiumId: condominiumId,
        lastEmployeeId: null,
        filter: _getFilter(event.query),
        origin: DataOrigin.remote));
    emit(result.fold(
        (err) => VacationEmployeesLoadFailedState(
            data, event.query, condominiumId, err),
        (data) => VacationEmployeesLoadedState(
            data, event.query, condominiumId, data.isEmpty)));

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

  void beginLoadNextPage() {
    final current = state;
    if (current is! VacationEmployeesLoadingState &&
        current is! VacationEmployeesPagingState) {
      if (current is VacationEmployeesLoadedState && current.donePaging) return;
      add(VacationEmployeesNextPageEvent());
    }
  }
}
