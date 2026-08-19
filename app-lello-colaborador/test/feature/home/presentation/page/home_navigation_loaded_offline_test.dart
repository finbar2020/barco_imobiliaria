import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:colaborador/feature/home/domain/entity/home_navigation_item.dart';
import 'package:colaborador/feature/home/presentation/widget/home_bottom_navigation_bar_widget.dart';
import 'package:colaborador/feature/home/presentation/widget/home_navigation_loaded_offline_widget.dart';
import 'package:colaborador/feature/home/presentation/widget/pages/home_page/home_page_offline_widget.dart';
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
}

Future<void> _pumpOffline(
  WidgetTester tester, {
  List<DigitalPointEntity> points = const [],
}) async {
  final scope = await installTestApplicationContainer();
  addTearDown(scope.dispose);

  final notificationBloc = NotificationListBloc();
  addTearDown(notificationBloc.close);

  await pumpApp(
    tester,
    HomeNavigationLoadedOfflineWidget(
      session: scope.sessionBloc.session,
      digitalPoints: points,
      notificationController: _FakeNotificationController(notificationBloc),
    ),
    localized: true,
    wrapInScaffold: false,
    shrinkWrap: false,
    settle: false,
    locOverrides: const {
      'home_navigation_home': 'Home',
      'home_navigation_my_documents': 'Docs',
      'home_navigation_advantages': 'Clube',
      'home_navigation_digital_point': 'Ponto',
    },
    surface: const Size(480, 1000),
  );
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

Future<void> _unmount(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(seconds: 1));
}

void main() {
  tearDown(resetTestApplicationContainer);

  group('HomeNavigationLoadedOfflineWidget', () {
    testWidgets('monta a home offline com cabeçalho e navegação',
        (tester) async {
      await _pumpOffline(tester);

      expect(find.byType(DigitalPointHeader), findsOneWidget);
      expect(find.byType(HomePageOfflineWidget), findsOneWidget);
      expect(find.byType(HomeBottomNavigationBarWidget), findsOneWidget);

      await _unmount(tester);
    });

    testWidgets('mantém apenas as abas permitidas no modo offline',
        (tester) async {
      await _pumpOffline(tester);

      final bar = tester.widget<HomeBottomNavigationBarWidget>(
        find.byType(HomeBottomNavigationBarWidget),
      );
      expect(
        bar.navigationItems.map((e) => e.item).toList(),
        <HomeNavigationItemEnum>[
          HomeNavigationItemEnum.home,
          HomeNavigationItemEnum.myDocuments,
        ],
      );
      // As abas extras existem apenas como atalho desativado.
      expect(
        bar.navigationItems.where((e) => !e.activated).length,
        1,
      );

      await _unmount(tester);
    });

    testWidgets('exibe os pontos registrados offline', (tester) async {
      await _pumpOffline(tester, points: [testPoint(), testPoint(id: 2)]);

      expect(find.byType(HomePageOfflineWidget), findsOneWidget);
      expect(tester.takeException(), isNull);

      await _unmount(tester);
    });
  });
}
