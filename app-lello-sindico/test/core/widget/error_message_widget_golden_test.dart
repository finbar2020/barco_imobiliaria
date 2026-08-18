import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/core/widget/error_message_widget.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('golden — mensagem de erro', (tester) async {
    await pumpApp(
      tester,
      const ErrorMessageWidget(
        message: 'Não foi possível carregar os dados.',
      ),
      shrinkWrap: false,
      surface: const Size(400, 240),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/error_message.png'),
    );
  });
}
