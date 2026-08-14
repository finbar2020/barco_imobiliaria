import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/resin/presentation/resin_new_advance/bloc/resin_new_advance_event.dart';
import 'package:lello/feature/resin/presentation/resin_new_advance/bloc/resin_new_advance_state.dart';

class ResinNewAdvanceBloc
    extends Bloc<ResinNewAdvanceEvent, ResinNewAdvanceState> {
  ResinNewAdvanceBloc() : super(ResinNewAdvanceLoadingState()) {
    on<ResinNewAdvanceLoadingEvent>(handleNewAdvanceLoadingEvent);
    on<ResinNewAdvanceLoadedEvent>(handleNewAdvanceLoadedEvent);
    on<ResinNewAdvanceErrorEvent>(handleNewAdvanceErrorEvent);
    on<ResinNewAdvanceSuccessEvent>(handleNewAdvanceSuccessEvent);
    on<ResinCheckValuesSuccessEvent>(handleNewAdvanceCheckValuesEvent);
  }

  void handleNewAdvanceLoadingEvent(
          ResinNewAdvanceLoadingEvent event, Emitter emit) =>
      emit(ResinNewAdvanceLoadingState());

  void handleNewAdvanceLoadedEvent(
          ResinNewAdvanceLoadedEvent event, Emitter emit) =>
      emit(ResinNewAdvanceLoadedState(
        bankAccounts: event.bankAccounts,
        loadingRemote: event.loadingRemote,
        flushbarMessageKey: event.flushbarMessageKey,
      ));

  void handleNewAdvanceErrorEvent(
          ResinNewAdvanceErrorEvent event, Emitter emit) =>
      emit(ResinNewAdvanceErrorState(errorMessageKey: event.errorMessageKey));

  void handleNewAdvanceSuccessEvent(
          ResinNewAdvanceSuccessEvent event, Emitter emit) =>
      emit(ResinNewAdvanceSuccessState(
        event.refund,
      ));

  void handleNewAdvanceCheckValuesEvent(
          ResinCheckValuesSuccessEvent event, Emitter emit) =>
      emit(ResinCheckValuesAdvanceSuccessState(
          checkMaxValueParam: event.checkMaxValueParam));
}
