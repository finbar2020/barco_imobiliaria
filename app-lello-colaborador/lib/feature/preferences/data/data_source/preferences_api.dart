import 'package:chopper/chopper.dart';
import 'package:colaborador/feature/preferences/data/model/preferences_notification_model.dart';

part 'preferences_api.chopper.dart';

@ChopperApi()
abstract class PreferencesApi extends ChopperService {
  @Get(path: "/me/preferences/notification")
  Future<Response> getPreferencesNotification();

  @Put(path: "/me/preferences/notification")
  Future<Response> putPreferencesNotification(
    @Body() List<PreferencesNotificationModel> body,
  );

  static PreferencesApi create(ChopperClient client) {
    return _$PreferencesApi(client);
  }
}
