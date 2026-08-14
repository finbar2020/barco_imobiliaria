import 'package:colaborador/feature/preferences/presentation/bloc/preferences_notification_event.dart';
import 'package:colaborador/feature/preferences/presentation/bloc/preferences_notification_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PreferencesNotificationBloc
    extends Bloc<PreferencesNotificationEvent, PreferencesNotificationState> {
  PreferencesNotificationBloc()
      : super(const PreferencesNotificationInitialState()) {
    on<PreferencesNotificationLoadingEvent>(handlePreferencesLoadingEvent);
    on<PreferencesNotificationLoadedEvent>(handlePreferencesLoadedEvent);
    on<PreferencesNotificationFailureEvent>(handlePreferencesFailureEvent);
    on<PreferencesNotificationSuccessEvent>(handlePreferencesSuccessEvent);
  }

  void handlePreferencesLoadingEvent(
      PreferencesNotificationLoadingEvent event, Emitter emit) {
    emit(const PreferencesNotificationLoadingState());
  }

  void handlePreferencesLoadedEvent(
      PreferencesNotificationLoadedEvent event, Emitter emit) {
    emit(PreferencesNotificationLoadedState(
      preferences: event.preferences,
    ));
  }

  void handlePreferencesFailureEvent(
      PreferencesNotificationFailureEvent event, Emitter emit) {
    emit(PreferencesNotificationFailureState(failure: event.failure));
  }

  void handlePreferencesSuccessEvent(
      PreferencesNotificationSuccessEvent event, Emitter emit) {
    emit(const PreferencesNotificationSuccessState());
  }
}
