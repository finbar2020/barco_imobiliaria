import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/reports_book/domain/entity/report.dart';
import 'package:lello/feature/reports_book/domain/entity/report_contents.dart';
import 'package:lello/feature/reports_book/domain/entity/unit.dart' as report_unit;
import 'package:lello/feature/reports_book/presentation/widgets/reply_preview_widget.dart';
import 'package:lello/feature/reports_book/presentation/widgets/reports_card_widget.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('golden — cartão de ocorrência', (tester) async {
    await pumpApp(
      tester,
      ReportsCardWidget(
        report: Report(
          numReport: '1042',
          typeReport: 'COMPLAINT',
          dateReport: DateTime(2026, 3, 9, 14, 5),
          closed: false,
          isPublic: true,
          residentsName: 'Maria Silva',
        ),
        onTap: () {},
      ),
      localized: true,
      locOverrides: const {
        'reports_type_complaint': 'Reclamação',
        'report_public': 'Público',
      },
      shrinkWrap: false,
      surface: const Size(400, 220),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/reports_card.png'),
    );
  });

  testWidgets('golden — ocorrência confidencial encerrada com mensagem nova',
      (tester) async {
    await pumpApp(
      tester,
      ReportsCardWidget(
        report: Report(
          numReport: '88',
          typeReport: 'SUGGESTION',
          dateReport: DateTime(2026, 4, 1, 9),
          closed: true,
          isPublic: false,
          newMessage: true,
          residentsName: 'Ana Lima',
          unit: report_unit.Unit(name: '202'),
          reportContents: [
            ReportContents(id: 'c1'),
            ReportContents(id: 'c2'),
          ],
        ),
        onTap: () {},
      ),
      localized: true,
      locOverrides: const {
        'reports_type_suggestion': 'Sugestão',
        'report_confidential': 'Confidencial',
        'reports_new_report': 'Nova ocorrência',
        'reports_condominium_replica': 'Réplica',
      },
      shrinkWrap: false,
      surface: const Size(400, 240),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/reports_card_closed.png'),
    );
  });

  testWidgets('golden — prévia da resposta sem anexo', (tester) async {
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          return ReplyPreviewWidget(
            theme: Theme.of(context),
            report: Report(typeReport: 'COMPLAINT'),
            content: ReportContents(
              content: 'A piscina permanece fechada nesta semana.',
              dateContent: DateTime(2026, 8, 10, 11, 30),
            ),
          );
        },
      ),
      localized: true,
      locOverrides: const {
        'reports_subject': 'Assunto',
        'reports_type_complaint': 'Reclamação',
        'reports_message': 'Mensagem',
      },
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/reports_reply_preview.png'),
    );
  });

  testWidgets('golden — prévia sem conteúdo', (tester) async {
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          return ReplyPreviewWidget(
            theme: Theme.of(context),
            report: Report(typeReport: 'SUGGESTION'),
            content: ReportContents(
              content: '',
              dateContent: DateTime(2026, 8, 11, 9),
            ),
          );
        },
      ),
      localized: true,
      locOverrides: const {
        'reports_subject': 'Assunto',
        'reports_type_suggestion': 'Sugestão',
        'reports_message': 'Mensagem',
        'reports_no_content': 'Sem conteúdo',
      },
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/reports_reply_preview_empty.png'),
    );
  });

  testWidgets('golden — prévia com anexo PDF', (tester) async {
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          return ReplyPreviewWidget(
            theme: Theme.of(context),
            report: Report(typeReport: 'COMPLAINT'),
            content: ReportContents(
              content: 'Segue o documento em anexo.',
              dateContent: DateTime(2026, 8, 10, 11, 30),
              attachmentFile: File('comprovante.pdf'),
              attachmentType: 'application/pdf',
            ),
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
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/reports_reply_preview_pdf.png'),
    );
  });

  testWidgets('golden — prévia com anexo de imagem', (tester) async {
    final image = File('${Directory.systemTemp.path}/reply_preview_test.png')
      ..writeAsBytesSync(
        base64Decode(
          'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==',
        ),
      );
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          return ReplyPreviewWidget(
            theme: Theme.of(context),
            report: Report(typeReport: 'COMPLAINT'),
            content: ReportContents(
              content: 'Foto da área comum.',
              dateContent: DateTime(2026, 8, 10, 11, 30),
              attachmentFile: image,
              attachmentType: 'image/png',
            ),
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
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/reports_reply_preview_image.png'),
    );
  });
}
