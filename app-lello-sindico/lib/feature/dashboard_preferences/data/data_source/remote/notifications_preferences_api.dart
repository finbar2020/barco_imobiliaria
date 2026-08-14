import 'package:chopper/chopper.dart';
import 'package:lello/feature/dashboard_preferences/data/model/notifications_preferences_model.dart';

part 'notifications_preferences_api.chopper.dart';

@ChopperApi()
abstract class NotificationsPreferencesApi extends ChopperService {
  @GET(path: "dashboard/{reference}/pendencies/rules")
  Future<Response> getNotificationsPrefences(
      @Path("reference") String reference);

  @PUT(path: "dashboard/{reference}/pendencies/rules")
  Future<Response> updateNotificationsPrefences(@Path() String reference,
      @Body() List<NotificationsPreferencesModel> body);

  static NotificationsPreferencesApi create(ChopperClient client) {
    return _$NotificationsPreferencesApi(client);
  }
}
