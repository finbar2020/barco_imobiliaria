import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/income/presentation/billets/bloc/billets_event.dart';

import 'billets_state.dart';

class BilletsBloc extends Bloc<BilletsEvent, BilletsState> {
  BilletsBloc() : super(BilletsEmptyState()) {
    on<BilletsEmptyEvent>(handleBilletsEmptyEvent);
    on<BilletsSearchingEvent>(handleBilletsSearchingEvent);
    on<BilletsLoadingEvent>(handleBilletsLoadingEvent);
    on<UnitsLoadingEvent>(handleUnitsLoadingEvent);
    on<BilletsLoadFailedEvent>(handleBilletsLoadFailedEvent);
    on<BilletsPagingEvent>(handleBilletsPagingEvent);
    on<BilletsPageFailedEvent>(handleBilletsPageFailedEvent);
    on<BilletsLoadedEvent>(handleBilletsLoadedEvent);
  }

  void handleBilletsEmptyEvent(BilletsEmptyEvent event, Emitter emit) {
    emit(BilletsEmptyState());
  }

  void handleBilletsSearchingEvent(BilletsSearchingEvent event, Emitter emit) {
    emit(BilletsSearchingState());
  }

  void handleBilletsLoadingEvent(BilletsLoadingEvent event, Emitter emit) {
    emit(BilletsLoadingState(units: event.units));
  }

  void handleUnitsLoadingEvent(UnitsLoadingEvent event, Emitter emit) {
    emit(UnitsLoadingState(units: event.units));
  }

  void handleBilletsLoadFailedEvent(
      BilletsLoadFailedEvent event, Emitter emit) {
    emit(BilletsLoadFailedState(error: event.error));
  }

  void handleBilletsPagingEvent(BilletsPagingEvent event, Emitter emit) {
    emit(BilletsPagingState(units: event.units));
  }

  void handleBilletsPageFailedEvent(
      BilletsPageFailedEvent event, Emitter emit) {
    emit(BilletsPageFailedState(error: event.error));
  }

  void handleBilletsLoadedEvent(BilletsLoadedEvent event, Emitter emit) {
    emit(BilletsLoadedState(units: event.units));
  }
}
