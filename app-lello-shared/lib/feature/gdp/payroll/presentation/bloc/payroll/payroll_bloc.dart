import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_features/feature/gdp/payroll/domain/use_case/get_payroll/get_payroll.dart';
import 'package:shared_features/feature/gdp/payroll/domain/use_case/list_payroll/list_payroll.dart';
import 'package:shared_features/feature/gdp/payroll/presentation/bloc/payroll/payroll_event.dart';
import 'package:shared_features/feature/gdp/payroll/presentation/bloc/payroll/payroll_state.dart';
import 'package:shared_features/shared_features.dart';

class PayrollBloc extends Bloc<PayrollEvent, PayrollState> {
  final SharedSession? sessionBloc;
  final GetPayroll getPayroll;
  final ListPayroll listPayroll;

  StreamSubscription? _subscription;
  DateTime? _pendingPeriod;

  PayrollBloc(
      {required this.sessionBloc,
      required this.getPayroll,
      required this.listPayroll})
      : super(const PayrollLoadingState([], null, null)) {
    on<PayrollLoadListEvent>(_mapLoadList);
    on<PayrollLoadEvent>(_mapLoad);
    _onSessionChanged();
  }

  Future<void> _mapLoadList(
    PayrollLoadListEvent event,
    Emitter<PayrollState> emit,
  ) async {
    final condominiumId = event.condominiumId;

    emit(PayrollLoadingState(state.data, state.detail, condominiumId));

    final result =
        await listPayroll.call(ListPayrollParam(condominiumId: condominiumId));
    emit(result.fold(
        (err) => PayrollLoadFailedState(
            state.data, state.detail, condominiumId, err),
        (res) => PayrollListLoadedState(res, condominiumId)));
  }

  Future<void> _mapLoad(
    PayrollLoadEvent event,
    Emitter<PayrollState> emit,
  ) async {
    final condominiumId = event.condominiumId;
    final detail = state.detail;
    final data = state.data;

    emit(PayrollLoadingState(data, detail, condominiumId));

    final result = await getPayroll.call(
        GetPayrollParam(condominiumId: condominiumId, period: event.period));
    emit(result.fold(
        (err) => PayrollLoadFailedState(data, detail, condominiumId, err),
        (res) => PayrollLoadedState(data, res, condominiumId)));
  }

  void _onSessionChanged() {
    final condominiumId = sessionBloc?.condominiumId ?? "";
    add(PayrollLoadListEvent(condominiumId: condominiumId));

    if (_pendingPeriod != null) {
      beginLoad(_pendingPeriod!);
    }
  }

  void beginLoad(DateTime period) {
    final condominiumId = sessionBloc?.condominiumId ?? "";
    add(PayrollLoadEvent(condominiumId: condominiumId, period: period));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
