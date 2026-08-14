import 'package:colaborador/feature/preferences/data/model/preferences_notification_model.dart';

abstract class PreferencesDataSource {
  Future<List<PreferencesNotificationModel>> getPreferencesNotification();
  Future<String> putPreferencesNotification(
      List<PreferencesNotificationModel> model);
}
