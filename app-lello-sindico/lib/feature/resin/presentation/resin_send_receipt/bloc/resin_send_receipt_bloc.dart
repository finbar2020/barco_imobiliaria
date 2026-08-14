import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/resin/presentation/resin_send_receipt/bloc/resin_send_receipt_event.dart';
import 'package:lello/feature/resin/presentation/resin_send_receipt/bloc/resin_send_receipt_state.dart';

class ResinSendReceiptBloc
    extends Bloc<ResinSendReceiptEvent, ResinSendReceiptState> {
  ResinSendReceiptBloc() : super(ResinSendReceiptLoadingState()) {
    on<ResinSendReceiptLoadingEvent>(handleSendReceiptLoadingEvent);
    on<ResinSendReceiptSuccessEvent>(handleSendReceiptSuccessEvent);
    on<ResinSendReceiptErrorEvent>(handleSendReceiptErrorEvent);
  }

  void handleSendReceiptLoadingEvent(
          ResinSendReceiptLoadingEvent event, Emitter emit) =>
      emit(ResinSendReceiptLoadingState());

  void handleSendReceiptSuccessEvent(
          ResinSendReceiptSuccessEvent event, Emitter emit) =>
      emit(ResinSendReceiptLoadedState(
        refunds: event.refunds,
        loadingRemote: event.loadingRemote,
      ));

  void handleSendReceiptErrorEvent(
          ResinSendReceiptErrorEvent event, Emitter emit) =>
      emit(ResinSendReceiptErrorState(
        errorMessageKey: event.errorMessageKey,
      ));
}
