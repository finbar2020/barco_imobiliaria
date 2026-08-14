import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/resin/presentation/resin_history_refund/bloc/resin_history_refund_event.dart';
import 'package:lello/feature/resin/presentation/resin_history_refund/bloc/resin_history_refund_state.dart';

class ResinHistoryRefundBloc
    extends Bloc<ResinHistoryRefundEvent, ResinHistoryRefundState> {
  ResinHistoryRefundBloc() : super(ResinHistoryRefundLoadingState()) {
    on<ResinHistoryRefundLoadingEvent>(handleHistoryLoadingEvent);
    on<ResinHistoryRefundLoadedEvent>(handleHistoryLoadedEvent);
    on<ResinHistoryRefundErrorEvent>(handleHistoryErrorEvent);
    on<ResinHistoryRefundDeleteLoadingEvent>(handleHistoryDeleteLoadingEvent);
    on<ResinRefundDetailsLoadedEvent>(handleDetailsLoadedEvent);
  }

  void handleHistoryLoadingEvent(
          ResinHistoryRefundLoadingEvent event, Emitter emit) =>
      emit(ResinHistoryRefundLoadingState());

  void handleHistoryLoadedEvent(
          ResinHistoryRefundLoadedEvent event, Emitter emit) =>
      emit(ResinHistoryRefundLoadedState(
        refunds: event.refunds,
        flushbarMessageKey: event.flushbarMessageKey,
        loadingRemote: event.loadingRemote,
        updateRefunds: event.updateRefunds,
      ));

  void handleHistoryErrorEvent(
          ResinHistoryRefundErrorEvent event, Emitter emit) =>
      emit(
          ResinHistoryRefundErrorState(errorMessageKey: event.errorMessageKey));

  void handleHistoryDeleteLoadingEvent(
          ResinHistoryRefundDeleteLoadingEvent event, Emitter emit) =>
      emit(ResinDeleteHistoryRefundLoadingState());

  void handleDetailsLoadedEvent(
          ResinRefundDetailsLoadedEvent event, Emitter emit) =>
      emit(ResinRefundDetailsLoadedState(event.refund));
}
