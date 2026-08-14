part of shared_features;

class NotificationsRemoteDataSourceImpl extends NotificationsRemoteDataSource {
  final NotificationsApi api;
  NotificationsRemoteDataSourceImpl({required this.api});

  @override
  Future<PaginatorModel> loadNotificationsList(
    String reference,
    int limit,
    int page,
  ) async {
    final response = await api.loadNotifications(
      reference,
      limit,
      page,
    );
    final paginator =
        ApiMapper.map(response, (json) => PaginatorModel.fromJson(json));
    return paginator;
  }

  @override
  Future<bool> readNotification(notificationId) async {
    final response = await api.updateNotification(notificationId);
    if (response.isSuccessful) {
      return true;
    } else {
      throw response;
    }
  }

  @override
  Future<bool> deleteAllReadNotification(bool read) async {
    final response = await api.deleteAllReadNotification(read);
    if (response.isSuccessful == true) {
      return true;
    } else {
      throw response.error!;
    }
  }

  @override
  Future<bool> markAllReadNotification() async {
    final response = await api.markAllReadNotification();
    if (response.isSuccessful == true) {
      return true;
    } else {
      throw response.error!;
    }
  }

  @override
  Future<bool> deleteNotification(String notificationId) async {
    final response = await api.deleteNotification(notificationId);
    if (response.isSuccessful == true) {
      return true;
    } else {
      throw response.error!;
    }
  }

  @override
  Future<NotificationResumeModel> getNotificationResume() async {
    final response = await api.getNotificationResume();
    final resume = ApiMapper.map(
        response, (json) => NotificationResumeModel.fromJson(json));
    return resume;
  }

  @override
  Future<bool> sendPushCallback(
      String notificationId, NotificationCallbackType type) async {
    String actionType = enumToString(type) ?? "RECEBEU";
    final response = await api.sendPushCallback(notificationId, actionType);
    if (response.isSuccessful) {
      return true;
    } else {
      throw response;
    }
  }
}
