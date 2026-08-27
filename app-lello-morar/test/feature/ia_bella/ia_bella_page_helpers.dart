/// Helpers locais dos widget tests da feature `ia_bella`: JSON das respostas
/// da API, tela base para empilhar a `IABellaPage` (para poder testar o
/// "voltar"), fakes de path_provider/file_picker (PDFs) e utilitários para
/// achar SVGs e acionar links do markdown.
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:essentials/essentials.dart' show Fake, Try;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/feature/ia_bella/domain/entity/ia_bella_data_entity.dart';
import 'package:morar/feature/ia_bella/domain/use_case/send_message/ia_bella_send_message_use_case.dart';
import 'package:morar/feature/ia_bella/presentation/page/ia_bella_page.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';

/// `condoId` da sessão de teste (`testCondominium().id`).
const bellaCondoId = 'c1';
const startSessionPath = '/condominiums/$bellaCondoId/bella/start_session';
const newQuestionPath = '/condominiums/$bellaCondoId/bella/new_question';
const evaluatePath = '/condominiums/$bellaCondoId/bella/evaluate';
const finalEvaluationPath =
    '/condominiums/$bellaCondoId/bella/final_evaluation';
const downloadPdfPath = '/condominiums/$bellaCondoId/bella/download_pdf';

Map<String, dynamic> sessionJson({
  String? uuid = 'sess-1',
  String welcome = 'Olá! Eu sou a Bella',
}) =>
    {
      'uuid_session': uuid,
      'welcome_message': welcome,
      'response_id': 'r0',
      'documents': <Map<String, dynamic>>[],
    };

Map<String, dynamic> docJson(
  String id, {
  String description = 'Ata da assembleia.pdf',
  String serviceType = 'ATA',
}) =>
    {'id': id, 'description': description, 'service_type': serviceType};

Map<String, dynamic> answerJson({
  String response = 'Aqui está a resposta',
  String? responseId = 'r1',
  List<Map<String, dynamic>> docs = const [],
}) =>
    {
      'response': response,
      'response_id': responseId,
      'uuid_session': 'sess-1',
      'documents': docs,
    };

Map<String, dynamic> rateJson(String responseId) =>
    {'response_id': responseId, 'evaluation_type': 'POSITIVE'};

/// Rota em que a `IABellaPage` é empilhada sobre a [BellaLauncher].
const bellaRoute = '/bella-sob-teste';
const openBellaKey = Key('abrir-bella');
const bellaBaseKey = Key('tela-base');

/// Tela base: a Bella precisa de uma rota abaixo dela para que os
/// `Navigator.pop` da página tenham para onde voltar.
class BellaLauncher extends StatelessWidget {
  const BellaLauncher({super.key, this.arguments});
  final Object? arguments;

  @override
  Widget build(BuildContext context) => Scaffold(
        key: bellaBaseKey,
        body: Center(
          child: ElevatedButton(
            key: openBellaKey,
            onPressed: () =>
                Navigator.pushNamed(context, bellaRoute, arguments: arguments),
            child: const Text('abrir bella'),
          ),
        ),
      );
}

/// Monta a tela base e empurra a `IABellaPage` (com [arguments] em
/// `ModalRoute.settings.arguments`).
Future<void> pumpBella(
  WidgetTester tester, {
  Object? arguments,
  RecordingNavigatorObserver? observer,
  Map<String, WidgetBuilder> routes = const {},
  bool settle = true,
}) async {
  await pumpPage(
    tester,
    BellaLauncher(arguments: arguments),
    observer: observer,
    routes: {bellaRoute: (_) => IABellaPage(), ...routes},
  );
  await tester.tap(find.byKey(openBellaKey));
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
  }
}

/// Finder de um `SvgPicture.asset` pelo nome do asset.
Finder findSvg(String asset) => find.byWidgetPredicate(
      (w) =>
          w is SvgPicture &&
          w.bytesLoader is SvgAssetLoader &&
          (w.bytesLoader as SvgAssetLoader).assetName == asset,
      description: 'SvgPicture($asset)',
    );

/// Botão de enviar mensagem (GestureDetector em volta do ícone de envio).
Finder findSendButton() => find.ancestor(
      of: findSvg('assets/ic_send_message.svg'),
      matching: find.byType(GestureDetector),
    );

/// Digita [text] no campo e toca em enviar.
Future<void> sendText(WidgetTester tester, String text) async {
  await tester.enterText(find.byType(TextField), text);
  await tester.tap(findSendButton());
  await tester.pumpAndSettle();
  // `_sendMessage` agenda um `Future.delayed(100ms)` para rolar a lista.
  await tester.pump(const Duration(milliseconds: 200));
  await tester.pumpAndSettle();
}

/// Aciona o `TapGestureRecognizer` do trecho [text] em algum `RichText`
/// da tela (links do `MarkdownBody`).
void tapLinkSpan(WidgetTester tester, String text) {
  for (final rich in tester.widgetList<RichText>(find.byType(RichText))) {
    TapGestureRecognizer? found;
    rich.text.visitChildren((span) {
      if (span is TextSpan &&
          span.recognizer is TapGestureRecognizer &&
          span.toPlainText() == text) {
        found = span.recognizer as TapGestureRecognizer;
        return false;
      }
      return true;
    });
    if (found != null) {
      found!.onTap!();
      return;
    }
  }
  fail('link "$text" não encontrado');
}

/// path_provider falso apontando para um diretório temporário.
class FakePathProvider extends PathProviderPlatform {
  FakePathProvider(this.dir);
  final Directory dir;

  @override
  Future<String?> getApplicationDocumentsPath() async => dir.path;

  @override
  Future<String?> getTemporaryPath() async => dir.path;

  @override
  Future<String?> getApplicationSupportPath() async => dir.path;
}

Directory installFakePathProvider() {
  final previous = PathProviderPlatform.instance;
  final dir = Directory.systemTemp.createTempSync('morar_bella');
  PathProviderPlatform.instance = FakePathProvider(dir);
  addTearDown(() {
    PathProviderPlatform.instance = previous;
    dir.deleteSync(recursive: true);
  });
  return dir;
}

/// file_picker falso para `saveFile`: devolve [savePath] (`null` = cancelou).
class FakeSaveFilePicker extends FilePicker with MockPlatformInterfaceMixin {
  String? savePath;
  int saves = 0;
  String? lastFileName;
  Uint8List? lastBytes;

  @override
  Future<String?> saveFile({
    String? dialogTitle,
    String? fileName,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Uint8List? bytes,
    bool lockParentWindow = false,
  }) async {
    saves++;
    lastFileName = fileName;
    lastBytes = bytes;
    return savePath;
  }
}

FakeSaveFilePicker installFakeFilePicker() {
  // Sem plugin registrado o getter `FilePicker.platform` lança
  // LateInitializationError; nesse caso não há o que restaurar.
  FilePicker? previous;
  try {
    previous = FilePicker.platform;
  } catch (_) {}
  final fake = FakeSaveFilePicker();
  FilePicker.platform = fake;
  if (previous != null) {
    addTearDown(() => FilePicker.platform = previous!);
  }
  return fake;
}

/// Use case de envio que nunca responde: força o timeout de 60s do
/// `IaBellaController.sendMessage`.
class HangingSendMessageUseCase extends Fake
    implements IaBellaSendMessageUseCase {
  final completer = Completer<Try<IaBellaDataEntity>>();
  int calls = 0;

  @override
  Future<Try<IaBellaDataEntity>> call(IaBellaSendMessageParam params) {
    calls++;
    return completer.future;
  }
}
