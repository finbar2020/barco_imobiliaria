import 'package:chopper/chopper.dart';

part 'notifications_api.chopper.dart';

@ChopperApi()
abstract class NotificationsApi extends ChopperService {
  @Get(path: "/dashboard/{reference}/pendencies/pagination")
  Future<Response> loadNotifications(
    @Path() String reference,
    @Query("limit") int limit,
    @Query("page") int page,
  );

  @Put(path: "/dashboard/pendencies/markRead")
  Future<Response> updateNotification(
    @Query("notificationId") String notificationId,
  );

  @Put(path: "/dashboard/pendencies/markAllRead")
  Future<Response> markAllReadNotification();

  @Delete(path: "/dashboard/pendencies/deleteAllRead")
  Future<Response> deleteAllReadNotification(
    @Query("read") bool read,
  );

  @Delete(path: "/dashboard/pendencies/delete")
  Future<Response> deleteNotification(
    @Query("notificationId") String notificationId,
  );

  @Get(path: "/dashboard/pendencies/resume")
  Future<Response> getNotificationResume();

  @Post(path: "/dashboard/pendencies/sendCallback")
  Future<Response> sendPushCallback(
    @Query("notificationId") String notificationId,
    @Query("type") String type,
  );

  static NotificationsApi create(ChopperClient client) {
    return _$NotificationsApi(client);
  }
}
