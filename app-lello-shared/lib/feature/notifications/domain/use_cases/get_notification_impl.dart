part of shared_features;

class GetNotificationsImpl extends GetNotifications {
  final NotificationsRepository repository;

  GetNotificationsImpl({required this.repository});

  @override
  Future<Try<Paginator>> call(GetNotificationParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.loadNotifications(
        params.reference, params.limit, params.page);
  }

  Failure? _validate(GetNotificationParams param) {
    if (param.reference.isEmpty) return InvalidParamFailure();
    return null;
  }
}
