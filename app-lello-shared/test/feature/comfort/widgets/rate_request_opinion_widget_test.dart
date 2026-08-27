import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/comfort/presentation/widgets/request_rating_widgets/rate_request_opinion_widget.dart';

import '../../../helpers/pump_app.dart';

void main() {
  testWidgets('usa o hint padrão e propaga o texto digitado', (tester) async {
    final controller = TextEditingController();
    final focusNode = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(focusNode.dispose);

    await pumpApp(
      tester,
      RateRequestOpinionWidget(controller: controller, focusNode: focusNode),
    );

    expect(find.text('comfort_rate_write_here'), findsOneWidget);
    expect(find.text('0/256'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Ótimo atendimento');
    await tester.pump();
    expect(controller.text, 'Ótimo atendimento');
    expect(focusNode.hasFocus, isTrue);
    expect(find.text('17/256'), findsOneWidget);
  });

  testWidgets('hint customizado', (tester) async {
    final controller = TextEditingController();
    final focusNode = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(focusNode.dispose);

    await pumpApp(
      tester,
      RateRequestOpinionWidget(
          controller: controller, focusNode: focusNode, hintText: 'Escreva'),
    );

    expect(find.text('Escreva'), findsOneWidget);
    expect(find.text('comfort_rate_write_here'), findsNothing);
    await expectLater(findGoldenSurface(),
        matchesGoldenFile('goldens/rate_request_opinion_widget.png'));
  });
}
