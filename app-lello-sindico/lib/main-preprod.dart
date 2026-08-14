import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:essentials/analytics/adjust/analytics_adjust_config.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/services/tt_firebase_app.dart';
import 'package:lello/environment/environment.preprod.dart';
import 'package:lello/firebase_options.dart';
import 'package:lello/lello_app.dart';

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
    // Firebase já foi inicializado
    print('Firebase já inicializado: $e');
  }

  // Inicializa Firebase secundário para bucket de pré-produção (lello-98641)
  try {
    if (!TTFirebaseApp.isAppInitialized('preprod_storage')) {
      await TTFirebaseApp.initializeSecondary(
        appName: 'preprod_storage',
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
    print('Firebase secundário (preprod_storage) já inicializado ou erro: $e');
  }

  await Hive.initFlutter();

  final env = PreProductionEnvironment();

  Logger.root.level = env.isProduction ? Level.OFF : Level.ALL;
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

  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);

  // Initialize Adjust Analytics
  await AnalyticsAdjustConfig.initPlatformState(
      appOriginEnum: AppOriginEnum.manager,
      adjustEnvironment: AdjustEnvironment.sandbox);

  await ApplicationContainer.instance().setUp(env);
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
