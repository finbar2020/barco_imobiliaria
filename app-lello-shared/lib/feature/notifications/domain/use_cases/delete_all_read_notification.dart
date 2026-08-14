part of shared_features;

abstract class DeleteAllReadNotification
    extends UseCase<bool, DeleteAllReadNotificationParams> {}

class DeleteAllReadNotificationParams {
  final bool read;

  DeleteAllReadNotificationParams({required this.read});
}
