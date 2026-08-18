import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/accountability/presentation/question_create/page/question_create_error_page.dart';
import 'package:lello/feature/accountability/presentation/question_create/page/question_create_success_page.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('botão voltar fecha a tela de sucesso', (tester) async {
    await pumpApp(
      tester,
      QuestionCreateSuccessPage(),
      wrapInScaffold: false,
      localized: true,
      locOverrides: const {
        'accounttability_question_success_title': 'Pergunta enviada',
        'accounttability_question_success_subtitle': 'Enviado',
        'back': 'Voltar',
      },
    );

    expect(find.text('Voltar'), findsOneWidget);
    await tester.tap(find.text('Voltar'));
    await tester.pumpAndSettle();
    expect(find.text('Pergunta enviada'), findsNothing);
  });

  testWidgets('botão editar fecha a tela de erro', (tester) async {
    await pumpApp(
      tester,
      QuestionCreateErrorPage(),
      wrapInScaffold: false,
      localized: true,
      locOverrides: const {
        'accounttability_question_error_title': 'Não foi possível enviar',
        'accounttability_question_error_subtitle': 'Tente novamente',
        'accounttability_question_error_edit': 'Editar',
        'cancel': 'Cancelar',
      },
    );

    expect(find.text('Não foi possível enviar'), findsOneWidget);
    await tester.tap(find.text('Editar'));
    await tester.pumpAndSettle();
    expect(find.text('Não foi possível enviar'), findsNothing);
  });
}
