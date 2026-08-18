import 'package:essentials/ui/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/presentation/task/pages/init_step/widgets/fields/date_question_widget.dart';
import 'package:lello/feature/maintenance_management/presentation/task/pages/init_step/widgets/fields/signature_question_widget.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/question_fixtures.dart';

void main() {
  testWidgets('DATE sem valor mostra placeholder', (tester) async {
    await pumpApp(
      tester,
      DateQuestionWidget(
        question: questionFixture(name: 'Data', fieldType: 'DATE'),
        onAnswerChanged: (_) {},
      ),
    );
    expect(find.text('Selecione uma data'), findsOneWidget);
  });

  testWidgets('DATE com valor parseado exibe a data', (tester) async {
    await pumpApp(
      tester,
      DateQuestionWidget(
        question: questionFixture(name: 'Data', fieldType: 'DATE'),
        currentAnswer: '15/01/2026',
        onAnswerChanged: (_) {},
      ),
    );
    expect(find.text('15/01/2026'), findsOneWidget);
  });

  testWidgets('DATE com valor inválido cai no placeholder', (tester) async {
    await pumpApp(
      tester,
      DateQuestionWidget(
        question: questionFixture(name: 'Data', fieldType: 'DATE'),
        currentAnswer: 'xyz',
        onAnswerChanged: (_) {},
      ),
    );
    expect(find.text('Selecione uma data'), findsOneWidget);
  });

  testWidgets('DATE abre o date picker e confirma a escolha', (tester) async {
    String? answer;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pt', 'BR'),
        supportedLocales: const [Locale('pt', 'BR')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: LelloTheme.light,
        home: Scaffold(
          body: DateQuestionWidget(
            question: questionFixture(name: 'Data', fieldType: 'DATE'),
            onAnswerChanged: (value) => answer = value,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Selecione uma data'));
    await tester.pumpAndSettle();
    expect(find.byType(DatePickerDialog), findsOneWidget);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(answer, isNotNull);
    expect(answer!.contains('/'), isTrue);
  });

  testWidgets('SIGNATURE sem assinatura mostra CTA e snackbar no toque',
      (tester) async {
    await pumpApp(
      tester,
      SignatureQuestionWidget(
        question: questionFixture(name: 'Assinatura', fieldType: 'SIGNATURE'),
        onAnswerChanged: (_) {},
      ),
    );
    expect(find.text('Toque para assinar'), findsOneWidget);
    await tester.tap(find.text('Toque para assinar'));
    await tester.pump();
    expect(find.text('Funcionalidade de assinatura em desenvolvimento'),
        findsOneWidget);
  });

  testWidgets('SIGNATURE com valor mostra Assinado', (tester) async {
    await pumpApp(
      tester,
      SignatureQuestionWidget(
        question: questionFixture(name: 'Assinatura', fieldType: 'SIGNATURE'),
        currentAnswer: 'base64',
        onAnswerChanged: (_) {},
      ),
    );
    expect(find.text('Assinado'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
  });
}
