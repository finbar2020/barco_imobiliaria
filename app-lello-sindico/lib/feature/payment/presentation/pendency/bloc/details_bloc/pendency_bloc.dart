import 'dart:core';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/payment/presentation/pendency/bloc/details_bloc/pendency_event.dart';
import 'package:lello/feature/payment/presentation/pendency/bloc/details_bloc/pendency_state.dart';

class PendencyBloc extends Bloc<PendencyEvent, PendencyState> {
  PendencyBloc() : super(PendencyEmptyState()) {
    on<PendencyEmptyEvent>(handlePendencyEmptyEvent);
    on<PendencyLoadingEvent>(handlePendencyLoadingEvent);
    on<PendencySuccessEvent>(handlePendencySuccessEvent);
    on<PendencyBalanceLoadingEvent>(handlePendencyBalanceLoadingEvent);
    on<PendencyBalanceSuccessEvent>(handlePendencyBalanceSuccessEvent);
    on<PendencyBalanceFailedEvent>(handlePendencyBalanceFailedEvent);
    on<PendencyLoadingFailedEvent>(handlePendencyLoadingFailedEvent);
    on<ApprovementPaymentPendencyEvent>(handleApprovementPaymentPendencyEvent);
    on<ApprovementPaymentPendencySuccedEvent>(
        handleApprovementPaymentPendencySuccedEvent);
    on<ApprovementPaymentPendencyFailedEvent>(
        handleApprovementPaymentPendencyFailedEvent);
    on<PendencySupplierResetEvent>(handlePendencySupplierResetEvent);
    on<PendencySupplierLoadingEvent>(handlePendencySupplierLoadingEvent);
    on<PendencySupplierSuccessEvent>(handlePendencySupplierSuccessEvent);
    on<PendencySupplierFailedEvent>(handlePendencySupplierFailedEvent);
    on<UpdateLedgerAccountLoadingEvent>(handleUpdateLedgerAccountLoadingEvent);
    on<UpdateLedgerAccountFailureEvent>(handleUpdateLedgerAccountFailureEvent);
    on<UpdateLedgerAccountSuccessEvent>(handleUpdateLedgerAccountSuccessEvent);
  }

  void handlePendencyEmptyEvent(PendencyEmptyEvent event, Emitter emit) =>
      emit(PendencyEmptyState());

  void handlePendencyLoadingEvent(PendencyLoadingEvent event, Emitter emit) =>
      emit(PendencyLoadingState());

  void handlePendencySupplierResetEvent(
          PendencySupplierResetEvent event, Emitter emit) =>
      emit(PendencySupplierResetState());

  void handlePendencyBalanceLoadingEvent(
          PendencyBalanceLoadingEvent event, Emitter emit) =>
      emit(PendencyBalanceLoadingState());

  void handlePendencyBalanceSuccessEvent(
          PendencyBalanceSuccessEvent event, Emitter emit) =>
      emit(PendencyBalanceSuccessState(balance: event.balance));

  void handlePendencyBalanceFailedEvent(
          PendencyBalanceFailedEvent event, Emitter emit) =>
      emit(PendencyBalanceFailedState(error: event.error));

  void handlePendencySupplierLoadingEvent(
          PendencySupplierLoadingEvent event, Emitter emit) =>
      emit(PendencySupplierLoadingState());

  void handlePendencySupplierSuccessEvent(
          PendencySupplierSuccessEvent event, Emitter emit) =>
      emit(PendencySupplierSuccessState(
          supplierLedgerAccounts: event.supplierLedgerAccounts));

  void handlePendencySupplierFailedEvent(
          PendencySupplierFailedEvent event, Emitter emit) =>
      emit(PendencySupplierFailedState(error: event.error));

  void handlePendencySuccessEvent(PendencySuccessEvent event, Emitter emit) =>
      emit(PendencySuccessState(payment: event.payment));

  void handlePendencyLoadingFailedEvent(
          PendencyLoadingFailedEvent event, Emitter emit) =>
      emit(PendencyLoadingFailedState(error: event.error));

  void handleApprovementPaymentPendencyEvent(
          ApprovementPaymentPendencyEvent event, Emitter emit) =>
      emit(ApprovementPaymentPendencyEvent());

  void handleApprovementPaymentPendencySuccedEvent(
          ApprovementPaymentPendencySuccedEvent event, Emitter emit) =>
      emit(ApprovementPaymentPendencySuccedState(approval: event.approval));

  void handleApprovementPaymentPendencyFailedEvent(
          ApprovementPaymentPendencyFailedEvent event, Emitter emit) =>
      emit(ApprovementPaymentPendencyFailedState(error: event.error));

  void handleUpdateLedgerAccountLoadingEvent(
          UpdateLedgerAccountLoadingEvent event, Emitter emit) =>
      emit(UpdateLedgerAccountLoadingState());

  void handleUpdateLedgerAccountFailureEvent(
          UpdateLedgerAccountFailureEvent event, Emitter emit) =>
      emit(UpdateLedgerAccountFailureState(error: event.error));

  void handleUpdateLedgerAccountSuccessEvent(
          UpdateLedgerAccountSuccessEvent event, Emitter emit) =>
      emit(UpdateLedgerAccountSuccessState(success: event.success));
}
