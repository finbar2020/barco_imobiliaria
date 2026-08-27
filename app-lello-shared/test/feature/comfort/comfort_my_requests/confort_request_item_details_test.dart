import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_request_status.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/widgets/comfort_request_item.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/widgets/confort_request_item_details.dart';

import '../../../helpers/pump_app.dart';
import 'comfort_requests_test_support.dart';

void main() {
  late ComfortRequestsHarness harness;

  setUp(() async {
    harness = await installComfortHarness();
  });

  const statuses = {
    ComfortRequestStatus.sended: ('comfort_request_status_sended', Colors.green),
    ComfortRequestStatus.achived: ('comfort_request_status_achived', Colors.grey),
    ComfortRequestStatus.canceled: ('comfort_request_status_canceled', Colors.red),
    ComfortRequestStatus.resent: ('comfort_request_status_resent', Colors.orange),
  };

  for (final entry in statuses.entries) {
    testWidgets('mostra título, tipo, data e status ${entry.key}',
        (tester) async {
      await pumpApp(
        tester,
        ConfortRequestItemDetails(
          appContainer: harness.container,
          item: buildRequest(status: entry.key),
        ),
      );

      expect(find.text('Academia Lello'), findsOneWidget);
      expect(find.text('comfort_gym'), findsOneWidget);
      expect(find.text('10/01/2026 time_to 10:30h'), findsOneWidget);
      expect(find.text(entry.value.$1), findsOneWidget);
      final icon = tester.widget<Icon>(find.byIcon(Icons.circle));
      expect(icon.color, entry.value.$2);
    });
  }

  testWidgets('hideStatus esconde a coluna de status', (tester) async {
    await pumpApp(
      tester,
      ConfortRequestItemDetails(
        appContainer: harness.container,
        item: buildRequest(),
        hideStatus: true,
      ),
    );
    expect(find.byIcon(Icons.circle), findsNothing);
    expect(find.text('comfort_request_status_sended'), findsNothing);
    await expectLater(findGoldenSurface(),
        matchesGoldenFile('goldens/confort_request_item_details.png'));
  });

  testWidgets('ComfortRequestItem mostra a seta conforme expandido',
      (tester) async {
    final expanded = buildRequest()..isExpanded = true;
    await pumpApp(
      tester,
      ComfortRequestItem(
        comfortMyRequestsController: harness.myRequests,
        appContainer: harness.container,
        item: expanded,
        index: 0,
      ),
    );
    expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);
    expect(tester.widget<Opacity>(find.byType(Opacity)).opacity, 1.0);
    await expectLater(findGoldenSurface(),
        matchesGoldenFile('goldens/comfort_request_item.png'));
  });
}
