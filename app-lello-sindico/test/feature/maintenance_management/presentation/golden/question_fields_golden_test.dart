import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/presentation/task/pages/init_step/widgets/fields/number_question_widget.dart';
import 'package:lello/feature/maintenance_management/presentation/task/pages/init_step/widgets/fields/rating_stars_question_widget.dart';
import 'package:lello/feature/maintenance_management/presentation/task/pages/init_step/widgets/fields/select_question_widget.dart';
import 'package:lello/feature/maintenance_management/presentation/task/pages/init_step/widgets/fields/text_question_widget.dart';
import 'package:lello/feature/maintenance_management/presentation/task/pages/init_step/widgets/fields/textarea_question_widget.dart';
import 'package:lello/feature/maintenance_management/presentation/task/pages/init_step/widgets/fields/signature_question_widget.dart';
import 'package:lello/feature/maintenance_management/presentation/task/pages/init_step/widgets/fields/unsupported_question_widget.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/question_fixtures.dart';

void main() {
  testWidgets('golden — text vazio', (tester) async {
    await pumpApp(
      tester,
      TextQuestionWidget(
        question: questionFixture(name: 'Observação', fieldType: 'TEXT'),
        onAnswerChanged: (_) {},
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/text_question_empty.png'),
    );
  });

  testWidgets('golden — number vazio', (tester) async {
    await pumpApp(
      tester,
      NumberQuestionWidget(
        question: questionFixture(name: 'Quantidade', fieldType: 'NUMBER'),
        onAnswerChanged: (_) {},
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/number_question_empty.png'),
    );
  });

  testWidgets('golden — rating com 3 estrelas', (tester) async {
    await pumpApp(
      tester,
      RatingStarsQuestionWidget(
        question: questionFixture(name: 'Avaliação', fieldType: 'RATING_STARS'),
        currentAnswer: 3,
        onAnswerChanged: (_) {},
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/rating_stars_selected.png'),
    );
  });

  testWidgets('golden — select sem opções', (tester) async {
    await pumpApp(
      tester,
      SelectQuestionWidget(
        question: questionFixture(
          name: 'Setor',
          fieldType: 'SELECT',
          options: const [],
        ),
        onAnswerChanged: (_) {},
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/select_question_empty.png'),
    );
  });

  testWidgets('golden — unsupported', (tester) async {
    await pumpApp(
      tester,
      UnsupportedQuestionWidget(
        question: questionFixture(name: 'Ativo', fieldType: 'ASSET'),
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/unsupported_question.png'),
    );
  });

  testWidgets('golden — text preenchido', (tester) async {
    await pumpApp(
      tester,
      TextQuestionWidget(
        question: questionFixture(name: 'Observação', fieldType: 'TEXT'),
        currentAnswer: 'Hall limpo',
        onAnswerChanged: (_) {},
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/text_question_filled.png'),
    );
  });

  testWidgets('golden — number preenchido', (tester) async {
    await pumpApp(
      tester,
      NumberQuestionWidget(
        question: questionFixture(name: 'Quantidade', fieldType: 'NUMBER'),
        currentAnswer: '12',
        onAnswerChanged: (_) {},
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/number_question_filled.png'),
    );
  });

  testWidgets('golden — textarea vazio', (tester) async {
    await pumpApp(
      tester,
      TextAreaQuestionWidget(
        question: questionFixture(name: 'Descrição', fieldType: 'TEXTAREA'),
        onAnswerChanged: (_) {},
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/textarea_question_empty.png'),
    );
  });

  testWidgets('golden — select com opções', (tester) async {
    await pumpApp(
      tester,
      SelectQuestionWidget(
        question: questionFixture(name: 'Setor', fieldType: 'SELECT'),
        currentAnswer: 'opt-sim',
        onAnswerChanged: (_) {},
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/select_question_selected.png'),
    );
  });

  testWidgets('golden — assinatura vazia', (tester) async {
    await pumpApp(
      tester,
      SignatureQuestionWidget(
        question: questionFixture(name: 'Assinatura', fieldType: 'SIGNATURE'),
        onAnswerChanged: (_) {},
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/signature_question_empty.png'),
    );
  });

  testWidgets('golden — assinatura preenchida', (tester) async {
    await pumpApp(
      tester,
      SignatureQuestionWidget(
        question: questionFixture(name: 'Assinatura', fieldType: 'SIGNATURE'),
        currentAnswer: 'assinado',
        onAnswerChanged: (_) {},
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/signature_question_signed.png'),
    );
  });
}
