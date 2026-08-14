import 'package:colaborador/feature/preferences/domain/entity/preferences_notification_entity.dart';
import 'package:essentials/essentials.dart';

abstract class PreferencesRepository {
  Future<Try<List<PreferencesNotificationEntity>>> getPreferencesNotification();
  Future<Try<String>> putPreferencesNotification(
      List<PreferencesNotificationEntity> entity);
}
