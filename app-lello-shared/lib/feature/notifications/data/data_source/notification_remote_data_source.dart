part of shared_features;

abstract class NotificationsRemoteDataSource {
  Future<bool> readNotification(String notificationId);
  Future<PaginatorModel> loadNotificationsList(
    String reference,
    int limit,
    int page,
  );
  Future<bool> markAllReadNotification();
  Future<bool> deleteAllReadNotification(bool read);
  Future<bool> deleteNotification(String notificationId);
  Future<NotificationResumeModel> getNotificationResume();
  Future<bool> sendPushCallback(
      String notificationId, NotificationCallbackType type);
}
