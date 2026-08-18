import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/home/presentation/widget/home_dialogs/switch_role_alert_dialog/switch_role_alert_dialog_widget.dart';

import '../../../../helpers/pump_app.dart';

const _switchRoleLabels = {
  'switch_role_alert_dialog_title': 'Trocar de perfil',
  'switch_role_alert_dialog_body_text':
      'Você está no perfil de síndico neste momento.',
  'switch_role_alert_dialog_would_now': 'Deseja ir agora?',
  'switch_role_alert_not_now': 'Agora não',
  'switch_role_alert_take_me_there': 'Leve-me',
};

void main() {
  testWidgets('golden — alerta de troca de perfil', (tester) async {
    await pumpApp(
      tester,
      SwitchRoleAlertDialogWidget(onPressed: () {}),
      localized: true,
      locOverrides: _switchRoleLabels,
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/switch_role_alert.png'),
    );
  });
}
