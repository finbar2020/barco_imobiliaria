import 'package:flutter_bloc/flutter_bloc.dart';

import 'accountability_event.dart';
import 'accountability_state.dart';

class AccountabilityBloc
    extends Bloc<AccountabilityPeriodsEvent, AccountabilityPeriodsState> {
  AccountabilityBloc() : super(AccountabilityPeriodsLoadingState()) {
    on<AccountabilityPeriodsLoadedEvent>(
        handleAccountabilityPeriodsLoadedEvent);
    on<AccountabilityPeriodsLoadingEvent>(
        handleAccountabilityPeriodsLoadingEvent);
    on<AccountabilityPeriodsFailedEvent>(
        handleAccountabilityPeriodsFailedEvent);
    on<AccountabilityPeriodsEmptyEvent>(handleAccountabilityPeriodsEmptyEvent);
  }

  void handleAccountabilityPeriodsLoadedEvent(
      AccountabilityPeriodsLoadedEvent event, Emitter emit) {
    emit(AccountabilityPeriodsLoadedState(
      period: event.period,
    ));
  }

  void handleAccountabilityPeriodsLoadingEvent(
      AccountabilityPeriodsLoadingEvent event, Emitter emit) {
    emit(AccountabilityPeriodsLoadingState());
  }

  void handleAccountabilityPeriodsFailedEvent(
      AccountabilityPeriodsFailedEvent event, Emitter emit) {
    emit(AccountabilityPeriodsFailedState(
      error: event.failure,
    ));
  }

  void handleAccountabilityPeriodsEmptyEvent(
      AccountabilityPeriodsEmptyEvent event, Emitter emit) {
    emit(AccountabilityPeriodsEmptyState());
  }
}
