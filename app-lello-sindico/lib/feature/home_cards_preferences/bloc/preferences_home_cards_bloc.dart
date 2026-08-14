import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/home_cards_preferences/bloc/preferences_home_cards_events.dart';
import 'package:lello/feature/home_cards_preferences/bloc/preferences_home_cards_state.dart';

class PreferencesHomeCardsBloc extends Bloc {
  PreferencesHomeCardsBloc() : super(PreferencesHomeCardsLoadingState()) {
    on<PreferencesHomeCardsLoadingEvent>(handlePreferencesLoadingEvent);
    on<PreferencesHomeCardsLoadedEvent>(handlePreferencesLoadedEvent);
    on<PreferencesHomeCardsFailedEvent>(handlePreferencesFailureEvent);
  }

  void handlePreferencesLoadingEvent(
      PreferencesHomeCardsLoadingEvent event, Emitter emit) {
    emit(PreferencesHomeCardsLoadingState());
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
    emit(PreferencesHomeCardsFailedState());
  }
}
