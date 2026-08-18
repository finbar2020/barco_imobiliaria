import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/presentation/task/pages/file_preview_page.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('golden — preview de arquivo desconhecido', (tester) async {
    await pumpApp(
      tester,
      const FilePreviewPage(
        url: 'https://example.com/nota.txt',
        filename: 'nota.txt',
        extension: 'txt',
      ),
      wrapInScaffold: false,
      surface: const Size(400, 360),
      scaffoldBackgroundColor: const Color(0xFF2C2C2C),
    );

    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/file_preview_txt.png'),
    );
  });

  testWidgets('golden — preview decodifica o nome com barra', (tester) async {
    await pumpApp(
      tester,
      const FilePreviewPage(
        url: 'https://example.com/arquivo.zip',
        filename: 'pasta%2Frelatorio.ZIP',
        extension: 'ZIP',
      ),
      wrapInScaffold: false,
      surface: const Size(400, 360),
      scaffoldBackgroundColor: const Color(0xFF2C2C2C),
    );

    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/file_preview_zip.png'),
    );
  });
}
