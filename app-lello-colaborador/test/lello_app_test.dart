import 'dart:io';

import 'package:colaborador/core/bloc/inactivity/inactivity_cubit.dart';
import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/lello_app.dart';
import 'package:essentials/essentials.dart' hide isNotNull, isNull;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workmanager/workmanager.dart';
import 'package:workmanager_platform_interface/workmanager_platform_interface.dart';

import 'helpers/fake_permission_handler.dart';
import 'helpers/firebase_mocks.dart';
import 'helpers/init_sqflite_ffi.dart';
import 'helpers/test_application_container.dart' show TestEnvironment;

class _FakeWorkmanagerPlatform extends WorkmanagerPlatform {
  @override
  Future<void> registerPeriodicTask(
    String uniqueName,
    String taskName, {
    Duration? frequency,
    Duration? flexInterval,
    Map<String, dynamic>? inputData,
    Duration? initialDelay,
    Constraints? constraints,
    ExistingPeriodicWorkPolicy? existingWorkPolicy,
    BackoffPolicy? backoffPolicy,
    Duration? backoffPolicyDelay,
    String? tag,
    ForegroundServiceConfig? foregroundServiceConfig,
  }) async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  initSqfliteForTests();

  setUp(() async {
    FlavorConfig.init();
    setFakePermissionHandler(FakePermissionHandler());
    await setUpFakeFirebase();
    SharedPreferences.setMockInitialValues({});
    Hive.init(Directory.systemTemp.createTempSync('colaborador_app').path);
    Workmanager();
    WorkmanagerPlatform.instance = _FakeWorkmanagerPlatform();
    await ApplicationContainer.instance().locator.reset(dispose: true);
    await ApplicationContainer.instance().setUp(TestEnvironment());
  });

  tearDown(() => ApplicationContainer.instance().locator.reset(dispose: true));

  /// A splash agenda um timer de 3s antes de decidir a próxima tela; sem
  /// consumi-lo o teste falha com "A Timer is still pending".
  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(const LelloApp());
    await tester.pump();
  }

  Future<void> drainSplash(WidgetTester tester) async {
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
  }

  testWidgets('todas as rotas registradas constroem uma página',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    final context = tester.element(find.byType(SizedBox));

    expect(LelloApp.routes, isNotEmpty);
    for (final entry in LelloApp.routes.entries) {
      expect(entry.value(context), isA<Widget>(), reason: entry.key);
    }
  });

  testWidgets('o app monta a rota inicial e o overlay de inatividade',
      (tester) async {
    await pumpApp(tester);

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(Overlay), findsWidgets);

    await drainSplash(tester);
  });

  testWidgets('toque na tela reinicia a contagem de inatividade',
      (tester) async {
    final cubit = ApplicationContainer.instance().resolve<InactivityCubit>();
    await pumpApp(tester);

    cubit.start();
    cubit.countDown = 3;

    // O `Listener` mais externo é o do próprio app; chamamos o callback
    // diretamente para não depender do que a rota inicial está exibindo.
    final listener = tester.widget<Listener>(find.byType(Listener).first);
    listener.onPointerDown!(const PointerDownEvent());
    await tester.pump();

    expect(cubit.countDown, cubit.duration - 1);

    // Sem contagem ativa o toque é ignorado.
    cubit.cancel();
    cubit.countDown = 3;
    listener.onPointerDown!(const PointerDownEvent());
    expect(cubit.countDown, 3);

    await drainSplash(tester);
  });

  testWidgets('voltar do segundo plano reinicia a contagem', (tester) async {
    final cubit = ApplicationContainer.instance().resolve<InactivityCubit>();
    await pumpApp(tester);
    final observer =
        tester.state(find.byType(LelloApp)) as WidgetsBindingObserver;

    cubit.start();
    cubit.countDown = 3;
    observer.didChangeAppLifecycleState(AppLifecycleState.resumed);
    await tester.pump();

    expect(cubit.countDown, cubit.duration - 1);

    // Sem timer ativo o retorno não altera nada.
    cubit.cancel();
    observer.didChangeAppLifecycleState(AppLifecycleState.resumed);
    await tester.pump();
    expect(cubit.isActive(), isFalse);

    await drainSplash(tester);
  });

  testWidgets('encerrar o app fora de sessão tablet não desloga',
      (tester) async {
    await pumpApp(tester);
    final observer =
        tester.state(find.byType(LelloApp)) as WidgetsBindingObserver;

    observer.didChangeAppLifecycleState(AppLifecycleState.detached);
    await tester.pump();

    expect(tester.takeException(), isNull);

    await drainSplash(tester);
  });
}
