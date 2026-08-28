import 'dart:convert';
import 'dart:io';

import 'package:essentials/methods/files/file_icon.dart';
import 'package:essentials/methods/files/file_methods.dart';
import 'package:essentials/modal/pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfrx/pdfrx.dart';

import '../../helpers/pump_app.dart';
import '../../modal/pdf_test_support.dart';

/// O pacote não declara assets no pubspec: entregamos o SVG do ícone de
/// fechar por um bundle falso.
class _SvgBundle extends CachingAssetBundle {
  static const _svg =
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 12 12">'
      '<path d="M1 1L11 11M11 1L1 11" stroke="white" stroke-width="2"/></svg>';

  @override
  Future<ByteData> load(String key) async =>
      ByteData.sublistView(Uint8List.fromList(utf8.encode(_svg)));
}

void main() {
  late Directory dir;
  late File pdf;
  late File png;

  setUp(() {
    dir = criaTemp('file_icon');
    pdf = File('${dir.path}/doc.pdf')..writeAsStringSync('%PDF-1.4');
    png = File('${dir.path}/foto.png');
    instalaPdfrxFalso();
    instalaPathProviderFalso(dir);
  });

  Widget comBundle(Widget child) =>
      DefaultAssetBundle(bundle: _SvgBundle(), child: child);

  testWidgets('imagem com botão de excluir', (tester) async {
    await tester.runAsync(() async => png.writeAsBytesSync(await criaPng()));
    // Pré-carrega antes de montar: um Image.file iniciado na zona fake nunca
    // completa e travaria o precacheImage.
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    await tester.runAsync(() =>
        precacheImage(FileImage(png), tester.element(find.byType(SizedBox))));
    var excluido = 0;
    await pumpApp(
      tester,
      comBundle(FileIcon(file: png, imageIconSize: 96, deleteFile: () => excluido++)),
    );

    expect(find.byType(Hero), findsOneWidget);
    expect(find.byType(SvgPicture), findsOneWidget);
    await expectLater(
        findGoldenSurface(), matchesGoldenFile('goldens/file_icon_imagem.png'));

    await tester.tap(find.byType(IconButton));
    expect(excluido, 1);
  });

  testWidgets('sem deleteFile não mostra o botão', (tester) async {
    png.writeAsBytesSync(png1x1);
    await pumpApp(tester, comBundle(FileIcon(file: png, imageIconSize: 48)),
        settle: false);
    await tester.pump();
    expect(find.byType(IconButton), findsNothing);
    expect(find.byType(SvgPicture), findsNothing);
  });

  testWidgets('toque abre a DetailScreenFile', (tester) async {
    png.writeAsBytesSync(png1x1);
    await pumpApp(tester, comBundle(FileIcon(file: png, imageIconSize: 48)),
        settle: false);
    await tester.pump();
    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();
    expect(find.byType(DetailScreenFile), findsOneWidget);
  });

  testWidgets('PDF mostra o visualizador e abre a PDFScreen com download',
      (tester) async {
    await pumpApp(
      tester,
      comBundle(FileIcon(file: pdf, imageIconSize: 120, canDownloadFile: true)),
      settle: false,
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    // O banner de erro padrão do pdfrx (com stack trace) estoura a caixa de
    // 120 px: o overflow é só do visualizador falho, não do FileIcon.
    expect(tester.takeException(), isA<FlutterError>());
    expect(find.byType(PdfViewer), findsOneWidget);
    expect(tester.widget<FileIcon>(find.byType(FileIcon)).canDownloadFile, isTrue);

    await tester.tap(find.byType(InkWell));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(tester.widget<PDFScreen>(find.byType(PDFScreen)).canDownload, isTrue);
    await tester.pumpWidget(const SizedBox());
  });
}
