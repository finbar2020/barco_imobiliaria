part of shared_features;

class MarkAllReadNotificationImpl extends MarkAllReadNotification {
  final NotificationsRepository repository;

  MarkAllReadNotificationImpl({required this.repository});

  @override
  Future<Try<bool>> call(MarkAllReadNotificationParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.markAllReadNotification();
  }

  Failure? _validate(MarkAllReadNotificationParams param) {
    if (param.reference.isEmpty) return InvalidParamFailure();
    return null;
  }
}
