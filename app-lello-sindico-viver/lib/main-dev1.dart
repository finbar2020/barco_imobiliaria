import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:essentials/analytics/adjust/analytics_adjust_config.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/messaging/use_case/ghost_notification_usecase.dart';
import 'package:lello/environment/environment.custom.dart';
import 'package:lello/environment/environment.dev1.dart';
import 'package:lello/firebase_options.dart';
import 'package:shared_features/core/database/banners/banners_args_hive_model.dart';
import 'package:shared_features/core/database/banners/banners_hive_model.dart';
import 'package:shared_features/shared_features.dart';
import 'package:sindico_viver/firebase_options_hubert.dart';
import 'package:sindico_viver/firebase_options_lello.dart';
import 'package:sindico_viver/lello_viver_app.dart';

Environment _env = DevelopmentProj1Environment();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    FirebaseOptions options;

    switch (FlavorConfig.currentBrand) {
      case Brand.hubert:
        options = DefaultFirebaseOptionsHubert.currentPlatform;
        break;
      case Brand.lello:
        options = DefaultFirebaseOptionsLelloViver.currentPlatform;
        break;
    }

    await Firebase.initializeApp(
      options: options,
    );
  }
  await Hive.initFlutter();
  print('FCM: background message ${message.messageId}');

  print('FCM: background message: $message');
  print('FCM: background message: ${message.data["is_ghost"]}');
  if (message.notification == null) {
    await _sendGhostNotification(message);
  } else {
    await _sendPushCallback(message);
  }
}

Future _sendGhostNotification(RemoteMessage message) async {
  try {
    var usecase =
        ApplicationContainer.instance().resolve<GhostNotificationUsecase>();
    String? id = message.data["id"];
    String? type = message.data["tipoNotification"];
    await usecase.call(GhostNotificationParams(
      id: id ?? "",
      type: type ?? "UPDATE_FCM_TOKEN",
    ));
  } catch (e) {
    await ApplicationContainer.instance().setUp(await getEnv());
    var usecase =
        ApplicationContainer.instance().resolve<GhostNotificationUsecase>();
    String? id = message.data["id"];
    String? type = message.data["tipoNotification"];
    await usecase.call(GhostNotificationParams(
      id: id ?? "",
      type: type ?? "UPDATE_FCM_TOKEN",
    ));
  }
}

Future _sendPushCallback(RemoteMessage message) async {
  try {
    if (message.data["id"] == null) {
      return;
    }
    var usecase = ApplicationContainer.instance().resolve<SendPushCallback>();
    var id = message.data["id"];
    await usecase.call(SendPushCallbackParams(
      notificationId: id,
      type: NotificationCallbackType.RECEBEU,
    ));
  } catch (e) {
    await ApplicationContainer.instance().setUp(await getEnv());
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
  FirebaseOptions options;

  switch (FlavorConfig.currentBrand) {
    case Brand.hubert:
      options = DefaultFirebaseOptionsHubert.currentPlatform;
      break;
    case Brand.lello:
      options = DefaultFirebaseOptionsLelloViver.currentPlatform;
      break;
  }

  await Firebase.initializeApp(
    options: options,
  );
  await Hive.initFlutter();

  Logger.root.level = _env.isProduction ? Level.OFF : Level.ALL;
  Logger.root.onRecord.listen((record) {
    if (kDebugMode) {
      log(
        record.message,
        level: 800,
        name: record.level.name,
        time: record.time,
      );
    }
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  Hive.registerAdapter(BannersHiveAdapter());
  Hive.registerAdapter(BannersArgsHiveModelAdapter());

  // Initialize Adjust Analytics
  await AnalyticsAdjustConfig.initPlatformState(
      appOriginEnum: AppOriginEnum.manager,
      adjustEnvironment: AdjustEnvironment.sandbox);

  await ApplicationContainer.instance().setUp(await getEnv());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await AppInfo.init();

  runApp(LelloViverApp());
}

Future<Environment> getEnv() async {
  var sharedP = await SharedPreferences.getInstance();

  if (sharedP.containsKey(SharedPreferencesKeys.customURL)) {
    _env = CustomEnvironment(
        apiUrl: sharedP.getString(SharedPreferencesKeys.customURL)!);
  }
  return _env;
}

void downloadCallback(String id, int status, int progress) {
  final SendPort send =
      IsolateNameServer.lookupPortByName('downloader_send_port')!;
  send.send([id, status, progress]);
}
