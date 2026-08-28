import 'package:colaborador/feature/home/presentation/widget/pages/home_page/widgets/home_not_connected_dialog.dart';
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

Future<_PopObserver> _pumpDialog(WidgetTester tester) async {
  final observer = _PopObserver();
  await pumpApp(
    tester,
    Navigator(
      observers: [observer],
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (_) => const HomeNotConnectedDialogWidget(),
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
  group('HomeNotConnectedDialogWidget', () {
    testWidgets('avisa que o app está sem conexão', (tester) async {
      await _pumpDialog(tester);

      expect(find.text('attention!'), findsOneWidget);
      expect(
        find.text('home_not_connected_dialog_message_one'),
        findsOneWidget,
      );
      expect(
        find.text('home_not_connected_dialog_message_two'),
        findsOneWidget,
      );
    });

    testWidgets('ok fecha o aviso', (tester) async {
      final observer = await _pumpDialog(tester);

      await tester.tap(find.text('ok'));
      await tester.pumpAndSettle();

      expect(observer.pops, 1);
    });
  });
}
