part of shared_features;

abstract class NotificationsRepository {
  Future<Try<bool>> updateSingleNotification(String notificationId);
  Future<Try<Paginator>> loadNotifications(
    String reference,
    int limit,
    int page,
  );
  Future<Try<Nothing>> clear();
  Future<Try<bool>> markAllReadNotification();
  Future<Try<bool>> deleteAllReadNotification(bool read);
  Future<Try<bool>> deleteNotification(String notificationId);
  Future<Try<NotificationResumeEntity>> getNotificationResume();
  Future<Try<bool>> sendPushCallback(
      String notificationId, NotificationCallbackType type);
}
