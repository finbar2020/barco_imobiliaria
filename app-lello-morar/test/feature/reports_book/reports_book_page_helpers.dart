/// Helpers locais para os widget tests da feature `reports_book`
/// (ocorrências): fixtures de JSON/entidades, anexos temporários e fakes dos
/// plugins de câmera/galeria/arquivo/recorte e do use case de upload.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:essentials/essentials.dart'
    show Failure, Rejection, Success, Try, UnknownFailure;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_cropper_platform_interface/image_cropper_platform_interface.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:morar/feature/reports_book/domain/entity/report.dart';
import 'package:morar/feature/reports_book/domain/entity/report_contents.dart';
import 'package:morar/feature/reports_book/domain/use_case/put_report_attachment.dart';
import 'package:morar/feature/reports_book/presentation/controller/reports_controller.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/page_harness.dart';

/// Unidade da sessão de teste (`testUnity().id`).
const unitId = 'u1';

/// Caminhos da API de ocorrências (`ReportsBookApi`).
const allReportsPath = '/concierge/reportbook/$unitId';
const postReportPath = '/concierge/reportbook';
String reportPath(String reportId) => '/concierge/reportbook/$unitId/$reportId';
String putContentPath(String reportId) => '/concierge/reportbook/$reportId';

Map<String, dynamic> contentJson(
  String id, {
  int typeUser = 0,
  String? content,
  String? attachment,
  String? attachmentType,
  String date = '2026-02-03T14:05:00',
}) =>
    {
      'id': id,
      'num_report': 1,
      'type_user': typeUser,
      'content': content ?? 'Mensagem $id',
      'attachment': attachment,
      'attachment_type': attachmentType,
      'date_content': date,
    };

Map<String, dynamic> reportJson(
  String id, {
  String type = 'COMPLAINT',
  bool closed = false,
  bool newMessage = false,
  bool public = true,
  String? numReport,
  String? notificationParameter,
  List<Map<String, dynamic>>? contents,
  String date = '2026-02-03T14:05:00',
}) =>
    {
      'id_report': id,
      'type_report': type,
      'date_report': date,
      'report_contents': contents ?? [contentJson('c$id')],
      'closed': closed,
      'new_message': newMessage,
      'num_report': numReport ?? '10$id',
      'notification_parameter': notificationParameter ?? 'np$id',
      'public': public,
    };

ReportContents buildContent({
  String id = 'c1',
  int typeUser = 0,
  String? content = 'Mensagem',
  String? attachment,
  String? attachmentType,
  String? attachmentLink,
  File? attachmentFile,
  bool? public,
  DateTime? date,
}) =>
    ReportContents(
      id: id,
      numReport: 1,
      typeUser: typeUser,
      content: content,
      attachment: attachment,
      attachmentType: attachmentType,
      dateContent: date ?? DateTime(2026, 2, 3, 14, 5),
      public: public,
    )
      ..attachmentLink = attachmentLink
      ..attachmentFile = attachmentFile;

Report buildReport({
  String? id = 'r1',
  String? type = 'COMPLAINT',
  bool closed = false,
  bool newMessage = false,
  bool public = true,
  String? numReport = '101',
  List<ReportContents>? contents,
  DateTime? date,
}) =>
    Report(
      idReport: id,
      typeReport: type,
      dateReport: date ?? DateTime(2026, 2, 3, 14, 5),
      reportContents: contents ?? [buildContent()],
      closed: closed,
      newMessage: newMessage,
      numReport: numReport,
      notificationParameter: id == null ? null : 'np$id',
      public: public,
    );

/// Cria um arquivo temporário com [size] bytes para servir de anexo.
File tempAttachment({String name = 'anexo.txt', int size = 1}) {
  final dir = Directory.systemTemp.createTempSync('morar_reports');
  final file = File('${dir.path}/$name');
  file.writeAsBytesSync(List<int>.filled(size, 0x41));
  return file;
}

/// Use case de upload de anexo falso: responde [failure] (ou sucesso) sem
/// tocar no `Uploader` real. Registre com `harness.override` ANTES de
/// resolver o `ReportsController` (o controller é um lazy singleton que
/// captura o use case na construção).
class FakePutReportAttachmentUseCase extends PutReportAttachmentUseCase {
  FakePutReportAttachmentUseCase({this.failure});
  Failure? failure;
  final calls = <PutReportAttachmentParams>[];

  @override
  Future<Try<String>> call(PutReportAttachmentParams params) async {
    calls.add(params);
    final f = failure;
    if (f != null) return Rejection(f);
    return Success('url');
  }
}

/// Controller do container construído com o upload de anexo falso.
class ControllerWithFakeUpload {
  ControllerWithFakeUpload(this.controller, this.upload);
  final ReportsController controller;
  final FakePutReportAttachmentUseCase upload;
}

/// Instala o upload falso e devolve o controller já construído com ele.
Future<ControllerWithFakeUpload> controllerWithFakeUpload(
  PageHarness harness, {
  bool failUpload = false,
}) async {
  final fake = FakePutReportAttachmentUseCase(
    failure: failUpload ? UnknownFailure('upload') : null,
  );
  await harness.override<PutReportAttachmentUseCase>(fake);
  return ControllerWithFakeUpload(harness.resolve<ReportsController>(), fake);
}

/// Finder do `SvgPicture.asset(asset)`.
Finder findSvg(String asset) => find.byWidgetPredicate((w) =>
    w is SvgPicture &&
    w.bytesLoader is SvgAssetLoader &&
    (w.bytesLoader as SvgAssetLoader).assetName == asset);

/// image_picker falso: devolve [path] (ou `null` = usuário cancelou).
class FakeImagePickerPlatform extends ImagePickerPlatform
    with MockPlatformInterfaceMixin {
  String? path;
  final sources = <ImageSource>[];

  @override
  Future<XFile?> getImageFromSource({
    required ImageSource source,
    ImagePickerOptions options = const ImagePickerOptions(),
  }) async {
    sources.add(source);
    final p = path;
    return p == null ? null : XFile(p);
  }
}

/// image_cropper falso: devolve [path] recortado (ou `null` = cancelou).
class FakeImageCropperPlatform extends ImageCropperPlatform
    with MockPlatformInterfaceMixin {
  String? path;
  final cropped = <String>[];

  @override
  Future<CroppedFile?> cropImage({
    required String sourcePath,
    int? maxWidth,
    int? maxHeight,
    CropAspectRatio? aspectRatio,
    ImageCompressFormat compressFormat = ImageCompressFormat.jpg,
    int compressQuality = 90,
    List<PlatformUiSettings>? uiSettings,
  }) async {
    cropped.add(sourcePath);
    final p = path;
    return p == null ? null : CroppedFile(p);
  }
}

/// file_picker falso: devolve [file] (ou `null` = cancelou).
class FakeFilePicker extends FilePicker with MockPlatformInterfaceMixin {
  File? file;
  int picks = 0;

  @override
  Future<FilePickerResult?> pickFiles({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Function(FilePickerStatus)? onFileLoading,
    bool allowCompression = false,
    int compressionQuality = 0,
    bool allowMultiple = false,
    bool withData = false,
    bool withReadStream = false,
    bool lockParentWindow = false,
    bool readSequential = false,
  }) async {
    picks++;
    final f = file;
    if (f == null) return null;
    return FilePickerResult([
      PlatformFile(path: f.path, name: f.uri.pathSegments.last, size: f.lengthSync()),
    ]);
  }
}

class FakePickers {
  FakePickers(this.image, this.cropper, this.file);
  final FakeImagePickerPlatform image;
  final FakeImageCropperPlatform cropper;
  final FakeFilePicker file;
}

/// Troca os plugins de galeria/câmera, recorte e arquivo por fakes até o fim
/// do teste.
FakePickers installFakePickers() {
  final previousImage = ImagePickerPlatform.instance;
  final previousCropper = ImageCropperPlatform.instance;
  // Sem plugin registrado o `FilePicker.platform` é um `late` não
  // inicializado: não há o que restaurar.
  FilePicker? previousFile;
  try {
    previousFile = FilePicker.platform;
  } catch (_) {}
  final pickers = FakePickers(
    FakeImagePickerPlatform(),
    FakeImageCropperPlatform(),
    FakeFilePicker(),
  );
  ImagePickerPlatform.instance = pickers.image;
  ImageCropperPlatform.instance = pickers.cropper;
  FilePicker.platform = pickers.file;
  addTearDown(() {
    ImagePickerPlatform.instance = previousImage;
    ImageCropperPlatform.instance = previousCropper;
    if (previousFile != null) FilePicker.platform = previousFile;
  });
  return pickers;
}

const _inAppReviewChannel = MethodChannel('dev.britannio.in_app_review');

/// `AppReview.call` consulta o in_app_review: responde "indisponível".
/// Devolve a lista de métodos chamados no canal.
List<String> installFakeInAppReview() {
  final calls = <String>[];
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(_inAppReviewChannel, (call) async {
    calls.add(call.method);
    return false;
  });
  addTearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_inAppReviewChannel, null);
  });
  return calls;
}

/// PNG 1x1 válido para anexos de imagem (`FileImage`/`Image.file`).
File tempPng({String name = 'foto.png'}) {
  final dir = Directory.systemTemp.createTempSync('morar_reports_png');
  final file = File('${dir.path}/$name');
  file.writeAsBytesSync(base64Decode(testPictureBase64));
  return file;
}

/// Roda [body] em `runAsync` dentro de uma zona guardada: erros assíncronos
/// não tratados (ex.: `MissingPluginException` do path_provider disparada
/// pelo `DefaultCacheManager` do `ShowPDFWidget`) são coletados e devolvidos
/// em vez de derrubar o teste. Não use `pumpApp`/`pumpPage` dentro (eles já
/// chamam `runAsync`).
Future<List<Object>> runGuarded(
  WidgetTester tester,
  Future<void> Function() body, {
  Duration wait = const Duration(milliseconds: 300),
}) async {
  final errors = <Object>[];
  await tester.runAsync(() async {
    await runZonedGuarded(body, (e, _) => errors.add(e));
    await Future<void>.delayed(wait);
  });
  await tester.pump();
  return errors;
}
