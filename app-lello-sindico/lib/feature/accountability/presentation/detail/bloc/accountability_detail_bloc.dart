import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/accountability/presentation/detail/bloc/accountability_detail_state.dart';

import 'accountability_detail_event.dart';

class AccountabilityDetailBloc
    extends Bloc<AccountabilityDetailEvent, AccountabilityDetailState> {
  AccountabilityDetailBloc() : super(AccountabilityDetailLoadingState()) {
    on<AccountabilityDetailLoadingEvent>(
        handleAccountabilityDetailLoadingEvent);
    on<AccountabilityDetailLoadedEvent>(handleAccountabilityDetailLoadedEvent);
    on<AccountabilityDetailFailedEvent>(handleAccountabilityDetailFailedEvent);
    on<AccountabilityDetailEmptyEvent>(handleAccountabilityDetailEmptyEvent);
    on<AccountabilitySendRecommendationLoadingEvent>(
        handleAccountabilitySendRecommendationLoadingEvent);
    on<AccountabilitySendRecommendationSuccessEvent>(
        handleAccountabilitySendRecommendationSuccessEvent);
    on<AccountabilitySendRecommendationFailureEvent>(
        handleAccountabilitySendRecommendationFailureEvent);
  }

  void handleAccountabilityDetailLoadingEvent(
      AccountabilityDetailLoadingEvent event, Emitter emit) {
    emit(
      AccountabilityDetailLoadingState(),
    );
  }

  void handleAccountabilityDetailLoadedEvent(
      AccountabilityDetailLoadedEvent event, Emitter emit) {
    emit(
      AccountabilityDetailLoadedState(
        accountability: event.accountability,
        condominiumId: event.condominiumId,
        period: event.period,
      ),
    );
  }

  void handleAccountabilityDetailFailedEvent(
      AccountabilityDetailFailedEvent event, Emitter emit) {
    emit(
      AccountabilityDetailFailedState(
        error: event.error,
        condominiumId: event.condominiumId,
        period: event.period,
      ),
    );
  }

  void handleAccountabilityDetailEmptyEvent(
      AccountabilityDetailEmptyEvent event, Emitter emit) {
    emit(AccountabilityDetailEmptyState());
  }

  /// Send Recommendation

  void handleAccountabilitySendRecommendationLoadingEvent(
      AccountabilitySendRecommendationLoadingEvent event, Emitter emit) {
    emit(AccountabilitySendRecommendationLoadingState());
  }

  void handleAccountabilitySendRecommendationSuccessEvent(
      AccountabilitySendRecommendationSuccessEvent event, Emitter emit) {
    emit(AccountabilitySendRecommendationSuccessState());
  }

  void handleAccountabilitySendRecommendationFailureEvent(
      AccountabilitySendRecommendationFailureEvent event, Emitter emit) {
    emit(AccountabilitySendRecommendationFailureState(message: event.message));
  }
}
