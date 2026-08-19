import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/core/navigation/application_route.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_detail_page/widget/timesheet_detail_intro_widget.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_application_container.dart';

Future<void> _installContainer() async {
  final locator = ApplicationContainer.instance().locator;
  if (locator.isRegistered<Environment>()) {
    await locator.reset(dispose: true);
  }
  locator.registerSingleton<Environment>(TestEnvironment());
  locator.registerSingleton<SessionBloc>(FakeSessionBloc());
}

Future<List<String>> _pumpIntro(WidgetTester tester, DateTime period) async {
  final routes = <String>[];
  await pumpApp(
    tester,
    Navigator(
      onGenerateRoute: (settings) {
        if (settings.name != null &&
            settings.name != Navigator.defaultRouteName) {
          routes.add(settings.name!);
        }
        return MaterialPageRoute(
          builder: (_) => settings.name == ApplicationRoute.timesheetInfo
              ? const SizedBox()
              : Material(
                  child: TimesheetDetailIntroWidget(period: period),
                ),
        );
      },
    ),
    localized: true,
    wrapInScaffold: false,
    shrinkWrap: false,
    surface: const Size(500, 600),
  );
  return routes;
}

void main() {
  setUp(_installContainer);
  tearDown(resetTestApplicationContainer);

  group('TimesheetDetailIntroWidget', () {
    testWidgets('exibe o período das tratativas', (tester) async {
      await _pumpIntro(tester, DateTime(2026, 1, 31));

      expect(
        find.textContaining('31/01/2026'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });

    testWidgets('exibe o aviso sobre as tratativas', (tester) async {
      await _pumpIntro(tester, DateTime(2026, 1, 31));

      expect(
        find.textContaining('digital_point_attention', findRichText: true),
        findsOneWidget,
      );
    });

    testWidgets('o ícone de informação abre a legenda', (tester) async {
      final routes = await _pumpIntro(tester, DateTime(2026, 1, 31));

      await tester.tap(find.byIcon(Icons.info_outline));
      await tester.pumpAndSettle();

      expect(routes, contains(ApplicationRoute.timesheetInfo));
    });
  });
}
