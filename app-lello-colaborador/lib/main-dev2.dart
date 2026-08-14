import 'dart:convert';
import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:colaborador/core/background/background_worker.dart';
import 'package:colaborador/core/background/sync_digital_points_worker.dart';
import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/core/messaging/use_case/ghost_notification_usecase.dart';
import 'package:colaborador/environment/environment.dev2.dart';
import 'package:colaborador/firebase_options_lello.dart';
import 'package:colaborador/firebase_options_hubert.dart';
import 'package:colaborador/lello_app.dart';
import 'package:essentials/analytics/adjust/analytics_adjust_config.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/shared_features.dart';

@pragma('vm:entry-point')
void callbackDispatcher() async {
  Workmanager().executeTask((task, inputData) async {
    FirebaseOptions options;
    switch (FlavorConfig.currentBrand) {
      case Brand.hubert:
        options = DefaultFirebaseOptionsHubert.currentPlatform;
        break;
      case Brand.lello:
        options = DefaultFirebaseOptionsLello.currentPlatform;
        break;
    }
    await Firebase.initializeApp(options: options);
    await Hive.initFlutter();
    WidgetsFlutterBinding.ensureInitialized();
    FlavorConfig.init();
    await ApplicationContainer.instance().setUp(Dev2Environment());

    if (task == SyncDigitalPointsWorker.taskName) {
      try {
        final syncPointsWorker =
            ApplicationContainer.instance().resolve<SyncDigitalPointsWorker>();

        return syncPointsWorker.syncPoints();
      } catch (err) {
        debugPrint("Erro ao Enviar Pontos");
        return Future.error(err);
      }
    }

    // initialise the plugin of flutterlocalnotifications.
    FlutterLocalNotificationsPlugin flip = FlutterLocalNotificationsPlugin();

    // app_icon needs to be a added as a drawable
    // resource to the Android head project.
    var android = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios = const DarwinInitializationSettings();

    // initialise settings for both Android and iOS device.
    var settings = InitializationSettings(android: android, iOS: ios);
    flip.initialize(settings: settings);

    var worker = BackgroundWorker(
        ApplicationContainer.instance(), flip, task, inputData);
    return Future.value(worker.executeBackgroundWork().timeout(
          const Duration(seconds: 30),
          onTimeout: () => false,
        ));
  });
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    FirebaseOptions options;
    switch (FlavorConfig.currentBrand) {
      case Brand.hubert:
        options = DefaultFirebaseOptionsHubert.currentPlatform;
        break;
      case Brand.lello:
        options = DefaultFirebaseOptionsLello.currentPlatform;
        break;
    }
    await Firebase.initializeApp(options: options);
  }
  await Hive.initFlutter();

  if (kDebugMode) {
    log('FCM: background message ${message.messageId}');
    log('FCM: background message: $message');
    log('FCM: background message: ${message.data["is_ghost"]}');
  }
  if (message.notification == null) {
    await _sendGhostNotification(message);
  } else {
    var sharedP = await SharedPreferences.getInstance();
    sharedP.setString(SharedPreferencesKeys.backgroundNotification,
        json.encode(message.toMap()));
    await _sendPushCallback(message);
  }
}

Future _sendGhostNotification(RemoteMessage message) async {
  try {
    var usecase =
        ApplicationContainer.instance().resolve<GhostNotificationUsecase>();
    var id = message.data["id"];
    var type = message.data["tipoNotification"];
    await usecase.call(GhostNotificationParams(
      id: id,
      type: type,
    ));
  } catch (e) {
    await ApplicationContainer.instance().setUp(Dev2Environment());
    var usecase =
        ApplicationContainer.instance().resolve<GhostNotificationUsecase>();
    var id = message.data["id"];
    var type = message.data["tipoNotification"];
    await usecase.call(GhostNotificationParams(
      id: id,
      type: type,
    ));
  }
}

Future _sendPushCallback(RemoteMessage message) async {
  try {
    var usecase = ApplicationContainer.instance().resolve<SendPushCallback>();
    var id = message.data["id"];
    await usecase.call(SendPushCallbackParams(
      notificationId: id,
      type: NotificationCallbackType.RECEBEU,
    ));
  } catch (e) {
    await ApplicationContainer.instance().setUp(Dev2Environment());
    var usecase = ApplicationContainer.instance().resolve<SendPushCallback>();
    var id = message.data["id"];
    await usecase.call(SendPushCallbackParams(
      notificationId: id,
      type: NotificationCallbackType.RECEBEU,
    ));
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlavorConfig.init();
  FirebaseOptions firebaseOptions;
  switch (FlavorConfig.currentBrand) {
    case Brand.hubert:
      firebaseOptions = DefaultFirebaseOptionsHubert.currentPlatform;
      break;
    case Brand.lello:
      firebaseOptions = DefaultFirebaseOptionsLello.currentPlatform;
      break;
  }
  await Firebase.initializeApp(options: firebaseOptions);
  await Hive.initFlutter();

  WidgetsFlutterBinding.ensureInitialized();

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);

  // Initialize Adjust Analytics
  await AnalyticsAdjustConfig.initPlatformState(
      appOriginEnum: AppOriginEnum.employee,
      adjustEnvironment: AdjustEnvironment.sandbox);
  await ApplicationContainer.instance().setUp(Dev2Environment());

  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  await AppInfo.init();

  runApp(const LelloApp());
}

void downloadCallback(String id, int status, int progress) {
  final SendPort send =
      IsolateNameServer.lookupPortByName('downloader_send_port')!;
  send.send([id, status, progress]);
}
