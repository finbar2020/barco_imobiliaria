import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/unit/presentation/page/unit_detail_invite_failed_page.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('tenta novamente no convite da unidade', (tester) async {
    await pumpApp(
      tester,
      const UnitDetailInviteErrorPage(),
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
