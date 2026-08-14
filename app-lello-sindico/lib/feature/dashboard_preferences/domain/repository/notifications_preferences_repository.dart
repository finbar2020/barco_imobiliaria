import 'package:essentials/essentials.dart';
import 'package:lello/feature/dashboard_preferences/domain/entity/notifications_preferences.dart';

abstract class NotificationsPreferencesRepository {
  Future<Try<List<NotificationsPreferences>>> getNotificationsPreferences(
      String condominiumId);
  Future<Try<List<NotificationsPreferences>>> updateNotificationsPreferences(
      String condominiumId, List<NotificationsPreferences> body);
}
