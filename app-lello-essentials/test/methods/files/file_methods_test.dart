import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:essentials/methods/files/file_methods.dart';
import 'package:essentials/modal/pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:pdfrx/pdfrx.dart';

import '../../helpers/pump_app.dart';
import '../../modal/pdf_test_support.dart';

void main() {
  late Directory dir;
  late File pdf;
  late File png;
  late FakePathProvider paths;

  setUp(() {
    dir = criaTemp('file_methods');
    pdf = File('${dir.path}/doc.pdf')..writeAsStringSync('%PDF-1.4');
    png = File('${dir.path}/foto.png')..writeAsBytesSync(png1x1);
    instalaPdfrxFalso();
    paths = instalaPathProviderFalso(dir);
  });

  group('viewFile', () {
    testWidgets('PDF abre a PDFScreen com o título PDF', (tester) async {
      await pumpApp(tester, const Text('home'));
      FileMethods.viewFile(tester.element(find.text('home')), pdf,
          canDownload: true);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      final tela = tester.widget<PDFScreen>(find.byType(PDFScreen));
      expect(tela.title, 'PDF');
      expect(tela.canDownload, isTrue);
      expect(tela.pdfFile, pdf);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('imagem abre a DetailScreenFile e toque fecha', (tester) async {
      await pumpApp(tester, const Text('home'));
      FileMethods.viewFile(tester.element(find.text('home')), png);
      await tester.pumpAndSettle();
      expect(find.byType(DetailScreenFile), findsOneWidget);
      expect(find.byType(Hero), findsOneWidget);
      // A imagem ainda não decodificou (tamanho zero), então o toque é
      // disparado direto no GestureDetector da tela.
      tester
          .widget<GestureDetector>(find.descendant(
              of: find.byType(DetailScreenFile),
              matching: find.byType(GestureDetector)))
          .onTap!();
      await tester.pumpAndSettle();
      expect(find.byType(DetailScreenFile), findsNothing);
      expect(find.text('home'), findsOneWidget);
    });

    /// Corrigido: sem Navigator o `catch` de `viewFile` não tenta mostrar o
    /// Flushbar (que também precisaria de Navigator/Localizations); só
    /// registra o erro e retorna, sem relançar.
    testWidgets('sem Navigator o erro é registrado e não relançado',
        (tester) async {
      await tester.pumpWidget(const Directionality(
          textDirection: TextDirection.ltr, child: Text('solto')));
      final context = tester.element(find.text('solto'));
      expect(() => FileMethods.viewFile(context, pdf), returnsNormally);
      await tester.pump();
      expect(find.byType(Flushbar), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });

  group('imageBody', () {
    testWidgets('PDF vira um PdfViewer sem interação', (tester) async {
      await pumpApp(tester, Center(
        child: Builder(
          builder: (context) =>
              FileMethods.imageBody(context, pdf, imageIconSize: 80),
        ),
      ), settle: false);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      // O banner de erro padrão do pdfrx (com stack trace) estoura os 80 px.
      expect(tester.takeException(), isA<FlutterError>());
      expect(find.byType(IgnorePointer), findsWidgets);
      expect(find.byType(PdfViewer), findsOneWidget);
      expect(tester.getSize(find.byType(PdfViewer)), const Size(80, 80));
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('imagem vira Image.file dentro de um Hero', (tester) async {
      await pumpApp(tester, Center(
        child: Builder(
          builder: (context) =>
              FileMethods.imageBody(context, png, imageIconSize: 40),
        ),
      ), settle: false);
      await tester.pump();
      expect(find.byType(Hero), findsOneWidget);
      final img = tester.widget<Image>(find.byType(Image));
      expect((img.image as FileImage).file.path, png.path);
      expect(tester.getSize(find.byType(Hero)), const Size(40, 40));
    });
  });

  testWidgets('showSnackBar mostra um Flushbar com o texto', (tester) async {
    await pumpApp(tester, const Text('home'));
    FileMethods.showSnackBar(tester.element(find.text('home')), 'aviso');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(Flushbar), findsOneWidget);
    expect(find.text('aviso'), findsOneWidget);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
    expect(find.byType(Flushbar), findsNothing);
  });

  group('getFileFromUrl', () {
    MockClient cliente({bool falha = false}) => MockClient((req) async {
          if (falha) throw const SocketException('sem rede');
          return http.Response.bytes([1, 2, 3], 200);
        });

    test('salva no diretório de documentos com o nome padrão', () async {
      final file = await http.runWithClient(
          () => FileMethods.getFileFromUrl('http://x/a.pdf'), cliente);
      expect(file.path, '${dir.path}/docs/AppLelloFile');
      expect(file.readAsBytesSync(), [1, 2, 3]);
    });

    test('usa nome e caminho informados', () async {
      final destino = Directory('${dir.path}/custom')..createSync();
      final file = await http.runWithClient(
          () => FileMethods.getFileFromUrl('http://x/a.pdf',
              name: 'b.pdf', path: destino.path),
          cliente);
      expect(file.path, '${destino.path}/b.pdf');
      expect(file.existsSync(), isTrue);
    });

    test('erro de rede vira Exception própria', () async {
      expect(
          http.runWithClient(() => FileMethods.getFileFromUrl('http://x/a.pdf'),
              () => cliente(falha: true)),
          throwsA(predicate(
              (e) => e is Exception && e.toString().contains('Error opening url file'))));
    });
  });

  testWidgets('DetailScreenFile mostra a imagem', (tester) async {
    await pumpApp(tester, DetailScreenFile(attachmentFile: png),
        wrapInScaffold: false, shrinkWrap: false, settle: false);
    await tester.pump();
    expect(find.byType(Image), findsOneWidget);
    expect(paths.raiz.existsSync(), isTrue);
  });
}
