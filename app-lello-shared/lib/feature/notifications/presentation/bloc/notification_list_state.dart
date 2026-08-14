part of shared_features;

abstract class NotificationListState {
  NotificationListState();
}

class NotificationListEmptyState extends NotificationListState {
  NotificationListEmptyState() : super();
}

class NotificationListLoadingState extends NotificationListState {
  NotificationListLoadingState() : super();
}

class NotificationListPageState extends NotificationListState {
  final List<SingleNotification> notificationList;
  final SingleNotification? singleNotification;
  final bool loading;
  final bool pagError;
  final int notificationsNotRead;

  NotificationListPageState({
    required this.notificationsNotRead,
    this.notificationList = const [],
    this.singleNotification,
    this.loading = false,
    this.pagError = false,
  }) : super();
}

class NotificationListLoadedFailedState extends NotificationListState {
  NotificationListLoadedFailedState() : super();
}
