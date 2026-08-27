import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:essentials/modal/pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfrx/pdfrx.dart';

import '../helpers/pump_app.dart';
import 'pdf_test_support.dart';

void main() {
  late FakePdfrxEntryFunctions pdfrx;
  late FakePathProvider paths;
  late FakeOpenFile openFile;
  late FakeShare share;
  late Directory dir;
  late File pdf;

  setUpAll(() {
    share = instalaShareFalso();
  });

  setUp(() {
    dir = criaTemp('pdf_viewer');
    pdf = File('${dir.path}/doc.pdf')..writeAsStringSync('%PDF-1.4 fake');
    pdfrx = instalaPdfrxFalso();
    paths = instalaPathProviderFalso(dir);
    openFile = instalaOpenFileFalso();
    share.params.clear();
    share.falha = false;
  });

  /// Monta a tela e deixa o PdfViewer tentar abrir o arquivo (e falhar).
  Future<void> monta(WidgetTester tester, Widget tela) async {
    await pumpApp(tester, tela,
        wrapInScaffold: false, shrinkWrap: false, settle: false);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  }

  Future<void> esperaFlushbar(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
  }

  Future<void> limpa(WidgetTester tester) async {
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 6));
    await tester.pumpAndSettle();
    await tester.pumpWidget(const SizedBox());
  }

  testWidgets('arquivo local: app bar, botões e banner de erro do visualizador',
      (tester) async {
    await monta(tester, PDFScreen(pdfFile: pdf, title: 'Contrato', canDownload: true));
    expect(find.text('Contrato'), findsOneWidget);
    expect(find.byIcon(Icons.download), findsOneWidget);
    expect(find.byIcon(Icons.share), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.byType(PdfViewer), findsOneWidget);
    expect(pdfrx.abertos, [pdf.path]);
    expect(find.text('unable_to_load'), findsOneWidget);
    await expectLater(
        findGoldenSurface(), matchesGoldenFile('goldens/pdf_viewer_local.png'));
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('sem canDownload não há botão de download', (tester) async {
    await monta(tester, PDFScreen(pdfFile: pdf));
    expect(find.byIcon(Icons.download), findsNothing);
    expect(find.byIcon(Icons.share), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('botão voltar fecha a tela', (tester) async {
    await pumpApp(tester, const Text('home'),
        routes: {'/pdf': (_) => PDFScreen(pdfFile: pdf, title: 'X')});
    Navigator.pushNamed(tester.element(find.text('home')), '/pdf');
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('X'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.byType(PDFScreen), findsNothing);
    expect(find.text('home'), findsOneWidget);
  });

  group('download', () {
    testWidgets('copia para o armazenamento externo, abre e avisa',
        (tester) async {
      await monta(tester, PDFScreen(pdfFile: pdf, canDownload: true, fileName: 'meu.pdf'));
      await tester.tap(find.byIcon(Icons.download));
      // Enquanto copia, o botão vira um indicador de progresso.
      await tester.pump();
      expect(find.byIcon(Icons.download), findsNothing);
      expect(
          find.descendant(
              of: find.byType(IconButton),
              matching: find.byType(CircularProgressIndicator)),
          findsOneWidget);
      await tester.runAsync(() => Future.delayed(const Duration(milliseconds: 300)));
      await esperaFlushbar(tester);
      expect(find.byIcon(Icons.download), findsOneWidget);

      final destino = '${dir.path}/external/meu.pdf';
      expect(File(destino).existsSync(), isTrue);
      expect(openFile.abertos, [destino]);
      expect(find.text('download_success'), findsOneWidget);
      await limpa(tester);
    });

    testWidgets('sem fileName usa o nome do arquivo', (tester) async {
      await monta(tester, PDFScreen(pdfFile: pdf, canDownload: true));
      await tester.tap(find.byIcon(Icons.download));
      await tester.runAsync(() => Future.delayed(const Duration(milliseconds: 300)));
      await esperaFlushbar(tester);
      expect(openFile.abertos, ['${dir.path}/external/doc.pdf']);
      await limpa(tester);
    });

    /// Corrigido: falha na cópia (aqui o destino não é um diretório) é
    /// propagada por `_saveFile` e o usuário vê "download_error", nunca
    /// "download_success".
    testWidgets('falha ao copiar avisa download_error', (tester) async {
      paths.externoEhArquivo = true;
      await monta(tester, PDFScreen(pdfFile: pdf, canDownload: true));
      await tester.tap(find.byIcon(Icons.download));
      await tester.runAsync(() => Future.delayed(const Duration(milliseconds: 300)));
      await esperaFlushbar(tester);
      expect(find.text('download_error'), findsOneWidget);
      expect(find.text('download_success'), findsNothing);
      expect(openFile.abertos, isEmpty);
      expect(find.byIcon(Icons.download), findsOneWidget);
      await limpa(tester);
    });

    /// Corrigido: sem diretório externo `_saveFile` avisa
    /// "canot_download_file" e devolve `false`, então `_handleDownload` não
    /// mostra "download_success".
    testWidgets('sem diretório externo avisa só canot_download_file',
        (tester) async {
      paths.semExterno = true;
      await monta(tester, PDFScreen(pdfFile: pdf, canDownload: true));
      await tester.tap(find.byIcon(Icons.download));
      await tester.runAsync(() => Future.delayed(const Duration(milliseconds: 300)));
      await esperaFlushbar(tester);
      expect(find.text('canot_download_file'), findsOneWidget);
      expect(find.text('download_success'), findsNothing);
      expect(find.text('download_error'), findsNothing);
      expect(openFile.abertos, isEmpty);
      await limpa(tester);
    });
  });

  group('compartilhar', () {
    testWidgets('com fileName copia para documentos e compartilha',
        (tester) async {
      await monta(tester, PDFScreen(pdfFile: pdf, fileName: 'compart.pdf'));
      await tester.tap(find.byIcon(Icons.share));
      await tester.pumpAndSettle();
      final params = share.params.single;
      expect(params.files!.single.path, '${dir.path}/docs/compart.pdf');
      expect(params.sharePositionOrigin, isNotNull);
      expect(File('${dir.path}/docs/compart.pdf').existsSync(), isTrue);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('sem fileName compartilha o arquivo original', (tester) async {
      await monta(tester, PDFScreen(pdfFile: pdf));
      await tester.tap(find.byIcon(Icons.share));
      await tester.pumpAndSettle();
      expect(share.params.single.files!.single.path, pdf.path);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('erro do plugin mostra share_error', (tester) async {
      share.falha = true;
      await monta(tester, PDFScreen(pdfFile: pdf));
      await tester.tap(find.byIcon(Icons.share));
      await esperaFlushbar(tester);
      expect(find.text('share_error'), findsOneWidget);
      expect(find.byType(Flushbar), findsOneWidget);
      await limpa(tester);
    });
  });

  group('acessibilidade', () {
    Widget acessivel(Widget child) => MediaQuery(
          data: const MediaQueryData(accessibleNavigation: true),
          child: child,
        );

    testWidgets('com texto extraído lista os parágrafos e alterna para o PDF',
        (tester) async {
      await monta(
        tester,
        acessivel(PDFScreen(
            pdfFile: pdf, title: 'Leitura', extractedText: 'Um\n\nDois\n\n Três ')),
      );
      expect(find.text('Um'), findsOneWidget);
      expect(find.text('Dois'), findsOneWidget);
      expect(find.text('Três'), findsOneWidget);
      expect(find.byType(PdfViewer), findsNothing);
      expect(find.byIcon(Icons.text_fields), findsOneWidget);
      await expectLater(findGoldenSurface(),
          matchesGoldenFile('goldens/pdf_viewer_acessivel.png'));

      await tester.tap(find.byIcon(Icons.text_fields));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(PdfViewer), findsOneWidget);
      expect(find.byIcon(Icons.picture_as_pdf), findsOneWidget);
      expect(find.text('Um'), findsNothing);

      await tester.tap(find.byIcon(Icons.picture_as_pdf));
      await tester.pump();
      expect(find.text('Um'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('sem texto extraído mostra o PDF direto', (tester) async {
      await monta(tester, acessivel(PDFScreen(pdfFile: pdf, extractedText: '  ')));
      expect(find.byType(PdfViewer), findsOneWidget);
      expect(find.byIcon(Icons.text_fields), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });
  });

  // Os cenários com `url` (cache manager) estão em pdf_viewer_url_test.dart.
}
