import 'dart:convert';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/messaging/use_case/ghost_notification_usecase.dart';
import 'package:lello/feature/home/presentation/page/home_page.dart';
import 'package:lello/lello_app.dart';
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
  _MessageHandlerState createState() => _MessageHandlerState();
}

class _MessageHandlerState extends State<MessageHandler> {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  SendPushCallback sendPushCallback =
      ApplicationContainer.instance().resolve<SendPushCallback>();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String? selectedNotificationPayload;

  getToken() async {
    _fcm.getToken().then((token) => print(token));
  }

  @override
  void initState() {
    // TODO: implement initState
    getToken();
    super.initState();
    const String groupChannelId = 'app.lello.sindico.notificacao_id';
    const String groupChannelName = 'app.lello.sindico.notificacao_name';
    const String groupChannelDescription =
        'app.lello.sindico.notificacao_description';

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

    // <- default icon name is @mipmap/ic_launcher

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('FCM: onLauch $message');
      final NotificationModel data = NotificationModel.fromJson(message.data);
      SendPushCallback sendPushCallback =
          ApplicationContainer.instance().resolve<SendPushCallback>();
      if (data.id != null) {
        sendPushCallback.call(SendPushCallbackParams(
          notificationId: data.id!,
          type: NotificationCallbackType.CLICOU,
        ));
      }
      widget.notificationController.getNotificationList();
      switchRedirect(data);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('FCM: onMessage: $message');
      print('${message.notification?.body}');

      final NotificationModel data = NotificationModel.fromJson(message.data);
      if (message.notification == null) {
        GhostNotificationUsecase usecase =
            ApplicationContainer.instance().resolve();
        String? id = message.data["id"];
        String? type = message.data["tipoNotification"];
        await usecase.call(GhostNotificationParams(
          id: id ?? "",
          type: type ?? "UPDATE_FCM_TOKEN",
        ));
        return;
      } else {
        final NotificationModel data = NotificationModel.fromJson(message.data);
        if (data.id != null) {
          sendPushCallback.call(SendPushCallbackParams(
            notificationId: data.id!,
            type: NotificationCallbackType.RECEBEU,
          ));
        }
        widget.notificationController.getNotificationList();
      }
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
          payload: jsonEncode(data));
    });

    if (isFirstBuild) {
      _fcm.getInitialMessage().then((message) async {
        print('FCM: getInitialMessage: $message');
        print('FCM: getInitialMessage: ${message?.toMap()}');
        isFirstBuild = false;
        if (message != null) {
          final NotificationModel data =
              NotificationModel.fromJson(message.data);
          switchRedirect(data);
        }
      });
    }
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
            groupKey: 'app.lello.sindico.notificacao_key');
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

  void switchRedirect(NotificationModel data) {
    print('FCM: switchRedirect: ${data.toJson()}');
    FeaturesRoutesEnum? routesEnum =
        stringToEnum(FeaturesRoutesEnum.values, data.redirectPath);

    print('FCM: switchRedirect - routesEnum: $routesEnum');
    if (routesEnum == null) {
      if (LelloApp.routes.keys.any((element) => element == data.redirectPath)) {
        if (mounted) {
          Navigator.popUntil(
              context, ModalRoute.withName(SharedApplicationRoute.home));
          Navigator.of(context).pushNamed(data.redirectPath!);
        }
        return;
      } else {
        routesEnum = FeaturesRoutesEnum.NOTIFICACOES_NAO_LIDAS;
      }
    }

    if (data.canRedirect) {
      if (mounted && data.redirectPath != null) {
        Navigator.popUntil(
            context, ModalRoute.withName(SharedApplicationRoute.home));
        Navigator.of(context).pushReplacementNamed(
          SharedApplicationRoute.home,
          arguments: HomePageArgs(
            redirectRoute: SharedApplicationRedirectRoute(
              context: data.reference,
              rote: data.redirectPath!,
              objectId: data.redirectId,
              inApp: data.inApp ?? false,
              notificationId: data.id,
              uuidGroup: data.uuidGroup ?? "",
            ),
          ),
        );
      }
    }
  }

  void selectNotification(String? payload) async {
    if (payload == null) {
      return;
    }
    debugPrint('notification payload: $payload');
    if (payload.isEmpty) {
      return;
    }
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
}
