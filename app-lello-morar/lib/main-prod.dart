import 'package:essentials/analytics/adjust/analytics_adjust_config.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' hide MessageHandler;
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/messaging/use_case/ghost_notification_usecase.dart';
import 'package:morar/firebase_options.dart';
import 'package:morar/lello_app.dart';
import 'package:shared_features/shared_features.dart';

import 'environment/environment.prod.dart';

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
    var usecase =
        ApplicationContainer.instance().resolve<GhostNotificationUsecase>();
    String? id = message.data["id"];
    String? type = message.data["tipoNotification"];
    await usecase.call(GhostNotificationParams(
      id: id ?? "",
      type: type ?? "UPDATE_FCM_TOKEN",
    ));
  } catch (e) {
    await ApplicationContainer.instance().setUp(ProductionEnvironment());
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
    var usecase = ApplicationContainer.instance().resolve<SendPushCallback>();
    if (message.data["id"] == null) {
      return;
    }
    var id = message.data["id"];
    await usecase.call(SendPushCallbackParams(
      notificationId: id,
      type: NotificationCallbackType.RECEBEU,
    ));
  } catch (e) {
    await ApplicationContainer.instance().setUp(ProductionEnvironment());
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

  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  // Initialize Adjust Analytics
  await AnalyticsAdjustConfig.initPlatformState(
      appOriginEnum: AppOriginEnum.owner,
      adjustEnvironment: AdjustEnvironment.production);

  await ApplicationContainer.instance().setUp(ProductionEnvironment());
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await AppInfo.init();

  final configuration = DatadogConfiguration(
    clientToken: 'pube1c7f790f0378e512f336bbe89d643b6',
    env: 'prod',
    site: DatadogSite.us1,
    nativeCrashReportEnabled: true,
    loggingConfiguration: DatadogLoggingConfiguration(),
    rumConfiguration: DatadogRumConfiguration(
      applicationId: '73829617-a8d8-4b19-99d6-cff19c83a16e',
      trackFrustrations: true,
      detectLongTasks: true,
      reportFlutterPerformance: true,
    ),
    firstPartyHosts: [Uri.parse(ProductionEnvironment().apiUrl).host],
  );
  await DatadogSdk.runApp(configuration, TrackingConsent.granted, () async {
    runApp(LelloApp());
  });
}
