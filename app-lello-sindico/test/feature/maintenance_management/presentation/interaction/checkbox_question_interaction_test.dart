import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/presentation/task/pages/init_step/widgets/fields/checkbox_question_widget.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/question_fixtures.dart';

void main() {
  testWidgets('marcar e desmarcar atualiza a lista de ids', (tester) async {
    List<String>? last;
    await pumpApp(
      tester,
      StatefulBuilder(
        builder: (context, setState) {
          return CheckboxQuestionWidget(
            question: questionFixture(
              name: 'Quais itens foram conferidos?',
              fieldType: 'CHECKBOX',
            ),
            currentAnswer: last,
            onAnswerChanged: (ids) => setState(() => last = ids),
          );
        },
      ),
    );

    await tester.tap(find.text('Sim'));
    await tester.pump();
    expect(last, ['opt-sim']);

    await tester.tap(find.text('Não'));
    await tester.pump();
    expect(last, ['opt-sim', 'opt-nao']);

    await tester.tap(find.text('Sim'));
    await tester.pump();
    expect(last, ['opt-nao']);
  });

  testWidgets('sem opções mostra aviso', (tester) async {
    await pumpApp(
      tester,
      CheckboxQuestionWidget(
        question: questionFixture(
          name: 'Sem opções',
          fieldType: 'CHECKBOX',
          options: const [],
        ),
        onAnswerChanged: (_) {},
      ),
    );

    expect(find.text('Nenhuma opção disponível para seleção'), findsOneWidget);
  });
}
