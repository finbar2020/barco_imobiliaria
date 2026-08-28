// Fakes compartilhados pelos testes de PDF/arquivos (modal e methods/files):
// pdfrx sem lib nativa, path_provider, open_file e share_plus.
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_file_platform_interface/open_file_platform_interface.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:share_plus_platform_interface/share_plus_platform_interface.dart';

/// Documento falso: nunca é usado pelo código testado, só devolvido.
class FakePdfDocument implements PdfDocument {
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('FakePdfDocument.${invocation.memberName}');
}

/// Backend do pdfrx sem PDFium: `openFile` lança [erro] ou devolve um
/// documento falso quando [erro] é nulo.
class FakePdfrxEntryFunctions implements PdfrxEntryFunctions {
  Object? erro = StateError('sem pdfium no teste');
  final abertos = <String>[];

  @override
  Future<void> init() async {}

  @override
  Future<PdfDocument> openFile(
    String filePath, {
    PdfPasswordProvider? passwordProvider,
    bool firstAttemptByEmptyPassword = true,
    bool useProgressiveLoading = false,
  }) async {
    abertos.add(filePath);
    if (erro != null) throw erro!;
    return FakePdfDocument();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('FakePdfrx.${invocation.memberName}');
}

FakePdfrxEntryFunctions instalaPdfrxFalso() {
  final fake = FakePdfrxEntryFunctions();
  PdfrxEntryFunctions.instance = fake;
  return fake;
}

class FakePathProvider extends PathProviderPlatform
    with MockPlatformInterfaceMixin {
  FakePathProvider(this.raiz);
  final Directory raiz;
  bool semExterno = false;

  /// Quando verdadeiro, o "diretório" externo é um arquivo: cópias falham.
  bool externoEhArquivo = false;

  Directory _sub(String nome) => Directory('${raiz.path}/$nome')..createSync();

  @override
  Future<String?> getTemporaryPath() async => _sub('tmp').path;

  @override
  Future<String?> getApplicationSupportPath() async => _sub('support').path;

  @override
  Future<String?> getApplicationDocumentsPath() async => _sub('docs').path;

  @override
  Future<String?> getApplicationCachePath() async => _sub('cache').path;

  @override
  Future<String?> getLibraryPath() async => _sub('lib').path;

  @override
  Future<String?> getExternalStoragePath() async {
    if (semExterno) return null;
    if (externoEhArquivo) {
      return (File('${raiz.path}/external_arquivo')..writeAsStringSync('x')).path;
    }
    return _sub('external').path;
  }

  @override
  Future<String?> getDownloadsPath() async => _sub('downloads').path;
}

FakePathProvider instalaPathProviderFalso(Directory raiz) {
  final fake = FakePathProvider(raiz);
  PathProviderPlatform.instance = fake;
  return fake;
}

class FakeOpenFile extends OpenFilePlatform with MockPlatformInterfaceMixin {
  final abertos = <String?>[];

  @override
  Future<OpenResult> open(
    String? filePath, {
    String? type,
    bool isIOSAppOpen = false,
    String linuxDesktopName = 'xdg',
    bool linuxUseGio = false,
    bool linuxByProcess = false,
  }) async {
    abertos.add(filePath);
    return OpenResult();
  }
}

FakeOpenFile instalaOpenFileFalso() {
  final fake = FakeOpenFile();
  OpenFilePlatform.platform = fake;
  return fake;
}

class FakeShare extends SharePlatform with MockPlatformInterfaceMixin {
  final params = <ShareParams>[];
  bool falha = false;

  @override
  Future<ShareResult> share(ShareParams p) async {
    if (falha) throw StateError('sem share');
    params.add(p);
    return const ShareResult('ok', ShareResultStatus.success);
  }
}

/// `SharePlus.instance` é `static final`: instale uma única vez por arquivo.
FakeShare instalaShareFalso() {
  final fake = FakeShare();
  SharePlatform.instance = fake;
  return fake;
}

/// Gera um PNG sólido de [largura]x[altura] (precisa de `tester.runAsync`
/// quando chamado dentro de um testWidgets).
Future<Uint8List> criaPng({int largura = 64, int altura = 40, Color cor = Colors.teal}) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  canvas.drawRect(
      Rect.fromLTWH(0, 0, largura.toDouble(), altura.toDouble()), Paint()..color = cor);
  canvas.drawCircle(Offset(largura / 2, altura / 2), altura / 4, Paint()..color = Colors.white);
  final image = await recorder.endRecording().toImage(largura, altura);
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();
  return bytes!.buffer.asUint8List();
}

/// Diretório temporário removido no fim do teste.
Directory criaTemp(String prefixo) {
  final dir = Directory.systemTemp.createTempSync(prefixo);
  addTearDown(() => dir.deleteSync(recursive: true));
  return dir;
}

/// PNG 1x1 válido para testes que não precisam renderizar a imagem.
final Uint8List png1x1 = Uint8List.fromList(const [
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49,
  0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x08, 0x06,
  0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00, 0x0D, 0x49, 0x44,
  0x41, 0x54, 0x78, 0xDA, 0x63, 0xFC, 0xCF, 0xC0, 0xF0, 0x1F, 0x00, 0x05, 0x05,
  0x02, 0x00, 0x5F, 0xC8, 0xF1, 0xD2, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E,
  0x44, 0xAE, 0x42, 0x60, 0x82,
]);
