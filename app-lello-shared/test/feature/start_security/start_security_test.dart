import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/start_security/locked_start_security_page.dart';
import 'package:shared_features/feature/start_security/start_security.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('BlockedApp mostra o logo e a mensagem de bloqueio',
      (tester) async {
    await pumpApp(tester, BlockedApp(), wrapInScaffold: false, settle: false);
    await tester.pump();

    expect(find.text('device_access_denied_root_or_emulator'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    // O logo vem do bundle do app, não do pacote.
    tester.takeException();
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/blocked_app.png'),
    );
  });

  test('initializeApp só garante o binding', () async {
    await SecurityCheck.initializeApp(
        () => const SizedBox(), () => const SizedBox());
    expect(WidgetsBinding.instance, isNotNull);
  });

  /// Fora de release e fora de Android/iOS (o host dos testes é desktop) a
  /// checagem de root/emulador nunca bloqueia.
  test('checkSecurity não bloqueia em debug no host dos testes', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    expect(await SecurityCheck.checkSecurity(), isFalse);
  });
}
