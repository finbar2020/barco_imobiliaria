import 'package:essentials/essentials.dart';
import 'package:morar/feature/preferences/data/data_source/preferences_data_source.dart';
import 'package:morar/feature/preferences/data/model/preferences_model.dart';
import 'package:morar/feature/preferences/data/model/preferences_notification_model.dart';
import 'package:morar/feature/preferences/domain/entity/preferences_entity.dart';
import 'package:morar/feature/preferences/domain/entity/preferences_notification_entity.dart';
import 'package:morar/feature/preferences/domain/entity/preferences_zero_paper_entity.dart';
import 'package:morar/feature/preferences/domain/repository/preferences_repository.dart';

class PreferencesRepositoryImpl extends PreferencesRepository {
  final PreferencesDataSource dataSource;
  PreferencesRepositoryImpl({required this.dataSource});

  @override
  Future<Try<PreferencesZeroPaperEntity>> getPreferencesZeroPaper() async {
    try {
      final response = await dataSource.getPreferencesZeroPaper();
      var entity = response.toEntity();
      return Success(entity);
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<String>> putPreferencesZeroPaper(PreferencesEntity entity) async {
    try {
      PreferencesModel model = PreferencesModel.fromEntity(entity)!;
      final response = await dataSource.putPreferencesZeroPaper(model);
      return Success(response);
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

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
