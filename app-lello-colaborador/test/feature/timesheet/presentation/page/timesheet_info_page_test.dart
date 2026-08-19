import 'package:colaborador/feature/timesheet/presentation/timesheet_detail_page/page/timesheet_info_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';

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
      onGenerateRoute: (settings) => MaterialPageRoute(
        builder: (_) => settings.name == 'fechado'
            ? const SizedBox()
            : const TimesheetInfoPage(),
      ),
    ),
    localized: true,
    wrapInScaffold: false,
    shrinkWrap: false,
    surface: const Size(420, 900),
  );
  return observer;
}

void main() {
  group('TimesheetInfoPage', () {
    testWidgets('explica os tipos de tratativa da folha', (tester) async {
      await _pumpPage(tester);

      expect(find.text('timesheet_info_page_title'), findsOneWidget);
      expect(find.text('timesheet_info_page_description'), findsOneWidget);
      expect(find.text('timesheet_info_page_description_bold'), findsOneWidget);
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });

    testWidgets('lista os símbolos de cada tratativa', (tester) async {
      await _pumpPage(tester);

      expect(find.text('I'), findsOneWidget);
      expect(find.text('P'), findsOneWidget);
      expect(find.text('D'), findsOneWidget);
    });

    testWidgets('descreve cada tipo com título e explicação', (tester) async {
      await _pumpPage(tester);

      for (final key in const [
        'timesheet_info_page_type_included',
        'timesheet_info_page_type_pre_signed',
        'timesheet_info_page_type_not_considered',
      ]) {
        expect(
          find.textContaining(key, findRichText: true),
          findsOneWidget,
          reason: key,
        );
      }
    });

    testWidgets('botão voltar fecha a tela', (tester) async {
      final observer = await _pumpPage(tester);

      await tester.ensureVisible(find.text('back'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('back'));
      await tester.pumpAndSettle();

      expect(observer.pops, 1);
    });
  });
}
