import 'package:morar/feature/preferences/data/model/preferences_model.dart';
import 'package:morar/feature/preferences/data/model/preferences_notification_model.dart';
import 'package:morar/feature/preferences/data/model/preferences_zero_paper_model.dart';

abstract class PreferencesDataSource {
  Future<PreferencesZeroPaperModel> getPreferencesZeroPaper();
  Future<String> putPreferencesZeroPaper(PreferencesModel model);
  Future<List<PreferencesNotificationModel>> getPreferencesNotification();
  Future<String> putPreferencesNotification(
      List<PreferencesNotificationModel> model);
}
