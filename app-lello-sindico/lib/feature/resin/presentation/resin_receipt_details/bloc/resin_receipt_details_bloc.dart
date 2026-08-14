import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/resin/presentation/resin_receipt_details/bloc/resin_receipt_details_event.dart';
import 'package:lello/feature/resin/presentation/resin_receipt_details/bloc/resin_receipt_details_state.dart';

class ResinReceiptDetailsBloc
    extends Bloc<ResinReceiptDetailsEvent, ResinReceiptDetailsState> {
  ResinReceiptDetailsBloc() : super(ResinReceiptDetailsLoadingState()) {
    on<ResinReceiptDetailsLoadingEvent>(handleReceiptDetailsLoadingEvent);
    on<ResinReceiptDetailsLoadedEvent>(handleReceiptDetailsLoadedEvent);
    on<ResinReceiptDetailsErrorEvent>(handleReceiptDetailsErrorEvent);
  }

  void handleReceiptDetailsLoadingEvent(
          ResinReceiptDetailsLoadingEvent event, Emitter emit) =>
      emit(ResinReceiptDetailsLoadingState());

  void handleReceiptDetailsLoadedEvent(
          ResinReceiptDetailsLoadedEvent event, Emitter emit) =>
      emit(ResinReceiptDetailsLoadedState(
          refund: event.refund, flushbarMessageKey: event.flushbarMessageKey));

  void handleReceiptDetailsErrorEvent(
          ResinReceiptDetailsErrorEvent event, Emitter emit) =>
      emit(ResinReceiptDetailsErrorState(
          errorMessageKey: event.errorMessageKey));
}
