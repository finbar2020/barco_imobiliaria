import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/payroll/presentation/bloc/payroll_entry/payroll_entry_event.dart';
import 'package:lello/feature/payroll/presentation/bloc/payroll_entry/payroll_entry_state.dart';

class PayrollEntryBloc extends Bloc<PayrollEntryEvent, PayrollEntryState> {
  PayrollEntryBloc() : super(PayrollEntryEmptyState()) {
    on<PayrollEntryLoadingEvent>(handlePayrollEntryLoadingEvent);
    on<PayrollEntryLoadFailedEvent>(handlePayrollEntryLoadFailedEvent);
    on<PayrollEntryLoadedEvent>(handlePayrollEntryLoadedEvent);
  }

  void handlePayrollEntryLoadingEvent(
      PayrollEntryLoadingEvent event, Emitter emit) {
    emit(PayrollEntryLoadingState());
  }

  void handlePayrollEntryLoadFailedEvent(
      PayrollEntryLoadFailedEvent event, Emitter emit) {
    emit(PayrollEntryLoadFailedState(error: event.error));
  }

  void handlePayrollEntryLoadedEvent(
      PayrollEntryLoadedEvent event, Emitter emit) {
    emit(PayrollEntryLoadedState(payrollEntry: event.payrollEntry));
  }
}
