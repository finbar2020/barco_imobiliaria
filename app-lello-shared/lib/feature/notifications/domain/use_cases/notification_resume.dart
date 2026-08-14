part of shared_features;

abstract class NotificationResume
    extends UseCase<NotificationResumeEntity, NotificationResumeParams> {}

class NotificationResumeParams {
  final String? reference;
  NotificationResumeParams({
    this.reference,
  });
}
