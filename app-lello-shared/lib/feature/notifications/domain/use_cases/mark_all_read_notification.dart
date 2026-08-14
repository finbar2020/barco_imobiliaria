part of shared_features;

abstract class MarkAllReadNotification
    extends UseCase<bool, MarkAllReadNotificationParams> {}

class MarkAllReadNotificationParams {
  final String reference;

  MarkAllReadNotificationParams({required this.reference});
}
