part of shared_features;

abstract class ReadNotification extends UseCase<bool, ReadNotificationParams> {}

class ReadNotificationParams {
  final String notificationId;

  ReadNotificationParams({required this.notificationId});
}
