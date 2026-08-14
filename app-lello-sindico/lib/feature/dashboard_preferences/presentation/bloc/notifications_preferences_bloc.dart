import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/dashboard_preferences/presentation/bloc/notifications_preferences_event.dart';
import 'package:lello/feature/dashboard_preferences/presentation/bloc/notifications_preferences_state.dart';

class NotificationsPreferencesBloc
    extends Bloc<NotificationsPreferencesEvent, NotificationsPreferencesState> {
  NotificationsPreferencesBloc() : super(NotificationsPreferencesEmptyState()) {
    on<NotificationsPreferencesEmptyEvent>(
        handleNotificationsPreferencesEmptyEvent);
    on<NotificationsPreferencesLoadingEvent>(
        handleNotificationsPreferencesLoadingEvent);
    on<NotificationsPreferencesFailedEvent>(
        handleNotificationsPreferencesFailedEvent);
    on<NotificationsPreferencesLoadedEvent>(
        handleNotificationsPreferencesLoadedEvent);
    on<NotificationsPreferencesUpdateFailedEvent>(
        handleNotificationsPreferencesUpdateFailedEvent);
    on<UpdateNotificationsPreferencesLoadedEvent>(
        handleUpdateNotificationsPreferencesLoadedEvent);
  }

  void handleNotificationsPreferencesEmptyEvent(
      NotificationsPreferencesEmptyEvent event, Emitter emit) {
    emit(
      NotificationsPreferencesEmptyState(),
    );
  }

  void handleNotificationsPreferencesLoadingEvent(
      NotificationsPreferencesLoadingEvent event, Emitter emit) {
    emit(
      NotificationsPreferencesLoadingState(),
    );
  }

  void handleNotificationsPreferencesFailedEvent(
      NotificationsPreferencesFailedEvent event, Emitter emit) {
    emit(
      NotificationsPreferencesFailedState(failure: event.failure),
    );
  }

  void handleNotificationsPreferencesLoadedEvent(
      NotificationsPreferencesLoadedEvent event, Emitter emit) {
    emit(
      NotificationsPreferencesLoadedState(
          notificationsPreference: event.notificationsPreference),
    );
  }

  void handleNotificationsPreferencesUpdateFailedEvent(
      NotificationsPreferencesUpdateFailedEvent event, Emitter emit) {
    emit(
      NotificationsPreferencesUpdateFailedState(failure: event.failure),
    );
  }

  void handleUpdateNotificationsPreferencesLoadedEvent(
      UpdateNotificationsPreferencesLoadedEvent event, Emitter emit) {
    emit(
      UpdateNotificationsPreferencesLoadedState(
          notificationsPreferences: event.notificationsPreferences),
    );
  }
}
