import 'package:chopper/chopper.dart';
import 'package:shared_features/feature/ghost_notification/data/model/ghost_notification_model.dart';

part 'ghost_notification_api.chopper.dart';

@ChopperApi()
abstract class GhostNotificationApi extends ChopperService {
  @Post(path: "ghostNotification")
  Future<Response> sendGhostNotification(
    @Body() GhostNotificationModel body,
    @Query("id") String id,
    @Query("tipo") String type,
  );

  static GhostNotificationApi create(ChopperClient client) {
    return _$GhostNotificationApi(client);
  }
}
