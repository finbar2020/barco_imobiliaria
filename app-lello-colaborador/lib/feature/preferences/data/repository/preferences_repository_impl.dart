import 'package:colaborador/feature/preferences/data/data_source/preferences_data_source.dart';
import 'package:colaborador/feature/preferences/data/model/preferences_notification_model.dart';
import 'package:colaborador/feature/preferences/domain/entity/preferences_notification_entity.dart';
import 'package:colaborador/feature/preferences/domain/repository/preferences_repository.dart';
import 'package:essentials/essentials.dart';

class PreferencesRepositoryImpl extends PreferencesRepository {
  final PreferencesDataSource dataSource;
  PreferencesRepositoryImpl({required this.dataSource});

  @override
  Future<Try<List<PreferencesNotificationEntity>>>
      getPreferencesNotification() async {
    try {
      final response = await dataSource.getPreferencesNotification();
      var entity = response.map((e) => e.toEntity()).toList();
      return Success(entity);
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<String>> putPreferencesNotification(
      List<PreferencesNotificationEntity> entity) async {
    try {
      List<PreferencesNotificationModel> model = entity
          .map((e) => PreferencesNotificationModel.fromEntity(e))
          .toList();
      final response = await dataSource.putPreferencesNotification(model);
      return Success(response);
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }
}
