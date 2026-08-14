import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morar/feature/billets/presentation/bloc/billets_event.dart';
import 'package:morar/feature/billets/presentation/bloc/billets_state.dart';

class BilletsBloc extends Bloc {
  BilletsBloc() : super(const BilletsInitialState()) {
    on<BilletsEmptyEvent>(handleBilletsEmptyEvent);
    on<BilletsLoadingEvent>(handleBilletsLoadingEvent);
    on<BilletsFailureEvent>(handleBilletsFailureEvent);
    on<BilletsLoadedEvent>(handleBilletsLoadedEvent);
    on<BilletsShowInfoEvent>(handleBilletsShowInfoEvent);
  }

  void handleBilletsEmptyEvent(BilletsEmptyEvent event, Emitter emit) {
    emit(const BilletsInitialState());
  }

  void handleBilletsLoadingEvent(BilletsLoadingEvent event, Emitter emit) {
    emit(BilletsLoadingState(billet: event.billet));
  }

  void handleBilletsFailureEvent(BilletsFailureEvent event, Emitter emit) {
    emit(BilletsFailureState(
        errorMessageKey: event.error, billet: event.billet));
  }

  void handleBilletsLoadedEvent(BilletsLoadedEvent event, Emitter emit) {
    emit(BilletsLoadedState(
        billets: event.billets, allBillets: event.allBillets));
  }

  void handleBilletsShowInfoEvent(BilletsShowInfoEvent event, Emitter emit) {
    emit(BilletsShowInfoState(
        billet: event.billet, pdf: event.pdf, fileName: event.fileName));
  }
}
