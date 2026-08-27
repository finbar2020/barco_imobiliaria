import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/widgets/request_card.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

import '../../../helpers/pump_app.dart';
import 'comfort_requests_test_support.dart';

void main() {
  late ComfortRequestsHarness harness;
  late RecordingNavigatorObserver observer;

  setUp(() async {
    harness = await installComfortHarness();
    observer = RecordingNavigatorObserver();
  });

  Widget card(request) => Scaffold(
        body: Center(
          child: SizedBox(
            width: 220,
            child: RequestCard(
              request: request,
              comfortMyRequestsController: harness.myRequests,
              applicationContainer: harness.container,
            ),
          ),
        ),
      );

  testWidgets('sem solicitação não renderiza nada', (tester) async {
    await pumpPage(tester, card(null));
    expect(find.byType(ElevatedButton), findsNothing);
  });

  testWidgets('não comprada não pode ser avaliada', (tester) async {
    await pumpPage(tester, card(buildRequest(purchased: false)));
    expect(find.text('Academia Lello'), findsOneWidget);
    expect(find.text('10/01/2026'), findsOneWidget);
    expect(find.byWidgetPredicate((w) =>
            w is RichText &&
            w.text.toPlainText() == 'comfort_my_requests_not_possible_to_rate'),
        findsOneWidget);
  });

  testWidgets('já avaliada mostra o botão desabilitado', (tester) async {
    await pumpPage(tester, card(buildRequest(rating: 4)));
    expect(find.text('comfort_my_requests_rated'), findsOneWidget);
    await tester.tap(find.text('comfort_my_requests_rated'), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(observer.pushedNames, isEmpty);
  });

  testWidgets('avaliar seleciona a solicitação e navega', (tester) async {
    final request = buildRequest();
    await pumpPage(tester, card(request), observer: observer);
    await expectLater(
        find.byType(RequestCard), matchesGoldenFile('goldens/request_card.png'));

    await tester.tap(find.text('comfort_my_requests_rate'));
    await tester.pumpAndSettle();

    expect(harness.myRequests.partnerSelectedRequest, same(request));
    expect(observer.pushedNames.last, SharedApplicationRoute.comfortRateRequest);
    expect(findRoute(SharedApplicationRoute.comfortRateRequest), findsOneWidget);
  });
}
