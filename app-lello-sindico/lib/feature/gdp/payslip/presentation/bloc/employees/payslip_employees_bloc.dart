import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/domain/entity/employee.dart';
import 'package:lello/feature/gdp/domain/entity/employee_list_filter.dart';
import 'package:lello/feature/gdp/domain/use_case/list_employee/list_employee.dart';
import 'package:lello/feature/gdp/payslip/presentation/bloc/employees/payslip_employees_event.dart';
import 'package:lello/feature/gdp/payslip/presentation/bloc/employees/payslip_employees_state.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';

class PayslipEmployeesBloc
    extends Bloc<PayslipEmployeesEvent, PayslipEmployeesState> {
  final SessionBloc sessionBloc;
  final ListEmployee listEmployee;
  var loadedCache = false;
  String? pendingSearch;

  StreamSubscription? _subscription;

  PayslipEmployeesBloc(
      {required this.sessionBloc, required this.listEmployee})
      : super(const PayslipEmployeesLoadingState([], null, null, null)) {
    on<PayslipEmployeesLoadEvent>(_mapLoad);
    on<PayslipEmployeesSearchEvent>(_mapSearch);
    on<PayslipEmployeesNextPageEvent>(_mapNextPage);
    on<PayslipEmployeesSetMonthEvent>(_mapSetMonth);
    if (sessionBloc.state is SessionLoadedState) {
      _onSessionChanged(sessionBloc.state);
    } else {
      _subscription = sessionBloc.stream.listen(_onSessionChanged);
    }
  }

  EmployeeListFilter _getFilter(String? query) {
    return EmployeeListFilter()..name = query;
  }

  Future<void> _mapLoad(
    PayslipEmployeesLoadEvent event,
    Emitter<PayslipEmployeesState> emit,
  ) async {
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

    emit(PayslipEmployeesLoadingState(
        data, query, condominiumId, selectedMonth));

    final result = await listEmployee.call(ListEmployeeParam(
        condominiumId: condominiumId,
        lastEmployeeId: null,
        filter: filter,
        origin: DataOrigin.remote));
    emit(result.fold(
        (err) => PayslipEmployeesLoadFailedState(
            data, query, condominiumId, selectedMonth ?? DateTime.now(), err),
        (data) {
      return PayslipEmployeesLoadedState(
          data, query, condominiumId, selectedMonth, data.isEmpty);
    }));
  }

  Future<void> _mapNextPage(
    PayslipEmployeesNextPageEvent event,
    Emitter<PayslipEmployeesState> emit,
  ) async {
    final query = state.query;
    final selectedMonth = state.selectedMonth;
    final condominiumId = state.condominiumId;
    final data = state.data;
    final lastPayslipId = data.isNotEmpty ? data.last.id : "";
    emit(PayslipEmployeesPagingState(
        data, query, condominiumId!, selectedMonth!));
    final filter = _getFilter(query);
    filter.conditionName = "ativo";

    final result = await listEmployee.call(ListEmployeeParam(
        condominiumId: condominiumId,
        lastEmployeeId: lastPayslipId,
        filter: filter,
        origin: DataOrigin.remote));
    emit(result.fold(
        (err) => PayslipEmployeesPageFailedState(
            data, query, condominiumId, selectedMonth, err),
        (res) => PayslipEmployeesLoadedState(
            data + res, query, condominiumId, selectedMonth, res.isEmpty)));
  }

  Future<void> _mapSearch(
    PayslipEmployeesSearchEvent event,
    Emitter<PayslipEmployeesState> emit,
  ) async {
    final condominiumId = state.condominiumId;
    final selectedMonth = state.selectedMonth;
    final data = state.data;
    emit(PayslipEmployeesSearchingState(
        data, event.query, condominiumId!, selectedMonth!));

    final result = await listEmployee.call(ListEmployeeParam(
        condominiumId: condominiumId,
        lastEmployeeId: null,
        filter: _getFilter(event.query),
        origin: DataOrigin.remote));
    emit(result.fold(
        (err) => PayslipEmployeesLoadFailedState(
            data, event.query, condominiumId, selectedMonth, err),
        (data) => PayslipEmployeesLoadedState(
            data, event.query, condominiumId, selectedMonth, data.isEmpty)));

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

  Future<void> _mapSetMonth(
    PayslipEmployeesSetMonthEvent event,
    Emitter<PayslipEmployeesState> emit,
  ) async {
    if (state.selectedMonth != null) return;
    emit(PayslipEmployeesLoadingState(
      state.data,
      state.query,
      state.condominiumId,
      event.selectedMonth,
    ));
  }

  void setSelectedMonth(DateTime month) {
    if (state.selectedMonth == null) {
      add(PayslipEmployeesSetMonthEvent(selectedMonth: month));
    }
  }

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

  void beginLoadNextPage() {
    final current = state;
    if (current is! PayslipEmployeesLoadingState &&
        current is! PayslipEmployeesPagingState) {
      if (current is PayslipEmployeesLoadedState && current.donePaging) return;
      add(PayslipEmployeesNextPageEvent());
    }
  }
}
