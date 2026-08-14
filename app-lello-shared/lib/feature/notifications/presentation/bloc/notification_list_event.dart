part of shared_features;

abstract class NotificationListEvent {}

class NotificationLoadingEvent extends NotificationListEvent {}

class NotificationFailedEvent extends NotificationListEvent {}

class NotificationSuccessEvent extends NotificationListEvent {
  final List<SingleNotification> notificationList;
  final SingleNotification? singleNotification;
  final bool loading;
  final bool pagError;
  final int notificationsNotRead;

  NotificationSuccessEvent({
    required this.notificationsNotRead,
    this.notificationList = const [],
    this.singleNotification,
    this.loading = false,
    this.pagError = false,
  }) : super();
}
