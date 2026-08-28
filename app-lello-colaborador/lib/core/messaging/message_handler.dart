import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/core/messaging/use_case/ghost_notification_usecase.dart';
import 'package:colaborador/core/navigation/application_route.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_state.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_page/page/timesheet_page.dart';
import 'package:colaborador/lello_app.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/comfort_page_origin_enum.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_page.dart';
import 'package:shared_features/feature/notifications/data/models/notification_model.dart';
import 'package:shared_features/feature/notifications/domain/entities/features_routes_enum.dart';
import 'package:shared_features/shared_features.dart';

bool isFirstBuild = true;

class MessageHandler extends StatefulWidget {
  final Widget appWidget;
  final NotificationController notificationController;

  const MessageHandler(
      {super.key,
      required this.appWidget,
      required this.notificationController});
  @override
  MessageHandlerState createState() => MessageHandlerState();
}

class MessageHandlerState extends State<MessageHandler> {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final SessionBloc sessionBloc =
      ApplicationContainer.instance().resolve<SessionBloc>();
  SendPushCallback sendPushCallback =
      ApplicationContainer.instance().resolve<SendPushCallback>();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String? selectedNotificationPayload;

  StreamSubscription? _sessionSubscription;
  StreamSubscription? _onMessageOpenedAppSubscription;
  StreamSubscription? _onMessageSubscription;

  @override
  void initState() {
    getToken();
    super.initState();
    const String groupChannelId = 'app.lello.colaborador.notificacao';
    const String groupChannelName = 'app.lello.colaborador.notificacao';
    const String groupChannelDescription = 'app.lello.colaborador.notificacao';

    var initializationSettingsAndroid = const AndroidInitializationSettings(
        '@mipmap/ic_launcher'); // <- default icon name is @mipmap/ic_launcher
    var initializationSettingsiOS = const DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsiOS);

    flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (details) async {
        selectNotification(details.payload);
      },
    );

    if (isFirstBuild) {
      _fcm.getInitialMessage().then((message) async {
        isFirstBuild = false;
        if (message != null) {
          final NotificationModel data =
              NotificationModel.fromJson(message.data);
          switchRedirect(data);
        }
      });
    }

    _onMessageOpenedAppSubscription =
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        log('FCM: onLauch $message');
      }
      NotificationModel data = NotificationModel.fromJson(message.data);
      if (data.id != null) {
        sendPushCallback.call(SendPushCallbackParams(
          notificationId: data.id!,
          type: NotificationCallbackType.CLICOU,
        ));
      }
      widget.notificationController.getNotificationList();
      switchRedirect(data);
    });

    _onMessageSubscription =
        FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (kDebugMode) {
        log('FCM: onMessage: $message');
        log('${message.notification?.body}');
      }
      if (message.notification == null) {
        GhostNotificationUsecase usecase =
            ApplicationContainer.instance().resolve();
        var id = message.data["id"];
        var type = message.data["tipoNotification"];
        await usecase.call(GhostNotificationParams(
          id: id,
          type: type,
        ));
        return;
      } else {
        NotificationModel data = NotificationModel.fromJson(message.data);
        if (data.id != null) {
          sendPushCallback.call(SendPushCallbackParams(
            notificationId: data.id!,
            type: NotificationCallbackType.CLICOU,
          ));
        }
        widget.notificationController.getNotificationList();
      }

      final NotificationModel data = NotificationModel.fromJson(message.data);
      var notificationSpecifics = setNotificationDetailsAndroid(
        data,
        groupChannelId,
        groupChannelName,
        groupChannelDescription,
      );

      await flutterLocalNotificationsPlugin.show(
          id: 0,
          title: message.notification?.title,
          body: message.notification?.body,
          notificationDetails: notificationSpecifics,
          payload: json.encode(message.data));
    });

    if (sessionBloc.state is SessionLoadedState) {
      _onSessionChanged(sessionBloc.state);
    } else {
      _sessionSubscription = sessionBloc.stream.listen(_onSessionChanged);
    }
  }

  Future<void> _onSessionChanged(SessionState sessionState) async {
    if (sessionState is SessionLoadedState) {
      _checkBackgroundMessages();
    }
  }

  @override
  void dispose() {
    _sessionSubscription?.cancel();
    // Os streams de push são estáticos: sem cancelar, um estado já descartado
    // continua reagindo às mensagens e navega com um `context` morto.
    _onMessageOpenedAppSubscription?.cancel();
    _onMessageSubscription?.cancel();
    super.dispose();
  }

  getToken() async {
    _fcm.getToken().then((token) {
      if (kDebugMode) {
        log("FCM: $token");
      }
    });
  }

  NotificationDetails setNotificationDetailsAndroid(
    NotificationModel data,
    String groupChannelId,
    String groupChannelName,
    String groupChannelDescription,
  ) {
    AndroidNotificationDetails firstNotificationAndroidSpecifics =
        AndroidNotificationDetails(
            data.module ?? groupChannelId, data.module ?? groupChannelName,
            channelDescription: groupChannelDescription,
            importance: Importance.max,
            priority: Priority.high,
            groupKey: 'app.lello.colaborador.notificacao');
    DarwinNotificationDetails iosNotificationSpecifics =
        DarwinNotificationDetails(
      threadIdentifier: data.module ?? groupChannelId,
      categoryIdentifier: data.module ?? groupChannelId,
    );
    NotificationDetails secondNotificationPlatformSpecifics =
        NotificationDetails(
            android: firstNotificationAndroidSpecifics,
            iOS: iosNotificationSpecifics);
    return secondNotificationPlatformSpecifics;
  }

  void switchRedirect(NotificationModel model) {
    String? newRote;

    FeaturesRoutesEnum? routesEnum =
        stringToEnum(FeaturesRoutesEnum.values, model.redirectPath);

    dynamic args;

    if (routesEnum != null) {
      switch (routesEnum) {
        case FeaturesRoutesEnum.ESPELHO_PONTO:
          args = TimesheetPageArgs(period: model.redirectId);
          newRote = ApplicationRoute.timesheet;
          break;
        //Comodidades
        case FeaturesRoutesEnum.COMODIDADES:
        case FeaturesRoutesEnum.COMODIDADES_CATEGORIA:
        case FeaturesRoutesEnum.COMODIDADES_PARCEIRO:
          newRote = SharedApplicationRoute.comfort;
          args = ComfortPageArgs(
            appOriginEnum: AppOriginEnum.employee,
            reference: sessionBloc.getSession?.condominiumReference ?? "",
            accessRouteOrigin: ComfortPageOriginEnum.inAppNotification,
            route: routesEnum,
            comfortNotificationContext: model.redirectId,
          );
          break;
        default:
      }
    } else {
      if (LelloApp.routes.keys
          .any((element) => element == model.redirectPath)) {
        newRote = model.redirectPath;
      } else {
        routesEnum = FeaturesRoutesEnum.NOTIFICACOES_NAO_LIDAS;
      }
    }
    if (newRote != null) {
      Navigator.popUntil(
          context, ModalRoute.withName(SharedApplicationRoute.home));
      Navigator.of(context).pushNamed(newRote, arguments: args);
    } else {
      Navigator.popUntil(
          context, ModalRoute.withName(SharedApplicationRoute.home));
    }
  }

  void selectNotification(String? payload) async {
    if (payload == null) {
      return;
    }
    debugPrint('notification payload: $payload');
    final NotificationModel data =
        NotificationModel.fromJson(json.decode(payload));
    if (data.id != null) {
      sendPushCallback.call(SendPushCallbackParams(
        notificationId: data.id!,
        type: NotificationCallbackType.CLICOU,
      ));
    }
    switchRedirect(data);
  }

  @override
  Widget build(BuildContext context) {
    return widget.appWidget;
  }

  void _checkBackgroundMessages() {
    if (mounted) {
      SharedPreferences.getInstance().then((value) {
        var lastNotificationBackgorund =
            value.getString(SharedPreferencesKeys.backgroundNotification);
        if (lastNotificationBackgorund?.isNotEmpty == true) {
          value.remove(SharedPreferencesKeys.backgroundNotification);
          var notificationMap = json.decode(lastNotificationBackgorund!);
          var notification = RemoteMessage.fromMap(notificationMap);
          NotificationModel model =
              NotificationModel.fromJson(notification.data);
          switchRedirect(model);
        }
      });
    }
  }
}
