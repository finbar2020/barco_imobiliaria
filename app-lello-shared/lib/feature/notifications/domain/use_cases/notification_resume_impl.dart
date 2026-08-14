part of shared_features;

class NotificationResumeImpl extends NotificationResume {
  final NotificationsRepository repository;

  NotificationResumeImpl({required this.repository});

  @override
  Future<Try<NotificationResumeEntity>> call(
      NotificationResumeParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);
    return await repository.getNotificationResume();
  }

  Failure? _validate(NotificationResumeParams param) {
    if (param.reference == null) return InvalidParamFailure();
    return null;
  }
}
