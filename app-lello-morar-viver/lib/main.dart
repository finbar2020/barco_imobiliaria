import 'package:essentials/configs/flavor_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' hide MessageHandler;
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/environment/environment.prod.dart';
import 'package:morar/firebase_options.dart';
import 'package:morar_viver/lello_viver_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlavorConfig.init(); 
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  WidgetsFlutterBinding.ensureInitialized();

  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  await ApplicationContainer.instance().setUp(ProductionEnvironment());
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(LelloViverApp());
}
