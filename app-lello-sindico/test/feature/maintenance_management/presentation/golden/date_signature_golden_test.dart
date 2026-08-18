import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/presentation/task/pages/init_step/widgets/fields/date_question_widget.dart';
import 'package:lello/feature/maintenance_management/presentation/task/pages/init_step/widgets/fields/signature_question_widget.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/question_fixtures.dart';

void main() {
  testWidgets('golden — date vazia', (tester) async {
    await pumpApp(
      tester,
      DateQuestionWidget(
        question: questionFixture(name: 'Data', fieldType: 'DATE'),
        onAnswerChanged: (_) {},
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/date_question_empty.png'),
    );
  });

  testWidgets('golden — signature pendente', (tester) async {
    await pumpApp(
      tester,
      SignatureQuestionWidget(
        question: questionFixture(name: 'Assinatura', fieldType: 'SIGNATURE'),
        onAnswerChanged: (_) {},
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/signature_unsigned.png'),
    );
  });

  testWidgets('golden — date preenchida', (tester) async {
    await pumpApp(
      tester,
      DateQuestionWidget(
        question: questionFixture(name: 'Data', fieldType: 'DATE'),
        currentAnswer: '15/01/2026',
        onAnswerChanged: (_) {},
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/date_question_filled.png'),
    );
  });

  testWidgets('golden — signature assinada', (tester) async {
    await pumpApp(
      tester,
      SignatureQuestionWidget(
        question: questionFixture(name: 'Assinatura', fieldType: 'SIGNATURE'),
        currentAnswer: 'base64',
        onAnswerChanged: (_) {},
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/signature_signed.png'),
    );
  });
}
