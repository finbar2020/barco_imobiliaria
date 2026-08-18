import 'dart:async';

import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/domain/entity/employee.dart';
import 'package:lello/feature/gdp/domain/entity/employee_list_filter.dart';
import 'package:lello/feature/gdp/domain/use_case/list_employee/list_employee.dart';
import 'package:lello/feature/gdp/payslip/presentation/bloc/employees/payslip_employees_bloc.dart';
import 'package:lello/feature/gdp/payslip/presentation/bloc/employees/payslip_employees_event.dart';
import 'package:lello/feature/gdp/payslip/presentation/bloc/employees/payslip_employees_state.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';

class PayslipEmployeesBlocImpl extends PayslipEmployeesBloc {
  final SessionBloc sessionBloc;
  final ListEmployee listEmployee;
  var loadedCache = false;
  String? pendingSearch;

  StreamSubscription? _subscription;

  PayslipEmployeesBlocImpl(
      {required this.sessionBloc, required this.listEmployee})
      : super(PayslipEmployeesLoadingState([], null, null, null)) {
    if (sessionBloc.state is SessionLoadedState) {
      _onSessionChanged(sessionBloc.state);
    } else {
      _subscription = sessionBloc.stream.listen(_onSessionChanged);
    }
  }

  @override
  Stream<PayslipEmployeesState> mapEventToState(
      PayslipEmployeesEvent event) async* {
    if (event is PayslipEmployeesLoadEvent) yield* _mapLoad(event);
    if (event is PayslipEmployeesSearchEvent) yield* _mapSearch(event);
    if (event is PayslipEmployeesNextPageEvent) yield* _mapNextPage(event);
  }

  EmployeeListFilter _getFilter(String? query) {
    return EmployeeListFilter()..name = query;
  }

  Stream<PayslipEmployeesState> _mapLoad(
      PayslipEmployeesLoadEvent event) async* {
    final query = state.query;
    final selectedMonth = state.selectedMonth;
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

    yield PayslipEmployeesLoadingState(
        data, query, condominiumId, selectedMonth);

    final result = await listEmployee.call(ListEmployeeParam(
        condominiumId: condominiumId,
        lastEmployeeId: null,
        filter: filter,
        origin: DataOrigin.remote));
    yield result.fold(
        (err) => PayslipEmployeesLoadFailedState(
            data, query, condominiumId, selectedMonth ?? DateTime.now(), err),
        (data) {
      return PayslipEmployeesLoadedState(
          data, query, condominiumId, selectedMonth, data.isEmpty);
    });
  }

  Stream<PayslipEmployeesState> _mapNextPage(
      PayslipEmployeesNextPageEvent event) async* {
    final query = state.query;
    final selectedMonth = state.selectedMonth;
    final condominiumId = state.condominiumId;
    final data = state.data;
    final lastPayslipId = data.isNotEmpty ? data.last.id : "";
    yield PayslipEmployeesPagingState(
        data, query, condominiumId!, selectedMonth!);
    final filter = _getFilter(query);
    filter.conditionName = "ativo";

    final result = await listEmployee.call(ListEmployeeParam(
        condominiumId: condominiumId,
        lastEmployeeId: lastPayslipId,
        filter: filter,
        origin: DataOrigin.remote));
    yield result.fold(
        (err) => PayslipEmployeesPageFailedState(
            data, query, condominiumId, selectedMonth, err),
        (res) => PayslipEmployeesLoadedState(
            data + res, query, condominiumId, selectedMonth, res.isEmpty));
  }

  Stream<PayslipEmployeesState> _mapSearch(
      PayslipEmployeesSearchEvent event) async* {
    final condominiumId = state.condominiumId;
    final selectedMonth = state.selectedMonth;
    final data = state.data;
    yield PayslipEmployeesSearchingState(
        data, event.query, condominiumId!, selectedMonth!);

    final result = await listEmployee.call(ListEmployeeParam(
        condominiumId: condominiumId,
        lastEmployeeId: null,
        filter: _getFilter(event.query),
        origin: DataOrigin.remote));
    yield result.fold(
        (err) => PayslipEmployeesLoadFailedState(
            data, event.query, condominiumId, selectedMonth, err),
        (data) => PayslipEmployeesLoadedState(
            data, event.query, condominiumId, selectedMonth, data.isEmpty));

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
        add(PayslipEmployeesLoadEvent(condominiumId: condominium.id));
      }
    }
  }

  @override
  void beginSearch(String query, {bool force = false}) {
    if (!force &&
        (state is PayslipEmployeesSearchingState ||
            state is PayslipEmployeesLoadingState ||
            state is PayslipEmployeesPagingState)) {
      pendingSearch = query;
    } else {
      add(PayslipEmployeesSearchEvent(query: query));
    }
  }

  @override
  void beginRefresh() {
    if (state is! PayslipEmployeesLoadingState &&
        state is! PayslipEmployeesPagingState) {
      add(PayslipEmployeesLoadEvent(condominiumId: state.condominiumId!));
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
    if (current is! PayslipEmployeesLoadingState &&
        current is! PayslipEmployeesPagingState) {
      if (current is PayslipEmployeesLoadedState && current.donePaging) return;
      add(PayslipEmployeesNextPageEvent());
    }
  }
}
