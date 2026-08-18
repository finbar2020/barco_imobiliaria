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
  testWidgets('TEXT dispara onAnswerChanged ao digitar', (tester) async {
    String? value;
    await pumpApp(
      tester,
      TextQuestionWidget(
        question: questionFixture(name: 'Observação', fieldType: 'TEXT'),
        onAnswerChanged: (v) => value = v,
      ),
    );

    await tester.enterText(find.byType(TextField), 'ok');
    expect(value, 'ok');
  });

  testWidgets('TEXTAREA dispara onAnswerChanged ao digitar', (tester) async {
    String? value;
    await pumpApp(
      tester,
      TextAreaQuestionWidget(
        question: questionFixture(name: 'Descrição', fieldType: 'TEXTAREA'),
        onAnswerChanged: (v) => value = v,
      ),
    );

    await tester.enterText(find.byType(TextField), 'texto longo');
    expect(value, 'texto longo');
  });

  testWidgets('NUMBER dispara onAnswerChanged ao digitar', (tester) async {
    String? value;
    await pumpApp(
      tester,
      NumberQuestionWidget(
        question: questionFixture(name: 'Quantidade', fieldType: 'NUMBER'),
        onAnswerChanged: (v) => value = v,
      ),
    );

    await tester.enterText(find.byType(TextField), '12');
    expect(value, '12');
    expect(find.text('Digite um número'), findsOneWidget);
  });

  testWidgets('DECIMAL mostra hint de decimal', (tester) async {
    await pumpApp(
      tester,
      NumberQuestionWidget(
        question: questionFixture(name: 'Valor', fieldType: 'DECIMAL'),
        isDecimal: true,
        onAnswerChanged: (_) {},
      ),
    );
    expect(find.text('Digite um número decimal'), findsOneWidget);
  });

  testWidgets('RATING_STARS toque na 4ª estrela envia 4', (tester) async {
    int? rating;
    await pumpApp(
      tester,
      RatingStarsQuestionWidget(
        question: questionFixture(name: 'Avaliação', fieldType: 'RATING_STARS'),
        currentAnswer: 0,
        onAnswerChanged: (v) => rating = v,
      ),
    );

    await tester.tap(find.byIcon(Icons.star_border).at(3));
    expect(rating, 4);
  });

  testWidgets('SELECT sem opções mostra aviso', (tester) async {
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
    expect(find.text('Nenhuma opção disponível para seleção'), findsOneWidget);
  });

  testWidgets('UNSUPPORTED mostra tipo e nome da pergunta', (tester) async {
    await pumpApp(
      tester,
      UnsupportedQuestionWidget(
        question: questionFixture(name: 'Ativo', fieldType: 'ASSET'),
      ),
    );
    expect(find.textContaining('Campo não suportado: ASSET'), findsOneWidget);
    expect(find.text('Ativo'), findsOneWidget);
  });

  testWidgets('SIGNATURE mostra snackbar ao tocar', (tester) async {
    await pumpApp(
      tester,
      SignatureQuestionWidget(
        question: questionFixture(name: 'Assinatura', fieldType: 'SIGNATURE'),
        onAnswerChanged: (_) {},
      ),
    );

    await tester.tap(find.text('Toque para assinar'));
    await tester.pump();
    expect(
      find.text('Funcionalidade de assinatura em desenvolvimento'),
      findsOneWidget,
    );
  });
}
