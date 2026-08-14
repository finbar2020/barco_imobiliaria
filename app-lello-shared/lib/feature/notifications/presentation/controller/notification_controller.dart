// ignore_for_file: invalid_use_of_visible_for_testing_member

part of shared_features;

class NotificationController {
  final NotificationListBloc bloc;
  final dynamic sessionBloc;
  final GetNotifications getNotifications;
  final ReadNotification readNotifications;
  final MarkAllReadNotification markAllReadNotificationUseCase;
  final DeleteAllReadNotification deleteAllReadNotificationUseCase;
  final DeleteNotification deleteNotificationUseCase;
  final NotificationResume notificationResumeUseCase;
  final AppOriginEnum appOriginEnum;

  NotificationController({
    required this.bloc,
    required this.sessionBloc,
    required this.getNotifications,
    required this.readNotifications,
    required this.markAllReadNotificationUseCase,
    required this.deleteAllReadNotificationUseCase,
    required this.deleteNotificationUseCase,
    required this.notificationResumeUseCase,
    required this.appOriginEnum,
  });

  List<SingleNotification> notifications = [];
  int notificationsNotRead = 0;
  int limit = 10;
  int page = 1;
  String? redirectNotificationId;
  String? redirectUuidGroup;
  bool _isLoadingNotifications = false;

  String? get getCurrentContext {
    try {
      if (appOriginEnum == AppOriginEnum.owner) {
        return sessionBloc.state.session?.unity?.id;
      } else if (appOriginEnum == AppOriginEnum.employee) {
        return sessionBloc.getSession?.condominium.id;
      } else if (appOriginEnum == AppOriginEnum.manager) {
        return sessionBloc.state.session?.selectedCondominium?.id;
      }
    } on Exception {
      return null;
    }
    return null;
  }

  Future getNotificationList() async {
    // Evitar múltiplas chamadas simultâneas
    if (_isLoadingNotifications) {
      print(
          'NotificationController: Ignorando chamada duplicada de getNotificationList');
      return;
    }

    _isLoadingNotifications = true;
    notifications = [];
    bloc.add(NotificationLoadingEvent());

    String? unitId = _getIdFromAppOwner();
    if (unitId == null) {
      bloc.add(NotificationFailedEvent());
      _isLoadingNotifications = false;
      return;
    }

    try {
      final results = await Future.wait([
        getNotifications.call(
            new GetNotificationParams(reference: unitId, limit: 10, page: 1)),
        notificationResumeUseCase.call(NotificationResumeParams(reference: "")),
      ]);

      final list = results[0] as Try<Paginator>;
      final resume = results[1] as Try<NotificationResumeEntity>;

      resume.fold((l) => null, (r) {
        notificationsNotRead = (r.totalIgnored ?? 0) + (r.totalReceived ?? 0);
      });

      list.fold((err) => bloc.add(NotificationFailedEvent()), (res) {
        try {
          page = 1;
          if (res.data.length != null || res.data.isNotEmpty) {
            List.generate(res.data.length, (i) {
              Map<String, dynamic> map = res.data[i];
              NotificationModel model = NotificationModel.fromJson(map);
              var item = model.toEntity(page: page);
              notifications.add(item);
              final ids = notifications.map((e) => e.id).toSet();
              notifications.retainWhere((x) => ids.remove(x.id));
              item.index = notifications.indexOf(item);
            });
          }
          bloc.add(NotificationSuccessEvent(
              notificationsNotRead: notificationsNotRead,
              notificationList: notifications));
        } catch (e) {
          bloc.add(NotificationFailedEvent());
        }
      });
    } finally {
      _isLoadingNotifications = false;
    }
  }

  Future loadSingleNotification(
      {bool fromPush = false, required String notificationId}) async {
    String? unitId = _getIdFromAppOwner();
    if (unitId == null) {
      bloc.add(NotificationFailedEvent());
      return;
    }

    if (fromPush == false) {
      readNotifications
          .call(new ReadNotificationParams(notificationId: notificationId));
      if (notificationsNotRead > 0) {
        notificationsNotRead -= 1;
      }
      bloc.add(NotificationSuccessEvent(
          notificationsNotRead: notificationsNotRead,
          notificationList: notifications));
    } else {
      bloc.add(NotificationLoadingEvent());
      final response = await readNotifications
          .call(new ReadNotificationParams(notificationId: notificationId));

      response.fold(
        (l) => bloc.add(NotificationFailedEvent()),
        (r) => bloc.add(NotificationSuccessEvent(
            notificationsNotRead: notificationsNotRead,
            notificationList: notifications)),
      );
    }
  }

  Future loadPagination() async {
    var currentPage = page;
    bloc.add(NotificationSuccessEvent(
        loading: true,
        notificationsNotRead: notificationsNotRead,
        notificationList: notifications));

    String? unitId = _getIdFromAppOwner();
    if (unitId == null) {
      bloc.add(NotificationFailedEvent());
      return;
    }

    if (notifications.length > 0) {
      page += 1;
    }

    final response = await getNotifications.call(
        new GetNotificationParams(reference: unitId, limit: limit, page: page));

    response.fold((err) {
      page = currentPage;
      bloc.add(NotificationSuccessEvent(
          loading: false,
          pagError: true,
          notificationsNotRead: notificationsNotRead,
          notificationList: notifications));
    }, (res) {
      try {
        if (res.data.length != null || res.data.isNotEmpty) {
          List.generate(res.data.length, (i) {
            Map<String, dynamic> map = res.data[i];
            NotificationModel model = NotificationModel.fromJson(map);
            var item = model.toEntity(page: page);
            notifications.add(item);
            final ids = notifications.map((e) => e.id).toSet();
            notifications.retainWhere((x) => ids.remove(x.id));
            item.index = notifications.indexOf(item);
          });
        }
        bloc.add(NotificationSuccessEvent(
            notificationsNotRead: notificationsNotRead,
            notificationList: notifications));
      } catch (e) {
        bloc.add(NotificationFailedEvent());
      }
    });
  }

  Future markAllRead() async {
    bloc.add(NotificationLoadingEvent());

    String? unitId = _getIdFromAppOwner();
    if (unitId == null) {
      bloc.add(NotificationFailedEvent());
      return;
    }
    final response = await markAllReadNotificationUseCase
        .call(new MarkAllReadNotificationParams(reference: unitId));

    response.fold(
      (err) => bloc.add(NotificationFailedEvent()),
      (res) {
        List<SingleNotification> newNotifications =
            List.generate(notifications.length, (index) {
          notifications[index].markRead = true;
          return notifications[index];
        });
        notifications = newNotifications;
        notificationsNotRead = 0;
        bloc.add(NotificationSuccessEvent(
            notificationsNotRead: notificationsNotRead,
            notificationList: notifications));
      },
    );
  }

  Future deleteAllRead({required bool read}) async {
    bloc.add(NotificationLoadingEvent());

    String? unitId = _getIdFromAppOwner();
    if (unitId == null) {
      bloc.add(NotificationFailedEvent());
      return;
    }
    final response = await deleteAllReadNotificationUseCase
        .call(new DeleteAllReadNotificationParams(read: read));

    response.fold((err) => bloc.add(NotificationFailedEvent()), (res) {
      List<SingleNotification> newNotifications = notifications;
      if (read) {
        notifications.removeWhere((element) => element.markRead == true);
        newNotifications = notifications;
      } else {
        notifications = [];
        newNotifications = [];
        notificationsNotRead = 0;
      }
      bloc.add(NotificationSuccessEvent(
          notificationsNotRead: notificationsNotRead,
          notificationList: newNotifications));
    });
  }

  Future deleteNotification({required String notificationId}) async {
    bloc.add(NotificationLoadingEvent());

    String? unitId = _getIdFromAppOwner();
    if (unitId == null) {
      bloc.add(NotificationFailedEvent());
      return;
    }
    final response = await deleteNotificationUseCase
        .call(new DeleteNotificationParams(notificationId: notificationId));

    response.fold((err) => bloc.add(NotificationFailedEvent()), (res) {
      List<SingleNotification> newNotifications = notifications;
      notifications.removeWhere((element) => element.id == notificationId);
      newNotifications = notifications;
      bloc.add(NotificationSuccessEvent(
          notificationsNotRead: notificationsNotRead,
          notificationList: newNotifications));
    });
  }

  Future setState(NotificationListState state) async {
    bloc.emit(state);
  }

  String? _getIdFromAppOwner() {
    if (appOriginEnum == AppOriginEnum.owner) {
      return sessionBloc.state.session?.unity?.id;
    } else if (appOriginEnum == AppOriginEnum.employee) {
      return sessionBloc.getSession?.condominium.id;
    } else {
      return sessionBloc.state.session?.selectedCondominium?.id;
    }
  }

  void setRedirectNotificationId(String? redirectNotificationId) {
    this.redirectNotificationId = redirectNotificationId;
  }

  void setUuidGroup(String? uuidGroup) {
    this.redirectUuidGroup = uuidGroup;
  }

  void setRedirectNotification(String? notificationId, String uuidGroup) {
    this.redirectNotificationId = redirectNotificationId;
    this.redirectUuidGroup = uuidGroup;
  }
}
