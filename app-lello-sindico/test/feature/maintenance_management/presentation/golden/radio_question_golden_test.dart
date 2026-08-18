import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/presentation/task/pages/init_step/widgets/fields/radio_question_widget.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/question_fixtures.dart';

void main() {
  testWidgets('golden — radio sem seleção', (tester) async {
    await pumpApp(
      tester,
      RadioQuestionWidget(
        question: questionFixture(),
        onAnswerChanged: (_) {},
      ),
    );

    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/radio_question_empty.png'),
    );
  });

  testWidgets('golden — radio com opção selecionada', (tester) async {
    await pumpApp(
      tester,
      RadioQuestionWidget(
        question: questionFixture(),
        currentAnswer: 'opt-sim',
        onAnswerChanged: (_) {},
      ),
    );

    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/radio_question_selected.png'),
    );
  });
}
