import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/gdp/employee/presentation/page/employee_invite_failed_page.dart';

import '../../../../../helpers/pump_app.dart';

void main() {
  testWidgets('golden — erro ao convidar colaborador', (tester) async {
    await pumpApp(
      tester,
      const EmployeeInviteErrorPage(),
      wrapInScaffold: false,
      localized: true,
      locOverrides: const {
        'residents_link_error_title': 'Não foi possível enviar o convite',
        'residents_link_error_subtitle': 'Tente novamente mais tarde.',
        'try_again': 'Tentar novamente',
      },
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/employee_invite_error.png'),
    );
  });

  testWidgets('tenta novamente no convite do colaborador', (tester) async {
    await pumpApp(
      tester,
      const EmployeeInviteErrorPage(),
      wrapInScaffold: false,
      localized: true,
      locOverrides: const {
        'residents_link_error_title': 'Não foi possível enviar o convite',
        'residents_link_error_subtitle': 'Tente novamente mais tarde.',
        'try_again': 'Tentar novamente',
      },
    );

    expect(find.text('Não foi possível enviar o convite'), findsOneWidget);
    await tester.tap(find.text('Tentar novamente'));
    await tester.pumpAndSettle();
    expect(find.text('Não foi possível enviar o convite'), findsNothing);
  });
}
