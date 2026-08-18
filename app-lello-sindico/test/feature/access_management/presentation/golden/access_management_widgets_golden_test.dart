import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/access_management/presentation/pages/access_management_error_page.dart';
import 'package:lello/feature/access_management/presentation/pages/access_management_facial_biometric_error.dart';
import 'package:lello/feature/access_management/presentation/widgets/access_management_link_dialog.dart';
import 'package:lello/feature/access_management/presentation/widgets/access_management_sms_dialog.dart';

import '../../../../helpers/pump_app.dart';

const _labels = {
  'residents_send_invite': 'Enviar convite',
  'residents_dialog_link_title': 'O convite será enviado por link.',
  'residents_dialog_link_subtitle': 'Compartilhe com o morador.',
  'residents_send_link': 'Enviar link',
  'cancel': 'Cancelar',
  'residents_dialog_sms_subtitle': 'Enviar SMS para % (#)?',
  'residents_send_sms': 'Enviar SMS',
};

void main() {
  testWidgets('golden — diálogo de convite por link', (tester) async {
    await pumpApp(
      tester,
      AccessManagementLinkDialog(sendLink: () {}),
      localized: true,
      locOverrides: _labels,
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/access_link_dialog.png'),
    );
  });

  testWidgets('golden — diálogo de convite por SMS', (tester) async {
    await pumpApp(
      tester,
      AccessManagementSmsDialog(
        phone: '11987654321',
        name: 'Maria',
        sendSms: () {},
        sendLink: () {},
      ),
      localized: true,
      locOverrides: _labels,
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/access_sms_dialog.png'),
    );
  });

  testWidgets('golden — página de erro de acesso', (tester) async {
    await pumpApp(
      tester,
      const AccessManagementErrorPage(),
      wrapInScaffold: false,
      localized: true,
      locOverrides: const {
        'agreements_proposals_post_error': 'Não foi possível concluir.',
        'ok': 'OK',
      },
      surface: const Size(400, 720),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/access_error_page.png'),
    );
  });

  testWidgets('golden — erro de biometria facial', (tester) async {
    await pumpApp(
      tester,
      const AccessManagementFacialBiometricErrorPage(
        message: 'Não foi possível capturar o rosto.',
        code: 'E42',
      ),
      wrapInScaffold: false,
      localized: true,
      locOverrides: const {
        'facial_biometric_error_title': 'Falha na biometria',
        'try_again': 'Tentar novamente',
      },
      surface: const Size(400, 720),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/access_facial_error.png'),
    );
  });
}
