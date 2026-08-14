import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morar/feature/accountability/presentation/bloc/accountabiity_event.dart';
import 'package:morar/feature/accountability/presentation/bloc/accountabiity_state.dart';

class AccountabilityBloc extends Bloc {
  AccountabilityBloc() : super(const AccountabilityInitialState()) {
    on<AccountabilityEmptyEvent>(handleAccountabilityEmptyEvent);
    on<AccountabilityLoadingEvent>(handleAccountabilityLoadingEvent);
    on<AccountabilityLoadedEvent>(handleAccountabilityLoadedEvent);
    on<AccountabilityFailureEvent>(handleAccountabilityFailedEvent);
    on<AccountabilityPeriodsLoadedEvent>(
        handleAccountabilityPeriodsLoadedEvent);
  }

  void handleAccountabilityEmptyEvent(
      AccountabilityEmptyEvent event, Emitter emit) {
    emit(const AccountabilityInitialState());
  }

  void handleAccountabilityLoadingEvent(
      AccountabilityLoadingEvent event, Emitter emit) {
    emit(const AccountabilityLoadingState());
  }

  void handleAccountabilityLoadedEvent(
      AccountabilityLoadedEvent event, Emitter emit) {
    emit(AccountabilityLoadedState(periodos: event.periodos));
  }

  void handleAccountabilityFailedEvent(
      AccountabilityFailureEvent event, Emitter emit) {
    emit(AccountabilityFailureState(error: event.error));
  }

  void handleAccountabilityPeriodsLoadedEvent(
      AccountabilityPeriodsLoadedEvent event, Emitter emit) {
    emit(
        AccountabilityPeriodsLoadedState(accountability: event.accountability));
  }
}
