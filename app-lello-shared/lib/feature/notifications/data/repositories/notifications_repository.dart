part of shared_features;

class NotificationsRepositoryImpl extends NotificationsRepository {
  final NotificationsRemoteDataSource remoteDataSource;

  NotificationsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Try<bool>> updateSingleNotification(String notificationId) async {
    try {
      final bool result =
          await remoteDataSource.readNotification(notificationId);

      return Success(result);
    } catch (e) {
      // FirebaseCrashlytics.instance.recordError(
      //   e,
      //   stacktrace,
      //   reason: 'notificationId: $notificationId',
      // );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<Paginator>> loadNotifications(
    String condominiumId,
    int limit,
    int page,
  ) async {
    try {
      final PaginatorModel result = await remoteDataSource
          .loadNotificationsList(condominiumId, limit, page);
      final entity = result.toEntity();
      return Success(entity);
    } catch (e) {
      // FirebaseCrashlytics.instance.recordError(
      //   e,
      //   stacktrace,
      //   reason: 'condominiumId: $condominiumId',
      // );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<Nothing>> clear() async {
    try {
      //await localDataSource.clear(null);
      return Success(Nothing());
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<bool>> deleteAllReadNotification(bool read) async {
    try {
      final bool result =
          await remoteDataSource.deleteAllReadNotification(read);
      return Success(result);
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<bool>> markAllReadNotification() async {
    try {
      final bool result = await remoteDataSource.markAllReadNotification();
      return Success(result);
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<bool>> deleteNotification(String notificationId) async {
    try {
      final bool result =
          await remoteDataSource.deleteNotification(notificationId);
      return Success(result);
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<NotificationResumeEntity>> getNotificationResume() async {
    try {
      final NotificationResumeModel result =
          await remoteDataSource.getNotificationResume();
      return Success(result.toEntity());
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<bool>> sendPushCallback(
      String notificationId, NotificationCallbackType type) async {
    try {
      final bool result =
          await remoteDataSource.sendPushCallback(notificationId, type);
      return Success(result);
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }
}
