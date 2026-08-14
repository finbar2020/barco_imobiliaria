part of shared_features;

class NotificationListBloc extends Bloc {
  NotificationListBloc() : super(NotificationListEmptyState()) {
    on<NotificationLoadingEvent>(handlNotificationLoadingEvent);
    on<NotificationFailedEvent>(handlNotificationFailedEvent);
    on<NotificationSuccessEvent>(handlNotificationSuccessEvent);
  }

  void handlNotificationLoadingEvent(
      NotificationLoadingEvent event, Emitter emit) {
    emit(NotificationListLoadingState());
  }

  void handlNotificationFailedEvent(
      NotificationFailedEvent event, Emitter emit) {
    emit(NotificationListLoadedFailedState());
  }

  void handlNotificationSuccessEvent(
      NotificationSuccessEvent event, Emitter emit) {
    emit(NotificationListPageState(
      notificationsNotRead: event.notificationsNotRead,
      loading: event.loading,
      notificationList: event.notificationList,
      pagError: event.pagError,
      singleNotification: event.singleNotification,
    ));
  }
}
