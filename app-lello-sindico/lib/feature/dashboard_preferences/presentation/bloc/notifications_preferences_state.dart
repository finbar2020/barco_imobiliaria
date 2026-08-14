import 'package:essentials/essentials.dart';
import 'package:lello/feature/dashboard_preferences/domain/entity/notifications_preferences.dart';

class NotificationsPreferencesState {}

class NotificationsPreferencesEmptyState extends NotificationsPreferencesState {
}

class NotificationsPreferencesLoadingState
    extends NotificationsPreferencesState {}

class NotificationsPreferencesFailedState
    extends NotificationsPreferencesState {
  Failure? failure;
  NotificationsPreferencesFailedState({required this.failure});
}

class NotificationsPreferencesLoadedState
    extends NotificationsPreferencesState {
  List<NotificationsPreferences>? notificationsPreference;
  NotificationsPreferencesLoadedState({required this.notificationsPreference});
}

class NotificationsPreferencesUpdateFailedState
    extends NotificationsPreferencesState {
  Failure? failure;
  NotificationsPreferencesUpdateFailedState({required this.failure});
}

class UpdateNotificationsPreferencesLoadedState
    extends NotificationsPreferencesState {
  List<NotificationsPreferences>? notificationsPreferences;
  UpdateNotificationsPreferencesLoadedState({
    required this.notificationsPreferences,
  });
}
