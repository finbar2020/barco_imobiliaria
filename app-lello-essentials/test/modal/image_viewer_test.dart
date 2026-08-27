import 'dart:io';

import 'package:essentials/modal/image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump_app.dart';
import 'pdf_test_support.dart';

void main() {
  late File imagem;

  setUp(() async {
    final dir = criaTemp('img_viewer');
    imagem = File('${dir.path}/foto.png');
  });

  /// A imagem precisa entrar no ImageCache antes de o widget ser montado:
  /// se o `Image.file` começar a carregar na zona fake do teste, o stream
  /// fica pendente para sempre e o `precacheImage` nunca completa.
  Future<void> preCarrega(WidgetTester tester, File f) async {
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    await tester.runAsync(
        () => precacheImage(FileImage(f), tester.element(find.byType(SizedBox))));
  }

  testWidgets('mostra o título e a imagem do arquivo', (tester) async {
    await tester.runAsync(() async => imagem.writeAsBytesSync(await criaPng()));
    await preCarrega(tester, imagem);
    await pumpApp(tester, IMGScreen(imageFile: imagem, title: 'Foto'),
        wrapInScaffold: false, shrinkWrap: false);

    expect(find.text('Foto'), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    final img = tester.widget<Image>(find.byType(Image));
    expect((img.image as FileImage).file.path, imagem.path);
    await expectLater(
        findGoldenSurface(), matchesGoldenFile('goldens/image_viewer.png'));
  });

  testWidgets('título padrão é vazio', (tester) async {
    await tester.runAsync(() async => imagem.writeAsBytesSync(await criaPng()));
    await pumpApp(tester, IMGScreen(imageFile: imagem),
        wrapInScaffold: false, shrinkWrap: false, settle: false);
    await tester.pump();
    expect(tester.widget<IMGScreen>(find.byType(IMGScreen)).title, '');
  });
}
