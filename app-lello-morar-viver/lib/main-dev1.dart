import 'package:essentials/analytics/adjust/analytics_adjust_config.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' hide MessageHandler;
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/messaging/use_case/ghost_notification_usecase.dart';
import 'package:morar/environment/environment.dev1.dart';
import 'package:morar_viver/firebase_options_hubert.dart';
import 'package:morar_viver/firebase_options_lello_viver.dart';
import 'package:morar_viver/lello_viver_app.dart';
import 'package:shared_features/shared_features.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    FirebaseOptions options;

    switch (FlavorConfig.currentBrand) {
      case Brand.hubert:
        options = DefaultFirebaseOptionsHubertHubert.currentPlatform;
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
    print('FCM: background message: _sendGhostNotification');
    await _sendGhostNotification(message);
  } else {
    print('FCM: background message: _sendPushCallback');
    await _sendPushCallback(message);
  }
}

Future _sendGhostNotification(RemoteMessage message) async {
  try {
    var usecase =
        ApplicationContainer.instance().resolve<GhostNotificationUsecase>();
    var id = message.data["id"];
    print('FCM: background message: id-$id');
    var type = message.data["tipoNotification"];
    await usecase.call(GhostNotificationParams(
      id: id,
      type: type,
    ));
  } catch (e) {
    print('FCM: background message: catch Err-$e');
    await ApplicationContainer.instance().setUp(DevelopmentProj1Environment());
    var usecase =
        ApplicationContainer.instance().resolve<GhostNotificationUsecase>();
    var id = message.data["id"];
    var type = message.data["tipoNotification"];
    var secondTry = await usecase.call(GhostNotificationParams(
      id: id,
      type: type,
    ));
    print('FCM: background message: reTry-$secondTry');
  }
}

Future _sendPushCallback(RemoteMessage message) async {
  try {
    var usecase = ApplicationContainer.instance().resolve<SendPushCallback>();
    var id = message.data["id"];
    print('FCM: background message: id-$id');
    await usecase.call(SendPushCallbackParams(
      notificationId: id,
      type: NotificationCallbackType.RECEBEU,
    ));
  } catch (e) {
    print('FCM: background message: catch Err-$e');
    await ApplicationContainer.instance().setUp(DevelopmentProj1Environment());
    var usecase = ApplicationContainer.instance().resolve<SendPushCallback>();
    var id = message.data["id"];
    var secondTry = await usecase.call(SendPushCallbackParams(
      notificationId: id,
      type: NotificationCallbackType.RECEBEU,
    ));
    print(
        'FCM: background message: reTry-${secondTry.fold((l) => "error", (r) => "success")}');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlavorConfig.init();
  FirebaseOptions options;

  switch (FlavorConfig.currentBrand) {
    case Brand.hubert:
      options = DefaultFirebaseOptionsHubertHubert.currentPlatform;
      break;
    case Brand.lello:
      options = DefaultFirebaseOptionsLelloViver.currentPlatform;
      break;
  }

  await Firebase.initializeApp(
    options: options,
  );
  await Hive.initFlutter();

  WidgetsFlutterBinding.ensureInitialized();

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);

  // Initialize Adjust Analytics
  await AnalyticsAdjustConfig.initPlatformState(
      appOriginEnum: AppOriginEnum.owner,
      adjustEnvironment: AdjustEnvironment.sandbox);

  await ApplicationContainer.instance().setUp(DevelopmentProj1Environment());
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await AppInfo.init();
  runApp(LelloViverApp());
}
