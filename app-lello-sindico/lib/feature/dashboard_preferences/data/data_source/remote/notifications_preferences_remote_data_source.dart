import 'package:lello/feature/dashboard_preferences/data/model/notifications_preferences_model.dart';

abstract class NotificationsPreferencesRemoteDataSource {
  Future<List<NotificationsPreferencesModel>> getNotificationsPrefences(
      String condominiumId);
  Future<List<NotificationsPreferencesModel>> updateNotificationsPrefences(
      String condominiumId, List<NotificationsPreferencesModel> bodyModel);
}
