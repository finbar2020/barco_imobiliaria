part of shared_features;

class DeleteAllReadNotificationImpl extends DeleteAllReadNotification {
  final NotificationsRepository repository;

  DeleteAllReadNotificationImpl({required this.repository});

  @override
  Future<Try<bool>> call(DeleteAllReadNotificationParams params) async {
    return await repository.deleteAllReadNotification(params.read);
  }
}
