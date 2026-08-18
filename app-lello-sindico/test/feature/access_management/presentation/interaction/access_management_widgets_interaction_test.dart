import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/access_management/presentation/pages/access_management_error_page.dart';
import 'package:lello/feature/access_management/presentation/pages/access_management_facial_biometric_error.dart';
import 'package:lello/feature/access_management/presentation/widgets/access_management_link_dialog.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  test('mascara o telefone no convite', () {
    final dialog = AccessManagementLinkDialog(sendLink: () {});
    expect(dialog.formatPhoneToSecurityText('11987654321'), '(11)98xxx-xxx1');
    expect(dialog.formatPhoneToSecurityText(null), '-');
  });

  testWidgets('enviar link dispara o callback', (tester) async {
    var sent = false;
    await pumpApp(
      tester,
      AccessManagementLinkDialog(sendLink: () => sent = true),
      localized: true,
      locOverrides: const {
        'residents_send_invite': 'Enviar convite',
        'residents_dialog_link_title': 'O convite será enviado por link.',
        'residents_dialog_link_subtitle': 'Compartilhe com o morador.',
        'residents_send_link': 'Enviar link',
        'cancel': 'Cancelar',
      },
    );
    await tester.tap(find.text('Enviar link'));
    await tester.pump();
    expect(sent, isTrue);
  });

  testWidgets('fecha a página de erro de acesso', (tester) async {
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          return TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const AccessManagementErrorPage(),
                ),
              );
            },
            child: const Text('Abrir'),
          );
        },
      ),
      localized: true,
      locOverrides: const {
        'agreements_proposals_post_error': 'Não foi possível concluir.',
        'ok': 'OK',
      },
      shrinkWrap: false,
      surface: const Size(400, 720),
    );

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.text('Error'), findsNothing);
  });

  testWidgets('fecha o erro de biometria facial', (tester) async {
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          return TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) =>
                      const AccessManagementFacialBiometricErrorPage(),
                ),
              );
            },
            child: const Text('Abrir'),
          );
        },
      ),
      localized: true,
      locOverrides: const {
        'facial_biometric_error_title': 'Falha na biometria',
        'facial_biometric_error_subtitle': 'Tente de novo.',
        'try_again': 'Tentar novamente',
      },
      shrinkWrap: false,
      surface: const Size(400, 720),
    );

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tentar novamente'));
    await tester.pumpAndSettle();
    expect(find.text('Falha na biometria'), findsNothing);
  });
}
