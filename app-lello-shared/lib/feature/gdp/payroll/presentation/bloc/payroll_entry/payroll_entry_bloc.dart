import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_features/feature/gdp/payroll/domain/entity/payroll.dart';
import 'package:shared_features/feature/gdp/payroll/domain/use_case/list_payroll_entry/list_payroll_entry.dart';
import 'package:shared_features/feature/gdp/payroll/presentation/bloc/payroll_entry/payroll_entry_event.dart';
import 'package:shared_features/feature/gdp/payroll/presentation/bloc/payroll_entry/payroll_entry_state.dart';
import 'package:shared_features/shared_features.dart';

class PayrollEntryBloc extends Bloc<PayrollEntryEvent, PayrollEntryState> {
  final SharedSession? sessionBloc;
  final ListPayrollEntry listPayrollEntry;

  StreamSubscription? _subscription;

  PayrollEntryBloc({required this.sessionBloc, required this.listPayrollEntry})
      : super(const PayrollEntryLoadingState([], null, null)) {
    on<PayrollEntryLoadEvent>(_mapLoad);
  }

  Future<void> _mapLoad(
    PayrollEntryLoadEvent event,
    Emitter<PayrollEntryState> emit,
  ) async {
    final condominiumId = event.condominiumId;
    final data = state.data;
    final payroll = event.payroll;

    emit(PayrollEntryLoadingState(data, condominiumId, payroll));

    final result = await listPayrollEntry.call(ListPayrollEntryParam(
        condominiumId: condominiumId, period: payroll.period!));
    emit(result.fold(
        (err) => PayrollEntryLoadFailedState(data, condominiumId, payroll, err),
        (res) => PayrollEntryLoadedState(res, condominiumId, payroll)));
  }

  void beginLoad(Payroll payroll) {
    if (sessionBloc?.condominiumId != null) {
      add(PayrollEntryLoadEvent(
          payroll: payroll, condominiumId: sessionBloc!.condominiumId));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
