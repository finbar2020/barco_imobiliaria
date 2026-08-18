import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/presentation/task/pages/init_step/widgets/fields/radio_question_widget.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/question_fixtures.dart';

void main() {
  testWidgets('toque em uma opção dispara onAnswerChanged com o id',
      (tester) async {
    String? selected;
    await pumpApp(
      tester,
      RadioQuestionWidget(
        question: questionFixture(),
        onAnswerChanged: (id) => selected = id,
      ),
    );

    await tester.tap(find.text('Não'));
    await tester.pump();

    expect(selected, 'opt-nao');
  });

  testWidgets('exibe o título e o asterisco de obrigatório', (tester) async {
    await pumpApp(
      tester,
      RadioQuestionWidget(
        question: questionFixture(required: true),
        onAnswerChanged: (_) {},
      ),
    );

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is RichText &&
            widget.text.toPlainText().contains('O equipamento está funcionando?'),
      ),
      findsOneWidget,
    );
    expect(find.text('Sim'), findsOneWidget);
    expect(find.text('Não'), findsOneWidget);
  });
}
