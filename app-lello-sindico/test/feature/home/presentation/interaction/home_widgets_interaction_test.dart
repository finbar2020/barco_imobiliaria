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
  testWidgets('troca de perfil chama o callback', (tester) async {
    var tapped = false;
    await pumpApp(
      tester,
      SwitchRoleAlertDialogWidget(onPressed: () => tapped = true),
      localized: true,
      locOverrides: _switchRoleLabels,
    );

    await tester.tap(find.text('LEVE-ME'));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('troca de perfil pode ser adiada', (tester) async {
    var tapped = false;
    await pumpApp(
      tester,
      SwitchRoleAlertDialogWidget(onPressed: () => tapped = true),
      localized: true,
      locOverrides: _switchRoleLabels,
    );

    await tester.tap(find.text('AGORA NÃO'));
    await tester.pump();
    expect(tapped, isFalse);
  });
}
