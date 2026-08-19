import 'package:colaborador/feature/home/domain/entity/home_item_enum.dart';
import 'package:colaborador/feature/home/presentation/widget/home_dashboard_item.dart';
import 'package:colaborador/feature/home/presentation/widget/pages/benefits/benefits_page_widget.dart';
import 'package:colaborador/feature/home/presentation/widget/pages/digital_point/digital_point_page_widget.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_application_container.dart';

Future<TestApplicationContainerScope> _install({
  bool circuitVisible = true,
}) async {
  final scope = await installTestApplicationContainer(
    circuitVisible: circuitVisible,
  );
  addTearDown(scope.dispose);
  return scope;
}

Future<void> _pump(WidgetTester tester, Widget child, SessionBloc bloc) async {
  await pumpApp(
    tester,
    BlocProvider<SessionBloc>.value(value: bloc, child: child),
    localized: true,
    wrapInScaffold: false,
    shrinkWrap: false,
    settle: false,
    surface: const Size(420, 900),
  );
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

List<HomeItemEnum> _items(WidgetTester tester) => tester
    .widgetList<HomeDashboardItem>(find.byType(HomeDashboardItem))
    .map((w) => w.homeItem)
    .toList();

void main() {
  tearDown(resetTestApplicationContainer);

  group('DigitalPointPageWidget', () {
    testWidgets('lista os atalhos de ponto digital liberados', (tester) async {
      final scope = await _install();
      await _pump(
        tester,
        DigitalPointPageWidget(
          registerController: scope.registerPointController,
        ),
        scope.sessionBloc,
      );

      expect(find.text('digital_point'), findsOneWidget);
      expect(
        _items(tester),
        containsAll(<HomeItemEnum>[
          HomeItemEnum.timeSheet,
          HomeItemEnum.proof,
          HomeItemEnum.sickNote,
        ]),
      );
    });

    testWidgets('circuit breaker fechado esconde os atalhos', (tester) async {
      final scope = await _install(circuitVisible: false);
      await _pump(
        tester,
        DigitalPointPageWidget(
          registerController: scope.registerPointController,
        ),
        scope.sessionBloc,
      );

      expect(find.text('digital_point'), findsOneWidget);
      expect(_items(tester), isEmpty);
    });
  });

  group('BenefitsPageWidget', () {
    testWidgets('lista os atalhos de vantagens liberados', (tester) async {
      final scope = await _install();
      await _pump(tester, const BenefitsPageWidget(), scope.sessionBloc);

      expect(find.text('my_benefits'), findsOneWidget);
      expect(
        _items(tester),
        containsAll(<HomeItemEnum>[
          HomeItemEnum.discounts,
          HomeItemEnum.indicateReceiveBenefits,
          HomeItemEnum.condolivre,
          HomeItemEnum.employeeReferral,
        ]),
      );
    });

    testWidgets('circuit breaker fechado esconde as vantagens', (tester) async {
      final scope = await _install(circuitVisible: false);
      await _pump(tester, const BenefitsPageWidget(), scope.sessionBloc);

      expect(_items(tester), isEmpty);
    });
  });
}
