import 'package:colaborador/feature/home/presentation/widget/pages/home_page/widgets/whatsapp_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('golden — whatsapp icon', (tester) async {
    await pumpApp(
      tester,
      const WhatsappIcon(),
      localized: true,
      surface: const Size(80, 60),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/whatsapp_icon.png'),
    );
  });
}
