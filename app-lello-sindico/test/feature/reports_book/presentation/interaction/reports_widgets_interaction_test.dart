import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/reports_book/domain/entity/report.dart';
import 'package:lello/feature/reports_book/domain/entity/report_contents.dart';
import 'package:lello/feature/reports_book/presentation/widgets/reply_preview_widget.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('remove o anexo PDF da prévia', (tester) async {
    final content = ReportContents(
      content: 'Segue o documento em anexo.',
      dateContent: DateTime(2026, 8, 10, 11, 30),
      attachmentFile: File('comprovante.pdf'),
      attachmentType: 'application/pdf',
    );
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          return ReplyPreviewWidget(
            theme: Theme.of(context),
            report: Report(typeReport: 'COMPLAINT'),
            content: content,
          );
        },
      ),
      localized: true,
      locOverrides: const {
        'reports_subject': 'Assunto',
        'reports_type_complaint': 'Reclamação',
        'reports_message': 'Mensagem',
        'reports_attached_file': 'Arquivo anexado',
      },
    );

    expect(find.text('Arquivo anexado'), findsOneWidget);
    await tester.tap(find.byType(IconButton));
    await tester.pump();
    expect(content.attachmentFile, isNull);
    expect(find.text('Arquivo anexado'), findsNothing);
  });

  testWidgets('abre a imagem anexada', (tester) async {
    final image = File('${Directory.systemTemp.path}/reply_preview_tap.png')
      ..writeAsBytesSync(
        base64Decode(
          'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==',
        ),
      );
    final content = ReportContents(
      content: 'Foto da área comum.',
      dateContent: DateTime(2026, 8, 10, 11, 30),
      attachmentFile: image,
      attachmentType: 'image/png',
    );
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          return ReplyPreviewWidget(
            theme: Theme.of(context),
            report: Report(typeReport: 'COMPLAINT'),
            content: content,
          );
        },
      ),
      localized: true,
      locOverrides: const {
        'reports_subject': 'Assunto',
        'reports_type_complaint': 'Reclamação',
        'reports_message': 'Mensagem',
        'reports_attached_file': 'Arquivo anexado',
      },
    );

    await tester.tap(find.byType(Image));
    await tester.pumpAndSettle();
    expect(find.byType(DetailScreenFile), findsOneWidget);
  });
}
