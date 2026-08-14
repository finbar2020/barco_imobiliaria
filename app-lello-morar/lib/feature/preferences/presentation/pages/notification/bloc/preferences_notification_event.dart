import 'package:essentials/essentials.dart';
import 'package:morar/feature/preferences/domain/entity/preferences_notification_entity.dart';

abstract class PreferencesNotificationEvent extends Equatable {
  const PreferencesNotificationEvent();

  @override
  List<Object?> get props => [];
}

class PreferencesNotificationLoadingEvent extends PreferencesNotificationEvent {
  const PreferencesNotificationLoadingEvent();
}

class PreferencesNotificationLoadedEvent extends PreferencesNotificationEvent {
  final List<PreferencesNotificationEntity> preferences;

  const PreferencesNotificationLoadedEvent({
    required this.preferences,
  });

  @override
  List<Object?> get props => [preferences];
}

class PreferencesNotificationSuccessEvent extends PreferencesNotificationEvent {
  const PreferencesNotificationSuccessEvent();
}

class PreferencesNotificationFailureEvent extends PreferencesNotificationEvent {
  final String error;

  const PreferencesNotificationFailureEvent({required this.error});

  @override
  List<Object?> get props => [error];
}
