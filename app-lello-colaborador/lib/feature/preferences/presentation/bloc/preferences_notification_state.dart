import 'package:colaborador/feature/preferences/domain/entity/preferences_notification_entity.dart';
import 'package:essentials/essentials.dart';

abstract class PreferencesNotificationState extends Equatable {
  const PreferencesNotificationState();

  @override
  List<Object?> get props => [];
}

class PreferencesNotificationInitialState
    extends PreferencesNotificationState {
  const PreferencesNotificationInitialState();
}

class PreferencesNotificationLoadingState
    extends PreferencesNotificationState {
  const PreferencesNotificationLoadingState();
}

class PreferencesNotificationLoadedState extends PreferencesNotificationState {
  final List<PreferencesNotificationEntity> preferences;

  const PreferencesNotificationLoadedState({
    required this.preferences,
  });

  @override
  List<Object?> get props => [preferences];
}

class PreferencesNotificationSuccessState
    extends PreferencesNotificationState {
  const PreferencesNotificationSuccessState();
}

class PreferencesNotificationFailureState extends PreferencesNotificationState {
  final Failure? failure;

  const PreferencesNotificationFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}
