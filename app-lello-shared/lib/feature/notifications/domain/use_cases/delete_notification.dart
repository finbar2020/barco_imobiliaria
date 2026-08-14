part of shared_features;

abstract class DeleteNotification
    extends UseCase<bool, DeleteNotificationParams> {}

class DeleteNotificationParams {
  final String notificationId;

  DeleteNotificationParams({required this.notificationId});
}
