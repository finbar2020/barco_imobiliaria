import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:colaborador/feature/sync_digital_points/presentation/widget/sync_failed_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../helpers/pump_app.dart';

class _PopObserver extends NavigatorObserver {
  int pops = 0;

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pops++;
    super.didPop(route, previousRoute);
  }
}

Future<_PopObserver> _pumpWidget(
  WidgetTester tester, {
  List<DigitalPointEntity> points = const [],
  String? message,
}) async {
  final observer = _PopObserver();
  await pumpApp(
    tester,
    Navigator(
      observers: [observer],
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (_) => Material(
          child: SyncFailedWidget(
            digitalPoints: points,
            syncFunction: (_) {},
            message: message,
          ),
        ),
      ),
    ),
    localized: true,
    wrapInScaffold: false,
    shrinkWrap: false,
    surface: const Size(420, 800),
  );
  return observer;
}

void main() {
  group('SyncFailedWidget', () {
    testWidgets('exibe o motivo padrão da falha de sincronização',
        (tester) async {
      await _pumpWidget(tester);

      expect(
        find.text('digital_point_sync_dialog_failed_title'),
        findsOneWidget,
      );
      expect(
        find.text('digital_point_sync_dialog_failed_subtitle'),
        findsOneWidget,
      );
      expect(find.text('digital_point_date'), findsNothing);
    });

    testWidgets('mensagem específica substitui o texto padrão', (tester) async {
      await _pumpWidget(tester, message: 'colaborador afastado');

      expect(
        find.textContaining('colaborador afastado'),
        findsOneWidget,
      );
      expect(
        find.text('digital_point_sync_dialog_failed_subtitle'),
        findsNothing,
      );
    });

    testWidgets('lista os pontos que não foram sincronizados', (tester) async {
      final point = testPoint();
      await _pumpWidget(tester, points: [point]);

      expect(find.text('digital_point_date'), findsOneWidget);
      expect(find.text('digital_point_time'), findsOneWidget);
      expect(find.text(point.dateFormatted), findsOneWidget);
      expect(find.text(point.timeFormatted), findsOneWidget);
    });

    testWidgets('ok fecha o diálogo', (tester) async {
      final observer = await _pumpWidget(tester);

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(observer.pops, 1);
    });
  });
}
