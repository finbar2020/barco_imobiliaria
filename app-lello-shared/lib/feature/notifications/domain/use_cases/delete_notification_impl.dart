part of shared_features;

class DeleteNotificationImpl extends DeleteNotification {
  final NotificationsRepository repository;

  DeleteNotificationImpl({required this.repository});

  @override
  Future<Try<bool>> call(DeleteNotificationParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.deleteNotification(params.notificationId);
  }

  Failure? _validate(DeleteNotificationParams param) {
    if (param.notificationId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
