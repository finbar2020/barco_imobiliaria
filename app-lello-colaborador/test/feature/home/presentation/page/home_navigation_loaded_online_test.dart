import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:colaborador/feature/home/domain/entity/home_navigation_item.dart';
import 'package:colaborador/feature/home/presentation/widget/home_bottom_navigation_bar_widget.dart';
import 'package:colaborador/feature/home/presentation/widget/home_navigation_loaded_online_widget.dart';
import 'package:colaborador/feature/home/presentation/widget/pages/home_page/home_page_online_widget.dart';
import 'package:colaborador/feature/home/presentation/widget/pages/home_page/widgets/digital_point_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_application_container.dart';

class _FakeNotificationController extends Fake
    implements NotificationController {
  _FakeNotificationController(this.bloc);

  @override
  final NotificationListBloc bloc;

  @override
  int notificationsNotRead = 0;

  @override
  Future<void> getNotificationList({bool loading = true}) async {}
}

Future<TestApplicationContainerScope> _pumpHome(
  WidgetTester tester, {
  List<DigitalPointEntity> points = const [],
  Size surface = const Size(480, 1000),
}) async {
  final scope = await installTestApplicationContainer();
  addTearDown(scope.dispose);

  final notificationBloc = NotificationListBloc();
  addTearDown(notificationBloc.close);

  await pumpApp(
    tester,
    HomeNavigationLoadedOnlineWidget(
      controller: scope.homeController,
      registerController: scope.registerPointController,
      digitalPoints: points,
      notificationController: _FakeNotificationController(notificationBloc),
    ),
    localized: true,
    wrapInScaffold: false,
    shrinkWrap: false,
    settle: false,
    // As chaves cruas quebram em duas linhas e estouram a barra inferior.
    locOverrides: const {
      'home_navigation_home': 'Home',
      'home_navigation_my_documents': 'Docs',
      'home_navigation_advantages': 'Clube',
      'home_navigation_digital_point': 'Ponto',
    },
    surface: surface,
  );
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }

  return scope;
}

/// O relógio da home usa `Timer.periodic` e só se cancela no tick seguinte ao
/// dispose: desmontar a árvore e avançar 1s evita o erro de timer pendente.
Future<void> _unmount(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(seconds: 1));
}

void main() {
  tearDown(resetTestApplicationContainer);

  group('HomeNavigationLoadedOnlineWidget', () {
    testWidgets('monta a home com cabeçalho, app bar e navegação',
        (tester) async {
      await _pumpHome(tester);

      expect(find.byType(DigitalPointHeader), findsOneWidget);
      expect(find.byType(HomeBottomNavigationBarWidget), findsOneWidget);
      expect(find.byType(HomePageOnlineWidget), findsOneWidget);
      expect(find.text('Ana Silva'), findsOneWidget);

      await _unmount(tester);
    });

    testWidgets('mantém as abas liberadas pelo rbac da sessão', (tester) async {
      await _pumpHome(tester);

      final bar = tester.widget<HomeBottomNavigationBarWidget>(
        find.byType(HomeBottomNavigationBarWidget),
      );
      expect(
        bar.navigationItems.map((e) => e.item).toList(),
        <HomeNavigationItemEnum>[
          HomeNavigationItemEnum.home,
          HomeNavigationItemEnum.myDocuments,
          HomeNavigationItemEnum.benefits,
        ],
      );
      // A aba de ponto digital só entra quando o condomínio libera a marcação.
      expect(
        bar.navigationItems.map((e) => e.item),
        isNot(contains(HomeNavigationItemEnum.digitalPoint)),
      );

      await _unmount(tester);
    });

    testWidgets('troca de aba pela barra inferior', (tester) async {
      final scope = await _pumpHome(tester);
      expect(scope.homeController.currentPage, 0);

      // O timer de analytics é iniciado pela HomeNavigationPage antes desta
      // árvore existir; sem ele o listener de página quebra.
      scope.homeController.colaboradorHomeTimerStart();
      await tester.pump();

      final bar = tester.widget<HomeBottomNavigationBarWidget>(
        find.byType(HomeBottomNavigationBarWidget),
      );
      bar.changePage(1);
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      expect(scope.homeController.currentPage, 1);

      await _unmount(tester);
    });

    testWidgets('exibe pontos digitais recebidos no cabeçalho', (tester) async {
      await _pumpHome(tester, points: [testPoint()]);

      expect(find.byType(DigitalPointHeader), findsOneWidget);
      expect(tester.takeException(), isNull);

      await _unmount(tester);
    });

    testWidgets('arrastar para a esquerda avança de página', (tester) async {
      final scope = await _pumpHome(tester);
      scope.homeController.colaboradorHomeTimerStart();
      await tester.pump();

      await tester.fling(
        find.byType(DigitalPointHeader),
        const Offset(-300, 0),
        1000,
      );
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      expect(scope.homeController.currentPage, 1);

      await _unmount(tester);
    });

    testWidgets('arrastar para a direita volta de página', (tester) async {
      final scope = await _pumpHome(tester);
      scope.homeController.colaboradorHomeTimerStart();
      scope.homeController.currentPage = 1;
      await tester.pump();

      await tester.fling(
        find.byType(DigitalPointHeader),
        const Offset(300, 0),
        1000,
      );
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      expect(scope.homeController.currentPage, 0);

      await _unmount(tester);
    });

    testWidgets('ciclo de vida para e retoma o relógio da home',
        (tester) async {
      final scope = await _pumpHome(tester);
      scope.homeController.colaboradorHomeTimerStart();
      await tester.pump();
      final observer = tester.state(
        find.byType(HomeNavigationLoadedOnlineWidget),
      ) as WidgetsBindingObserver;

      for (final estado in const [
        AppLifecycleState.paused,
        AppLifecycleState.resumed,
        AppLifecycleState.detached,
        AppLifecycleState.inactive,
      ]) {
        observer.didChangeAppLifecycleState(estado);
        await tester.pump();
        expect(tester.takeException(), isNull, reason: '\$estado');
      }
      expect(scope.homeController.colaboradorHomeTimer, isNotNull);

      await _unmount(tester);
    });

  });
}
