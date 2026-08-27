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
    // Copia as listas: o controller as altera in place e, sem cópia, o
    // Equatable veria o novo estado igual ao anterior e não o emitiria.
    emit(PreferencesHomeCardsLoadedState(
      cards: List.of(event.cards),
      favorites: List.of(event.favorites),
      success: event.success,
      showOnboarding: event.showOnboarding,
    ));
  }

  void handlePreferencesFailureEvent(
      PreferencesHomeCardsFailedEvent event, Emitter emit) {
    emit(const PreferencesHomeCardsFailedState());
  }
}
