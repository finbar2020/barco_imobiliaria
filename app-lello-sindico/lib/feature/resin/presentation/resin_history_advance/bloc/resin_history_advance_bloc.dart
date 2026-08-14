import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/resin/presentation/resin_history_advance/bloc/resin_history_advance_event.dart';
import 'package:lello/feature/resin/presentation/resin_history_advance/bloc/resin_history_advance_state.dart';

class ResinHistoryAdvanceBloc
    extends Bloc<ResinHistoryAdvanceEvent, ResinHistoryAdvanceState> {
  ResinHistoryAdvanceBloc() : super(ResinHistoryAdvanceLoadingState()) {
    on<ResinHistoryAdvanceLoadingEvent>(handleHistoryLoadingEvent);
    on<ResinHistoryAdvanceLoadedEvent>(handleHistoryLoadedEvent);
    on<ResinHistoryAdvanceErrorEvent>(handleHistoryErrorEvent);
    on<ResinHistoryAdvanceDeleteLoadingEvent>(handleHistoryDeleteLoadingEvent);
    on<ResinAdvanceDetailsLoadedEvent>(handleDetailsLoadedEvent);
  }

  void handleHistoryLoadingEvent(
          ResinHistoryAdvanceLoadingEvent event, Emitter emit) =>
      emit(ResinHistoryAdvanceLoadingState());

  void handleHistoryLoadedEvent(
          ResinHistoryAdvanceLoadedEvent event, Emitter emit) =>
      emit(ResinHistoryAdvanceLoadedState(
        refunds: event.refunds,
        flushbarMessageKey: event.flushbarMessageKey,
        loadingRemote: event.loadingRemote,
        updateRefunds: event.updateRefunds,
      ));

  void handleHistoryErrorEvent(
          ResinHistoryAdvanceErrorEvent event, Emitter emit) =>
      emit(ResinHistoryAdvanceErrorState(
          errorMessageKey: event.errorMessageKey));

  void handleHistoryDeleteLoadingEvent(
          ResinHistoryAdvanceDeleteLoadingEvent event, Emitter emit) =>
      emit(ResinDeleteHistoryAdvanceLoadingState());

  void handleDetailsLoadedEvent(
          ResinAdvanceDetailsLoadedEvent event, Emitter emit) =>
      emit(ResinAdvanceDetailsLoadedState(event.refund));
}
