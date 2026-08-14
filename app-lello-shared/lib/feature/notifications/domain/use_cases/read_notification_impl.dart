part of shared_features;

class ReadNotificationsImpl extends ReadNotification {
  final NotificationsRepository repository;

  ReadNotificationsImpl({required this.repository});

  @override
  Future<Try<bool>> call(ReadNotificationParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.updateSingleNotification(params.notificationId);
  }

  Failure? _validate(ReadNotificationParams param) {
    if (param.notificationId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
