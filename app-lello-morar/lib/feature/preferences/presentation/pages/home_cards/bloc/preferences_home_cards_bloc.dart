import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morar/feature/preferences/presentation/pages/home_cards/bloc/preferences_home_cards_events.dart';
import 'package:morar/feature/preferences/presentation/pages/home_cards/bloc/preferences_home_cards_state.dart';

class PreferencesHomeCardsBloc extends Bloc {
  PreferencesHomeCardsBloc()
      : super(const PreferencesHomeCardsLoadingState()) {
    on<PreferencesHomeCardsLoadingEvent>(handlePreferencesLoadingEvent);
    on<PreferencesHomeCardsLoadedEvent>(handlePreferencesLoadedEvent);
    on<PreferencesHomeCardsFailedEvent>(handlePreferencesFailureEvent);
  }

  void handlePreferencesLoadingEvent(
      PreferencesHomeCardsLoadingEvent event, Emitter emit) {
    emit(const PreferencesHomeCardsLoadingState());
  }

  void handlePreferencesLoadedEvent(
      PreferencesHomeCardsLoadedEvent event, Emitter emit) {
    emit(PreferencesHomeCardsLoadedState(
      cards: event.cards,
      favorites: event.favorites,
      success: event.success,
      showOnboarding: event.showOnboarding,
    ));
  }

  void handlePreferencesFailureEvent(
      PreferencesHomeCardsFailedEvent event, Emitter emit) {
    emit(const PreferencesHomeCardsFailedState());
  }
}
