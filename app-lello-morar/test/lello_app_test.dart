import 'dart:io';

import 'package:essentials/essentials.dart' hide isNotNull, isNull;
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart' show MethodChannel;
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:morar/lello_app.dart';
import 'package:shared_features/shared_features.dart';

import 'helpers/fake_permission_handler.dart';
import 'helpers/firebase_mocks.dart';
import 'helpers/init_sqflite_ffi.dart';
import 'helpers/test_application_container.dart' show TestEnvironment;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  initSqfliteForTests();

  setUp(() async {
    FlavorConfig.init();
    setFakePermissionHandler(FakePermissionHandler());
    await setUpFakeFirebase();
    // O RegistrationStore consulta a assinatura do app via sms_autofill.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('sms_autofill'),
            (call) async => call.method == 'getAppSignature' ? 'sig' : null);
    SharedPreferences.setMockInitialValues({});
    Hive.init(Directory.systemTemp.createTempSync('morar_app').path);
    await ApplicationContainer.instance().locator.reset(dispose: true);
    await ApplicationContainer.instance().setUp(TestEnvironment());
  });

  tearDown(() => ApplicationContainer.instance().locator.reset(dispose: true));

  testWidgets('todas as rotas registradas constroem uma página',
      (tester) async {
    // A rota de documentos lê o SessionBloc do contexto ao ser construída.
    await tester.pumpWidget(BlocProvider<SessionBloc>.value(
      value: ApplicationContainer.instance().resolve<SessionBloc>(),
      child: const MaterialApp(home: SizedBox()),
    ));
    final context = tester.element(find.byType(SizedBox));

    expect(LelloApp.routes, isNotEmpty);
    final failures = <String>[];
    for (final entry in LelloApp.routes.entries) {
      try {
        entry.value(context);
      } catch (e) {
        failures.add('${entry.key}: $e');
      }
    }
    expect(failures, isEmpty);
  });

  testWidgets('o app monta o MaterialApp com a splash como rota inicial',
      (tester) async {
    await tester.pumpWidget(LelloApp());
    await tester.pump();

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.title, 'Lello para Moradores');
    expect(app.initialRoute, SharedApplicationRoute.splash);
    expect(app.supportedLocales, hasLength(3));
    expect(
      app.localeResolutionCallback!(const Locale('en', 'US'), app.supportedLocales),
      const Locale('en', 'US'),
    );
    expect(
      app.localeResolutionCallback!(const Locale('en'), app.supportedLocales),
      const Locale('en', 'BR'),
    );
    expect(
      app.localeResolutionCallback!(const Locale('fr'), app.supportedLocales),
      const Locale('pt', 'BR'),
    );

    // A splash agenda um timer antes de decidir a próxima tela; sem consumi-lo
    // o teste falha com "A Timer is still pending".
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
  });
}
