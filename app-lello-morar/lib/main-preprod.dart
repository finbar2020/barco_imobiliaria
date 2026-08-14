import 'package:adjust_sdk/adjust_config.dart';
import 'package:essentials/analytics/adjust/analytics_adjust_config.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:essentials/stores/store_package_info.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' hide MessageHandler;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/messaging/use_case/ghost_notification_usecase.dart';
import 'package:morar/environment/environment.preprod.dart';
import 'package:morar/firebase_options.dart';
import 'package:morar/lello_app.dart';
import 'package:shared_features/shared_features.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
    var id = message.data["id"];
    var type = message.data["tipoNotification"];
    await usecase.call(GhostNotificationParams(
      id: id,
      type: type,
    ));
  } catch (e) {
    await ApplicationContainer.instance().setUp(PreProductionEnvironment());
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
    await ApplicationContainer.instance().setUp(PreProductionEnvironment());
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
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();

  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);

  // Initialize Adjust Analytics
  await AnalyticsAdjustConfig.initPlatformState(
      appOriginEnum: AppOriginEnum.owner,
      adjustEnvironment: AdjustEnvironment.sandbox);

  await ApplicationContainer.instance().setUp(PreProductionEnvironment());
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await AppInfo.init();
  runApp(LelloApp());
}
