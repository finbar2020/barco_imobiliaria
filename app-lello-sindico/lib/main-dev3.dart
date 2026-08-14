import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:essentials/analytics/adjust/analytics_adjust_config.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/messaging/use_case/ghost_notification_usecase.dart';
import 'package:lello/core/services/tt_firebase_app.dart';
import 'package:lello/environment/environment.dev3.dart';
import 'package:lello/firebase_options.dart';
import 'package:lello/lello_app.dart';
import 'package:shared_features/shared_features.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
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
    // Ensure container is initialized
    if (!ApplicationContainer.instance().isInitialized) {
      await ApplicationContainer.instance()
          .setUp(DevelopmentProj3Environment());
    }

    var usecase =
        ApplicationContainer.instance().resolve<GhostNotificationUsecase>();
    var id = message.data["id"];
    var type = message.data["tipoNotification"];
    await usecase.call(GhostNotificationParams(
      id: id,
      type: type,
    ));
  } catch (e) {
    print('Error sending ghost notification: $e');
  }
}

Future _sendPushCallback(RemoteMessage message) async {
  try {
    if (message.data["id"] == null) {
      return;
    }

    // Ensure container is initialized
    if (!ApplicationContainer.instance().isInitialized) {
      await ApplicationContainer.instance()
          .setUp(DevelopmentProj3Environment());
    }

    var usecase = ApplicationContainer.instance().resolve<SendPushCallback>();
    var id = message.data["id"];
    await usecase.call(SendPushCallbackParams(
      notificationId: id,
      type: NotificationCallbackType.RECEBEU,
    ));
  } catch (e) {
    print('Error sending push callback: $e');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlavorConfig.init();

  // Inicializa Firebase com proteção contra duplicação
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);
    }
  } catch (e) {
    // Firebase já foi inicializado (provavelmente pelo background handler)
    print('Firebase já inicializado: $e');
  }

  // Inicializa Firebase secundário para bucket de desenvolvimento (lello-98641)
  try {
    if (!TTFirebaseApp.isAppInitialized('dev3_storage')) {
      await TTFirebaseApp.initializeSecondary(
        appName: 'dev3_storage',
        config: FirebaseConfig(
          projectId: 'lello-98641',
          storageBucket: 'lello-98641.appspot.com',
          apiKey: Platform.isIOS
              ? 'AIzaSyDcMka1qodng8R17UWJDLN-MP7BImfDJW8'
              : 'AIzaSyBB_Bo9jLnLImHEjrTeU8PEt5qas3v6_LI',
          appId: Platform.isIOS
              ? '1:848600560734:ios:59412d436190f6dbc670cf'
              : '1:848600560734:android:da3157a43a357a55c670cf',
          messagingSenderId: '848600560734',
        ),
      );
    }
  } catch (e) {
    print('Firebase secundário (dev3_storage) já inicializado ou erro: $e');
  }

  await Hive.initFlutter();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize Adjust Analytics
  await AnalyticsAdjustConfig.initPlatformState(
      appOriginEnum: AppOriginEnum.manager,
      adjustEnvironment: AdjustEnvironment.sandbox);

  await ApplicationContainer.instance().setUp(DevelopmentProj3Environment());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await AppInfo.init();

  runApp(const LelloApp());
}

void downloadCallback(String id, int status, int progress) {
  final SendPort send =
      IsolateNameServer.lookupPortByName('downloader_send_port')!;
  send.send([id, status, progress]);
}
