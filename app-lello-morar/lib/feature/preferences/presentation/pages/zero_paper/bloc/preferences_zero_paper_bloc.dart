import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morar/feature/preferences/presentation/pages/zero_paper/bloc/preferences_zero_paper_event.dart';
import 'package:morar/feature/preferences/presentation/pages/zero_paper/bloc/preferences_zero_paper_state.dart';

class PreferencesZeroPaperBloc extends Bloc {
  PreferencesZeroPaperBloc() : super(const PreferencesZeroPaperInitialState()) {
    on<PreferencesZeroPaperLoadingEvent>(handlePreferencesLoadingEvent);
    on<PreferencesZeroPaperLoadedEvent>(handlePreferencesLoadedEvent);
    on<PreferencesZeroPaperFailureEvent>(handlePreferencesFailureEvent);
    on<PreferencesZeroPaperSuccessEvent>(handlePreferencesSuccessEvent);
  }

  void handlePreferencesLoadingEvent(
      PreferencesZeroPaperLoadingEvent event, Emitter emit) {
    emit(const PreferencesZeroPaperLoadingState());
  }

  void handlePreferencesLoadedEvent(
      PreferencesZeroPaperLoadedEvent event, Emitter emit) {
    emit(PreferencesZeroPaperLoadedState(
      preferences: event.preferences,
      digitalAnnouncements: event.digitalAnnouncements,
      printedAnnouncements: event.printedAnnouncements,
      digitalActs: event.digitalActs,
      printedActs: event.printedActs,
      digitalSlips: event.digitalSlips,
      printedSlips: event.printedSlips,
      digitalStatements: event.digitalStatements,
      printedStatements: event.printedStatements,
    ));
  }

  void handlePreferencesFailureEvent(
      PreferencesZeroPaperFailureEvent event, Emitter emit) {
    emit(PreferencesZeroPaperFailureState(error: event.error));
  }

  void handlePreferencesSuccessEvent(
      PreferencesZeroPaperSuccessEvent event, Emitter emit) {
    emit(const PreferencesZeroPaperSuccessState());
  }
}
