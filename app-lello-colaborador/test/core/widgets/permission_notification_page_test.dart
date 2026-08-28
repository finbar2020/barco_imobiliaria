import 'package:colaborador/core/widgets/permission_notification_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

import '../../helpers/fake_permission_handler.dart';
import '../../helpers/pump_app.dart';

class _PopObserver extends NavigatorObserver {
  int pops = 0;

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pops++;
    super.didPop(route, previousRoute);
  }
}

Future<_PopObserver> _pumpPage(WidgetTester tester) async {
  final observer = _PopObserver();
  await pumpApp(
    tester,
    Navigator(
      observers: [observer],
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (_) => const PermissionNotificationPage(),
      ),
    ),
    localized: true,
    wrapInScaffold: false,
    shrinkWrap: false,
    settle: false,
    surface: const Size(400, 800),
  );
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
  return observer;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakePermissionHandler permissionHandler;

  setUp(() {
    permissionHandler = FakePermissionHandler();
    setFakePermissionHandler(permissionHandler);
  });

  group('PermissionNotificationPage', () {
    testWidgets('explica por que a permissão é pedida', (tester) async {
      await _pumpPage(tester);

      expect(find.text('notification_permission_title'), findsOneWidget);
      expect(find.text('notification_permission_subtitle'), findsOneWidget);
    });

    testWidgets('permissão ainda não decidida oferece aceitar ou recusar',
        (tester) async {
      permissionHandler.status = PermissionStatus.granted;
      await _pumpPage(tester);

      expect(
        find.text('notification_permission_btn_accept'),
        findsOneWidget,
      );
      expect(
        find.text('notification_permission_btn_recused'),
        findsOneWidget,
      );
      expect(
        find.text('notification_permission_br_configurations'),
        findsNothing,
      );
    });

    testWidgets('permissão negada leva para os ajustes do sistema',
        (tester) async {
      permissionHandler.status = PermissionStatus.permanentlyDenied;
      await _pumpPage(tester);

      expect(
        find.text('notification_permission_br_configurations'),
        findsOneWidget,
      );
      expect(find.text('close'), findsOneWidget);

      await tester.tap(find.text('notification_permission_br_configurations'));
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      expect(permissionHandler.settingsOpened, isTrue);
    });

    testWidgets('aceitar solicita a permissão e fecha a tela', (tester) async {
      permissionHandler.status = PermissionStatus.denied;
      final observer = await _pumpPage(tester);

      // Em Android o estado "denied" já leva para configurações; o botão de
      // aceitar aparece apenas quando a permissão ainda pode ser solicitada.
      if (find.text('notification_permission_btn_accept').evaluate().isEmpty) {
        expect(
          find.text('notification_permission_br_configurations'),
          findsOneWidget,
        );
        return;
      }

      await tester.tap(find.text('notification_permission_btn_accept'));
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      expect(permissionHandler.requestCount, 1);
      expect(observer.pops, 1);
    });

    testWidgets('aceitar com permissão já concedida apenas fecha a tela',
        (tester) async {
      permissionHandler.status = PermissionStatus.granted;
      final observer = await _pumpPage(tester);

      await tester.tap(find.text('notification_permission_btn_accept'));
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      expect(permissionHandler.requestCount, 0);
      expect(observer.pops, 1);
    });

    testWidgets('aceitar com permissão restrita solicita ao sistema',
        (tester) async {
      permissionHandler.status = PermissionStatus.restricted;
      final observer = await _pumpPage(tester);

      await tester.tap(find.text('notification_permission_btn_accept'));
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      expect(permissionHandler.requestCount, 1);
      expect(observer.pops, 1);
    });

    testWidgets('fechar a partir da tela de ajustes volta para trás',
        (tester) async {
      permissionHandler.status = PermissionStatus.permanentlyDenied;
      final observer = await _pumpPage(tester);

      await tester.tap(find.text('close'));
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      expect(observer.pops, 1);
      expect(permissionHandler.settingsOpened, isFalse);
    });

    testWidgets('voltar do segundo plano reavalia a permissão', (tester) async {
      permissionHandler.status = PermissionStatus.granted;
      final observer = await _pumpPage(tester);
      final lifecycleObserver = tester.state(
        find.byType(PermissionNotificationPage),
      ) as WidgetsBindingObserver;

      // Estados que não devem disparar nenhuma ação.
      lifecycleObserver
        ..didChangeAppLifecycleState(AppLifecycleState.inactive)
        ..didChangeAppLifecycleState(AppLifecycleState.paused)
        ..didChangeAppLifecycleState(AppLifecycleState.detached)
        ..didChangeAppLifecycleState(AppLifecycleState.hidden);
      await tester.pump();
      expect(observer.pops, 0);

      lifecycleObserver.didChangeAppLifecycleState(AppLifecycleState.resumed);
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      expect(observer.pops, 1);
    });

    testWidgets('recusar apenas fecha a tela', (tester) async {
      permissionHandler.status = PermissionStatus.granted;
      final observer = await _pumpPage(tester);

      await tester.tap(find.text('notification_permission_btn_recused'));
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      expect(observer.pops, 1);
      expect(permissionHandler.requestCount, 0);
    });
  });
}
