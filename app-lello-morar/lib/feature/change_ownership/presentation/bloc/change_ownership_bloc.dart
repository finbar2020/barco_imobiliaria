import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morar/feature/change_ownership/presentation/bloc/change_ownership_event.dart';
import 'package:morar/feature/change_ownership/presentation/bloc/change_ownership_state.dart';

class ChangeOwnershipBloc extends Bloc {
  ChangeOwnershipBloc() : super(const ChangeOwnershipInitialState()) {
    on<ChangeOwnershipLoadingEvent>(handleBChangeOwnershipLoadingEvent);
    on<ChangeOwnershipFailureEvent>(handleChangeOwnershipFailureEvent);
    on<ChangeOwnershipLoadedEvent>(handleChangeOwnershipLoadedEvent);
    on<ChangeOwnershipSuccessEvent>(handleChangeOwnershipSuccessEvent);
  }

  void handleBChangeOwnershipLoadingEvent(
      ChangeOwnershipLoadingEvent event, Emitter emit) {
    emit(const ChangeOwnershipLoadingState());
  }

  void handleChangeOwnershipFailureEvent(
      ChangeOwnershipFailureEvent event, Emitter emit) {
    emit(ChangeOwnershipFailureState(errorMessageKey: event.error));
  }

  void handleChangeOwnershipLoadedEvent(
      ChangeOwnershipLoadedEvent event, Emitter emit) {
    emit(ChangeOwnershipLoadedState(
        canChange: event.canChange,
        cantChangeMessage: event.cantChangeMessage));
  }

  void handleChangeOwnershipSuccessEvent(
      ChangeOwnershipSuccessEvent event, Emitter emit) {
    emit(const ChangeOwnershipSuccessState());
  }
}
