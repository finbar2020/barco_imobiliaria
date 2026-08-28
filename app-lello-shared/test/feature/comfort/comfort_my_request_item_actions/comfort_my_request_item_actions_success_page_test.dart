import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_request_item_actions/controller/comfort_my_request_item_actions_controller.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_request_item_actions/pages/comfort_my_request_item_actions_success_page.dart';

import '../../../helpers/pump_app.dart';
import '../comfort_my_requests/comfort_requests_test_support.dart';

void main() {
  late RecordingNavigatorObserver observer;

  setUp(() => observer = RecordingNavigatorObserver());

  Future<void> push(WidgetTester tester, ComfortMyRequestItemActions action) async {
    await pumpPage(
      tester,
      PushHost(
        onOpen: (ctx) => Navigator.push(
          ctx,
          MaterialPageRoute(
            builder: (_) => ComfortMyRequestItemActionsSuccessPage(
                action: action, conoName: condoName),
          ),
        ),
      ),
      observer: observer,
    );
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
  }

  const titles = {
    ComfortMyRequestItemActions.cancel: 'comfort_request_actions_cancel_success',
    ComfortMyRequestItemActions.resend: 'comfort_request_actions_resend_success',
    ComfortMyRequestItemActions.message: 'comfort_request_actions_message_success',
  };

  for (final entry in titles.entries) {
    testWidgets('mostra título, condomínio e subtítulo para ${entry.key}',
        (tester) async {
      await push(tester, entry.key);
      expect(find.text('${entry.value}_title'), findsOneWidget);
      expect(find.text('${entry.value}_subtitle'), findsOneWidget);
      expect(find.text(condoName), findsOneWidget);
      expect(find.text('ok'), findsOneWidget);
    });
  }

  testWidgets('ação de avaliar não tem textos próprios', (tester) async {
    await push(tester, ComfortMyRequestItemActions.rate);
    // Título e subtítulo vazios: só o nome do condomínio e o botão.
    expect(find.text(''), findsNWidgets(2));
    expect(find.text(condoName), findsOneWidget);
  });

  testWidgets('ok e o botão voltar fecham a página', (tester) async {
    await push(tester, ComfortMyRequestItemActions.cancel);
    await tester.tap(find.text('ok'));
    await tester.pumpAndSettle();
    expect(find.byType(ComfortMyRequestItemActionsSuccessPage), findsNothing);
    expect(find.byKey(const Key('push-host')), findsOneWidget);

    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(ComfortMyRequestItemActionsSuccessPage), findsNothing);
    expect(find.byKey(const Key('push-host')), findsOneWidget);
    expect(observer.popped, hasLength(2));
  });
}
