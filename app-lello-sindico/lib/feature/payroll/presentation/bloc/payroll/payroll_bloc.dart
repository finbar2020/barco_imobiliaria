import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/payroll/presentation/bloc/payroll/payroll_event.dart';
import 'package:lello/feature/payroll/presentation/bloc/payroll/payroll_state.dart';

class PayrollBloc extends Bloc<PayrollEvent, PayrollState> {
  PayrollBloc() : super(PayrollEmptyState()) {
    on<PayrollsListLoadingEvent>(handlePayrollsListLoadingEvent);
    on<PayrollDetailLoadingEvent>(handlePayrollDetailLoadingEvent);
    on<PayrollsListlLoadFailedEvent>(handlePayrollsListlLoadFailedEvent);
    on<PayrollDetailLoadFailedEvent>(handlePayrollDetailLoadFailedEvent);
    on<PayrollsListLoadedEvent>(handlePayrollsListLoadedEvent);
    on<PayrollDetailLoadedEvent>(handlePayrollDetailLoadedEvent);
  }

  void handlePayrollsListLoadingEvent(
      PayrollsListLoadingEvent event, Emitter emit) {
    emit(
      PayrollsListLoadingState(),
    );
  }

  void handlePayrollDetailLoadingEvent(
      PayrollDetailLoadingEvent event, Emitter emit) {
    emit(
      PayrollDetailLoadingState(),
    );
  }

  void handlePayrollsListlLoadFailedEvent(
      PayrollsListlLoadFailedEvent event, Emitter emit) {
    emit(
      PayrollsListLoadFailedState(error: event.error),
    );
  }

  void handlePayrollDetailLoadFailedEvent(
      PayrollDetailLoadFailedEvent event, Emitter emit) {
    emit(
      PayrollsListLoadFailedState(error: event.error),
    );
  }

  void handlePayrollsListLoadedEvent(
      PayrollsListLoadedEvent event, Emitter emit) {
    emit(
      PayrollsListLoadedState(payrolls: event.payrolls ?? []),
    );
  }

  void handlePayrollDetailLoadedEvent(
      PayrollDetailLoadedEvent event, Emitter emit) {
    emit(
      PayrollDetailLoadedState(payroll: event.payroll),
    );
  }
}
