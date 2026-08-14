import 'package:colaborador/feature/preferences/data/data_source/preferences_api.dart';
import 'package:colaborador/feature/preferences/data/data_source/preferences_data_source.dart';
import 'package:colaborador/feature/preferences/data/model/preferences_notification_model.dart';
import 'package:essentials/essentials.dart';

class PreferencesDataSourceImpl extends PreferencesDataSource {
  final PreferencesApi api;
  PreferencesDataSourceImpl({required this.api});

  @override
  Future<List<PreferencesNotificationModel>>
      getPreferencesNotification() async {
    final response = await api.getPreferencesNotification();
    final result = ApiMapper.mapList(
        response, (json) => PreferencesNotificationModel.fromJson(json));
    return result;
  }

  @override
  Future<String> putPreferencesNotification(
      List<PreferencesNotificationModel> model) async {
    final response = await api.putPreferencesNotification(model);
    if (response.isSuccessful == false) {
      print(response.error);
      throw response.error!;
    } else {
      return "";
    }
  }
}
