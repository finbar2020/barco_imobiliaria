import 'package:essentials/essentials.dart';
import 'package:lello/feature/dashboard_preferences/domain/entity/notifications_preferences.dart';

abstract class UpdateNotificationsPreferences extends UseCase<
    List<NotificationsPreferences>, UpdateNotificationsPreferencesParam> {}

class UpdateNotificationsPreferencesParam {
  final String condominiumId;
  List<NotificationsPreferences> notificationsPreferences;

  UpdateNotificationsPreferencesParam(
      {required this.condominiumId, required this.notificationsPreferences});
}
