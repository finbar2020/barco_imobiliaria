import 'package:essentials/essentials.dart';
import 'package:lello/feature/dashboard_preferences/data/data_source/remote/notifications_preferences_api.dart';
import 'package:lello/feature/dashboard_preferences/data/data_source/remote/notifications_preferences_remote_data_source.dart';
import 'package:lello/feature/dashboard_preferences/data/model/notifications_preferences_model.dart';

class NotificationsPreferencesRemoteDataSourceImpl
    extends NotificationsPreferencesRemoteDataSource {
  final NotificationsPreferencesApi api;

  NotificationsPreferencesRemoteDataSourceImpl({required this.api});

  @override
  Future<List<NotificationsPreferencesModel>> getNotificationsPrefences(
      String condominiumId) async {
    final response = await api.getNotificationsPrefences(condominiumId);
    return ApiMapper.mapList(
        response, (json) => NotificationsPreferencesModel.fromJson(json));
  }

  @override
  Future<List<NotificationsPreferencesModel>> updateNotificationsPrefences(
      String condominiumId,
      List<NotificationsPreferencesModel> bodyModel) async {
    final response =
        await api.updateNotificationsPrefences(condominiumId, bodyModel);

    return ApiMapper.mapList(
        response, (json) => NotificationsPreferencesModel.fromJson(json));
  }
}
