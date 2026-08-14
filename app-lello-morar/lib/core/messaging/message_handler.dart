import 'dart:convert';

import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/messaging/use_case/ghost_notification_usecase.dart';
import 'package:morar/feature/home/presentation/page/home_navigation_page.dart';
import 'package:morar/lello_app.dart';
import 'package:shared_features/feature/notifications/data/models/notification_model.dart';
import 'package:shared_features/feature/notifications/domain/entities/features_routes_enum.dart';
import 'package:shared_features/shared_features.dart';

bool isFirstBuild = true;

class MessageHandler extends StatefulWidget {
  final Widget appWidget;
  final NotificationController notificationController;

  MessageHandler(
      {required this.appWidget, required this.notificationController});
  @override
  _MessageHandlerState createState() => _MessageHandlerState();
}

class _MessageHandlerState extends State<MessageHandler> {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String? selectedNotificationPayload;
  final String _key = SharedPreferencesKeys.ownerMessageDataCached;
  SendPushCallback sendPushCallback =
      ApplicationContainer.instance().resolve<SendPushCallback>();

  getToken() async {
    _fcm.getToken().then((token) => print(token));
  }

  @override
  void initState() {
    getToken();
    super.initState();
    const String groupChannelId = 'app.lello.morar.notificacao';
    const String groupChannelName = 'app.lello.morar.notificacao';
    const String groupChannelDescription = 'app.lello.morar.notificacao';

    var initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    ); // <- default icon name is @mipmap/ic_launcher
    var initializationSettingsiOS = DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsiOS);

    flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (details) async {
        print(
            'flutterLocalNotificationsPlugin: onDidReceiveNotificationResponse: ${details.payload}');
        selectNotification(details.payload);
      },
    );

    // <- default icon name is @mipmap/ic_launcher

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print('FCM: onLauch $message');
      final NotificationModel data = NotificationModel.fromJson(message.data);
      var checkNeedsUpdate = await AppUpdateConfig.checkNeedsUpdate(
          appOriginEnum: AppOriginEnum.owner);
      if (data.id != null) {
        sendPushCallback.call(SendPushCallbackParams(
          notificationId: data.id!,
          type: NotificationCallbackType.CLICOU,
        ));
      }

      widget.notificationController.getNotificationList();

      if (checkNeedsUpdate?.needsUpdate == NeedsUpdate.mandatory) {
        saveMessageInCache(data: data);
        return;
      } else {
        switchRedirect(data);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('FCM: onMessage: $message');
      print('FCM: onMessage: ${message.notification?.body}');
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
          payload: jsonEncode(message.data));
    });

    if (isFirstBuild) {
      _fcm.getInitialMessage().then((message) async {
        print('FCM: getInitialMessage: $message');
        print('FCM: getInitialMessage: ${message?.toMap()}');
        isFirstBuild = false;
        var checkNeedsUpdate = await AppUpdateConfig.checkNeedsUpdate(
            appOriginEnum: AppOriginEnum.owner);
        final prefs = await SharedPreferences.getInstance();
        if (message != null) {
          final NotificationModel data =
              NotificationModel.fromJson(message.data);
          switchRedirect(data);
        } else {
          if (checkNeedsUpdate?.needsUpdate != NeedsUpdate.mandatory) {
            var dataSaved = prefs.get(_key) as String?;
            if (dataSaved != null && dataSaved.isNotEmpty) {
              NotificationModel messageDataSaved =
                  NotificationModel.fromJson(jsonDecode(dataSaved));
              switchRedirect(messageDataSaved);
              prefs.remove(_key);
            }
          }
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
            groupKey: 'app.lello.morar.notificacao');
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

  //Seguir com processo de indeficação da rota
  //Criar parametro de redirecionamento para homerpage
  //passar função como argumento
  //Classe na home

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
      if (mounted) {
        Navigator.popUntil(
            context, ModalRoute.withName(SharedApplicationRoute.home));
        Navigator.of(context).pushReplacementNamed(
          SharedApplicationRoute.home,
          arguments: HomeNavigationPageArgs(
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
    var checkNeedsUpdate = await AppUpdateConfig.checkNeedsUpdate(
        appOriginEnum: AppOriginEnum.owner);
    if (data.id != null) {
      sendPushCallback.call(SendPushCallbackParams(
        notificationId: data.id!,
        type: NotificationCallbackType.CLICOU,
      ));
    }

    if (checkNeedsUpdate?.needsUpdate == NeedsUpdate.mandatory) {
      saveMessageInCache(data: data);
      return;
    } else {
      switchRedirect(data);
    }
  }

  void saveMessageInCache({required NotificationModel data}) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_key, jsonEncode(data));
  }

  @override
  Widget build(BuildContext context) {
    return widget.appWidget;
  }
}
