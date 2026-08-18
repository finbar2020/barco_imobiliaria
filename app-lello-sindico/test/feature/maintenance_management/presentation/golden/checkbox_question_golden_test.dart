import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/presentation/task/pages/init_step/widgets/fields/checkbox_question_widget.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/question_fixtures.dart';

void main() {
  testWidgets('golden — checkbox sem opções', (tester) async {
    await pumpApp(
      tester,
      CheckboxQuestionWidget(
        question: questionFixture(
          name: 'Itens conferidos',
          fieldType: 'CHECKBOX',
          options: const [],
        ),
        onAnswerChanged: (_) {},
      ),
    );

    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/checkbox_question_empty.png'),
    );
  });

  testWidgets('golden — checkbox com item marcado', (tester) async {
    await pumpApp(
      tester,
      CheckboxQuestionWidget(
        question: questionFixture(
          name: 'Itens conferidos',
          fieldType: 'CHECKBOX',
        ),
        currentAnswer: const ['opt-sim'],
        onAnswerChanged: (_) {},
      ),
    );

    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/checkbox_question_selected.png'),
    );
  });
}
