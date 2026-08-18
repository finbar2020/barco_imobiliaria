import 'package:colaborador/feature/documents/presentation/document_file/widget/document_file_failed_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('golden — document file failed', (tester) async {
    await pumpApp(
      tester,
      const DocumentFileFailedBody(),
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 520),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/document_file_failed.png'),
    );
  });
}
