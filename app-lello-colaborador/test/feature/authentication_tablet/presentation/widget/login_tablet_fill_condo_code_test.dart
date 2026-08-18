import 'package:colaborador/feature/authentication_tablet/presentation/widget/login_tablet_fill_condo_code_widget.dart';
import 'package:essentials/essentials.dart' hide isNotNull, isNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('botão desabilitado sem código', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await pumpApp(
      tester,
      LoginTabletFillCondoCodeWidget(
        condoCodeTextEditingController: controller,
        signByCodeFunction: (_) {},
      ),
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 640),
    );

    final button = tester.widget<PrimaryButton>(find.byType(PrimaryButton));
    expect(button.onPressed, isNull);
  });

  testWidgets('envia código ao confirmar', (tester) async {
    final controller = TextEditingController(text: '123456');
    addTearDown(controller.dispose);
    String? sent;

    await pumpApp(
      tester,
      LoginTabletFillCondoCodeWidget(
        condoCodeTextEditingController: controller,
        signByCodeFunction: (code) => sent = code,
      ),
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 640),
    );

    await tester.tap(find.byType(PrimaryButton));
    await tester.pump();

    expect(sent, '123456');
  });

  testWidgets('habilita botão ao digitar', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await pumpApp(
      tester,
      LoginTabletFillCondoCodeWidget(
        condoCodeTextEditingController: controller,
        signByCodeFunction: (_) {},
      ),
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 640),
    );

    await tester.enterText(find.byType(TextFormField), '99');
    await tester.pump();

    final button = tester.widget<PrimaryButton>(find.byType(PrimaryButton));
    expect(button.onPressed, isNotNull);
  });

  testWidgets('exibe erro de código inválido', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await pumpApp(
      tester,
      LoginTabletFillCondoCodeWidget(
        condoCodeTextEditingController: controller,
        signByCodeFunction: (_) {},
        isFailure: true,
      ),
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 640),
    );

    expect(find.text('login_tablet_invalid_code'), findsOneWidget);
  });

  testWidgets('golden — preenchimento de código', (tester) async {
    final controller = TextEditingController(text: '123456');
    addTearDown(controller.dispose);

    await pumpApp(
      tester,
      LoginTabletFillCondoCodeWidget(
        condoCodeTextEditingController: controller,
        signByCodeFunction: (_) {},
      ),
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 640),
    );

    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/login_tablet_fill_condo_code.png'),
    );
  });
}
