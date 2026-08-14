import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morar/feature/preferences/presentation/pages/notification/bloc/preferences_notification_event.dart';
import 'package:morar/feature/preferences/presentation/pages/notification/bloc/preferences_notification_state.dart';

class PreferencesNotificationBloc extends Bloc {
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
    emit(PreferencesNotificationFailureState(error: event.error));
  }

  void handlePreferencesSuccessEvent(
      PreferencesNotificationSuccessEvent event, Emitter emit) {
    emit(const PreferencesNotificationSuccessState());
  }
}
