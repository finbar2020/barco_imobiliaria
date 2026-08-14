import 'package:essentials/essentials.dart';
import 'package:morar/feature/preferences/domain/entity/preferences_entity.dart';
import 'package:morar/feature/preferences/domain/entity/preferences_notification_entity.dart';
import 'package:morar/feature/preferences/domain/entity/preferences_zero_paper_entity.dart';

abstract class PreferencesRepository {
  Future<Try<PreferencesZeroPaperEntity>> getPreferencesZeroPaper();
  Future<Try<String>> putPreferencesZeroPaper(PreferencesEntity entity);
  Future<Try<List<PreferencesNotificationEntity>>> getPreferencesNotification();
  Future<Try<String>> putPreferencesNotification(
      List<PreferencesNotificationEntity> entity);
}
