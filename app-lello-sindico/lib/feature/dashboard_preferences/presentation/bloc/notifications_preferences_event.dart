import 'package:essentials/essentials.dart';
import 'package:lello/feature/dashboard_preferences/domain/entity/notifications_preferences.dart';

abstract class NotificationsPreferencesEvent {}

class NotificationsPreferencesEmptyEvent extends NotificationsPreferencesEvent {
}

class NotificationsPreferencesLoadingEvent
    extends NotificationsPreferencesEvent {}

class NotificationsPreferencesFailedEvent
    extends NotificationsPreferencesEvent {
  Failure? failure;
  NotificationsPreferencesFailedEvent({required this.failure});
}

class NotificationsPreferencesLoadedEvent
    extends NotificationsPreferencesEvent {
  List<NotificationsPreferences>? notificationsPreference;
  NotificationsPreferencesLoadedEvent({required this.notificationsPreference});
}

class NotificationsPreferencesUpdateFailedEvent
    extends NotificationsPreferencesEvent {
  Failure? failure;
  NotificationsPreferencesUpdateFailedEvent({
    required this.failure,
  });
}

class UpdateNotificationsPreferencesLoadedEvent
    extends NotificationsPreferencesEvent {
  List<NotificationsPreferences> notificationsPreferences;
  UpdateNotificationsPreferencesLoadedEvent({
    required this.notificationsPreferences,
  });
}
