import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/resin/presentation/resin_new_refund/bloc/resin_new_refund_event.dart';
import 'package:lello/feature/resin/presentation/resin_new_refund/bloc/resin_new_refund_state.dart';

class ResinNewRefundBloc
    extends Bloc<ResinNewRefundEvent, ResinNewRefundState> {
  ResinNewRefundBloc() : super(ResinNewRefundLoadingState()) {
    on<ResinNewRefundLoadingEvent>(handleNewRefundLoadingEvent);
    on<ResinNewRefundLoadedEvent>(handleNewRefundLoadedEvent);
    on<ResinNewRefundErrorEvent>(handleNewRefundErrorEvent);
    on<ResinNewRefundSuccessEvent>(handleNewRefundSuccessEvent);
    on<ResinCheckValuesSuccessEvent>(handleCheckValueSuccessEvent);
  }

  void handleNewRefundLoadingEvent(
          ResinNewRefundLoadingEvent event, Emitter emit) =>
      emit(ResinNewRefundLoadingState());

  void handleNewRefundLoadedEvent(
          ResinNewRefundLoadedEvent event, Emitter emit) =>
      emit(ResinNewRefundLoadedState(
        bankAccounts: event.bankAccounts,
        loadingRemote: event.loadingRemote,
        flushbarMessageKey: event.flushbarMessageKey,
      ));

  void handleNewRefundErrorEvent(
          ResinNewRefundErrorEvent event, Emitter emit) =>
      emit(ResinNewRefundErrorState(errorMessageKey: event.errorMessageKey));

  void handleNewRefundSuccessEvent(
          ResinNewRefundSuccessEvent event, Emitter emit) =>
      emit(ResinNewRefundSuccessState(
        event.refund,
        checkMaxValueParam: event.checkMaxValueParam,
      ));

  void handleCheckValueSuccessEvent(
          ResinCheckValuesSuccessEvent event, Emitter emit) =>
      emit(ResinCheckValuesSuccessState(
          checkMaxValueParam: event.checkMaxValueParam));
}
