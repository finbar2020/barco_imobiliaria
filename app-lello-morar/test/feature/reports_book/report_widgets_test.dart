import 'package:essentials/essentials.dart'
    hide isNull, isNotNull, Image, DetailScreenFile;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/feature/reports_book/domain/entity/report_contents.dart';
import 'package:morar/feature/reports_book/presentation/bloc/reports_state.dart';
import 'package:morar/feature/reports_book/presentation/controller/reports_controller.dart';
import 'package:morar/feature/reports_book/presentation/widgets/load_pdf_by_link.dart';
import 'package:morar/feature/reports_book/presentation/widgets/report_details_widget.dart';
import 'package:morar/feature/reports_book/presentation/widgets/report_message_widget.dart';
import 'package:morar/feature/reports_book/presentation/widgets/report_preview_widget.dart';

import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';
import 'reports_book_page_helpers.dart';

void main() {
  late PageHarness harness;

  setUp(() async {
    harness = await installPageHarness();
    installFakePickers();
  });

  group('ReportMessageWidget', () {
    Future<ReportsController> pumpMessage(
      WidgetTester tester, {
      required ReportContents content,
      bool reply = false,
    }) async {
      final controller = harness.resolve<ReportsController>();
      await pumpApp(
        tester,
        ReportMessageWidget(
          theme: LelloTheme.light,
          content: content,
          controller: controller,
          report: buildReport(id: reply ? 'r1' : null),
        ),
        localized: true,
        shrinkWrap: false,
        surface: const Size(400, 900),
      );
      return controller;
    }

    testWidgets('escolher público sim/não e ver a dica', (tester) async {
      final content = buildContent();
      await pumpMessage(tester, content: content);

      await tester.tap(find.text('no'));
      await tester.pumpAndSettle();
      expect(content.public, isFalse);

      await tester.tap(find.text('yes'));
      await tester.pumpAndSettle();
      expect(content.public, isTrue);

      await tester.tap(find.byIcon(Icons.info_outline));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('reports_public_tooltip'), findsOneWidget);
      await tester.pump(const Duration(seconds: 6));
      await tester.pumpAndSettle();
    });

    testWidgets('anexo de imagem mostra a miniatura e pode ser removido',
        (tester) async {
      final content = buildContent(
        attachmentType: 'image',
        attachmentFile: tempPng(),
      );
      await pumpMessage(tester, content: content);

      expect(findSvg('assets/ic_close.svg'), findsOneWidget);
      expect(find.text('reports_request_pick_image_from_gallery'), findsNothing);
      final thumb = find.byWidgetPredicate((w) =>
          w is Container &&
          w.decoration is BoxDecoration &&
          (w.decoration as BoxDecoration).image?.image is FileImage);
      expect(thumb, findsOneWidget);

      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      expect(content.attachmentFile, isNull);
      expect(findSvg('assets/ic_close.svg'), findsNothing);
      // Corrigido: a linha de anexos usa `Expanded` e não estoura em 400px.
      expect(tester.takeException(), isNull);
      expect(find.text('reports_request_pick_image_from_gallery'), findsOneWidget);
      expect(find.text('reports_camera'), findsOneWidget);
      expect(find.text('reports_create_attachment'), findsOneWidget);
    });

    testWidgets('anexo em pdf mostra o ícone de documento', (tester) async {
      final content = buildContent(
        attachmentType: 'application/pdf',
        attachmentFile: tempAttachment(name: 'doc.txt'),
      );
      await pumpMessage(tester, content: content, reply: true);

      expect(findSvg('assets/ic_documents.svg'), findsOneWidget);
      expect(find.text('reports_public'), findsNothing);
      expect(find.text('send'), findsOneWidget);
    });

    testWidgets('digitar atualiza o conteúdo e enviar chama o controller',
        (tester) async {
      harness.http.on('PUT', putContentPath('r1'),
          body: reportJson('r1', numReport: '101'));
      final content = buildContent(content: null);
      final controller = await pumpMessage(tester, content: content, reply: true);

      await tester.enterText(find.byType(TextField), 'Nova mensagem');
      expect(content.content, 'Nova mensagem');

      await tester.tap(find.text('send'));
      await tester.pumpAndSettle();

      expect(harness.http.requests.single.method, 'PUT');
      expect(controller.reportsBloc.state, isA<ReportPostedState>());
    });
  });

  group('ReportPreviewWidget', () {
    Future<void> pumpPreview(WidgetTester tester, ReportContents content,
        {bool settle = true}) =>
        pumpApp(
          tester,
          ReportPreviewWidget(
            report: buildReport(),
            content: content,
            theme: LelloTheme.light,
          ),
          localized: true,
          shrinkWrap: false,
          settle: settle,
        );

    testWidgets('sem conteúdo e não pública', (tester) async {
      await pumpPreview(tester, buildContent(content: '', public: false));

      expect(find.text('reports_type_complaint'), findsOneWidget);
      expect(find.text('03/02/2026 14h:05m'), findsOneWidget);
      expect(find.text('reports_no_content'), findsOneWidget);
      expect(find.text('reports_attached_file'), findsNothing);
      expect(find.text('no'), findsOneWidget);
    });

    testWidgets('pdf por link abre o carregador de pdf', (tester) async {
      await pumpPreview(
        tester,
        buildContent(
          attachmentType: 'application/pdf',
          attachmentLink: 'http://localhost/doc.pdf',
        ),
      );
      expect(findSvg('assets/ic_documents.svg'), findsOneWidget);

      final errors = await runGuarded(tester, () async {
        await tester.tap(find.byType(InkWell));
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
      });

      expect(find.byType(ShowPDFWidget), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // Sem path_provider o cache do pdf falha fora da árvore de widgets
      // (o `DefaultCacheManager` é singleton: só o primeiro uso reporta).
      expect(errors.every((e) => e.toString().contains('path_provider')), isTrue);
    });

    testWidgets('pdf em arquivo abre o visualizador de pdf', (tester) async {
      await pumpPreview(
        tester,
        buildContent(
          attachmentType: 'application/pdf',
          attachmentFile: tempAttachment(name: 'doc.pdf'),
        ),
      );
      expect(findSvg('assets/ic_documents.svg'), findsOneWidget);

      await runGuarded(tester, () async {
        await tester.tap(find.byType(InkWell));
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
      });

      expect(find.byType(PDFScreen), findsOneWidget);
      tester.takeException();
    });

    testWidgets('imagem por link abre o detalhe e fecha ao tocar', (tester) async {
      await pumpPreview(
        tester,
        buildContent(
          attachmentType: 'image/png',
          attachmentLink: 'http://localhost/foto.png',
        ),
        settle: false,
      );
      expect(find.byType(CachedNetworkImage), findsOneWidget);

      await tester.tap(find.byType(CachedNetworkImage));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(DetailScreenLink), findsOneWidget);

      await tester.tap(find.byType(DetailScreenLink));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(DetailScreenLink), findsNothing);
    });

    testWidgets('imagem em arquivo abre o detalhe e fecha ao tocar',
        (tester) async {
      await pumpPreview(
        tester,
        buildContent(
          attachmentType: 'image',
          attachmentFile: tempPng(),
        ),
      );
      expect(find.byType(Image), findsOneWidget);

      await tester.tap(find.byType(Image));
      await tester.pumpAndSettle();
      expect(find.byType(DetailScreenFile), findsOneWidget);

      // Enquanto o arquivo não carrega a imagem tem 0x0 e não recebe toque:
      // aciona o onTap do detector diretamente.
      final detector = tester.widget<GestureDetector>(find.descendant(
          of: find.byType(DetailScreenFile), matching: find.byType(GestureDetector)));
      detector.onTap!();
      await tester.pumpAndSettle();
      expect(find.byType(DetailScreenFile), findsNothing);
    });
  });

  group('ReportDetailsWidget', () {
    testWidgets('anexo em pdf abre o carregador de pdf', (tester) async {
      await pumpApp(
        tester,
        ReportDetailsWidget(
          typeReport: 'reports_type_complaint',
          httpHeaders: null,
          content: buildContent(
            attachment: 'doc.pdf',
            attachmentType: 'application/pdf',
            attachmentLink: 'http://localhost/doc.pdf',
          ),
        ),
        localized: true,
        shrinkWrap: false,
      );

      await runGuarded(tester, () async {
        await tester.tap(find.byType(InkWell));
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
      });

      expect(find.byType(ShowPDFWidget), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  testWidgets('ShowPDFWidget mostra o spinner enquanto baixa o pdf', (tester) async {
    final errors = await runGuarded(tester, () async {
      await tester.pumpWidget(const MaterialApp(
        home: ShowPDFWidget(attachmentLink: 'http://localhost/x.pdf'),
      ));
    });

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(errors.every((e) => e.toString().contains('path_provider')), isTrue);
  });
}
