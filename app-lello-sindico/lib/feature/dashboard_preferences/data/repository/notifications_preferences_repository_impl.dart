import 'package:essentials/essentials.dart';
import 'package:lello/feature/dashboard_preferences/data/data_source/remote/notifications_preferences_remote_data_source.dart';
import 'package:lello/feature/dashboard_preferences/data/model/notifications_preferences_model.dart';
import 'package:lello/feature/dashboard_preferences/domain/entity/notifications_preferences.dart';
import 'package:lello/feature/dashboard_preferences/domain/repository/notifications_preferences_repository.dart';

class NotificationsPreferencesRepositoryImpl
    extends NotificationsPreferencesRepository {
  final NotificationsPreferencesRemoteDataSource remoteDataSource;

  NotificationsPreferencesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Try<List<NotificationsPreferences>>> getNotificationsPreferences(
      String condominiumId) async {
    try {
      final result =
          await remoteDataSource.getNotificationsPrefences(condominiumId);
      return Success(result.map((e) => e.toEntity()).toList());
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<List<NotificationsPreferences>>> updateNotificationsPreferences(
      String condominiumId, List<NotificationsPreferences> body) async {
    try {
      List<NotificationsPreferencesModel> bodyModel =
          body.map((e) => NotificationsPreferencesModel.fromEntity(e)).toList();
      final data = await remoteDataSource.updateNotificationsPrefences(
          condominiumId, bodyModel);
      final entities = data.map((e) => e.toEntity()).toList();
      return Success(entities);
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }
}
