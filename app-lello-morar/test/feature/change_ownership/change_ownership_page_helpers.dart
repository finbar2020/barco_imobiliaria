/// Helpers locais para os widget tests da alteração de titularidade
/// (`lib/feature/change_ownership/presentation/**`): rotas/JSON da API,
/// anexos temporários, fakes dos plugins de galeria/câmera/recorte/arquivo
/// e um `Uploader` falso para o envio ao S3.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart' show addTearDown;
import 'package:image_cropper_platform_interface/image_cropper_platform_interface.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:morar/core/uploader/uploader.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:shared_features/shared_features.dart' show SharedApplicationRoute;

import '../../helpers/fixtures.dart';

/// Condomínio da sessão de teste (`testCondominium().id`).
const condoId = 'c1';

/// Caminhos da `ChangeOwnershipApi`.
const canChangePath = '/condominiums/$condoId/easyfix/can-change';
const awsPayloadPath = '/condominiums/$condoId/easyfix/aws-payload';
const postChangePath = '/condominiums/$condoId/easyfix/change-ownership';

Map<String, dynamic> canChangeJson({bool canChange = true, String? message}) =>
    {'can_change': canChange, 'message': message};

Map<String, dynamic> awsPayloadJson() => {
      'file_name': 'anexo-s3.png',
      'bucket': 'bucket',
      'http_method': 'PUT',
      'url': 'https://s3.local/anexo-s3.png',
    };

/// Cria um PNG 1x1 real (o `FileImage` da tela precisa decodificar).
File tempImage({String name = 'foto.png'}) {
  final dir = Directory.systemTemp.createTempSync('morar_ownership');
  final file = File('${dir.path}/$name');
  file.writeAsBytesSync(base64Decode(testPictureBase64));
  return file;
}

/// Cria um arquivo qualquer com [size] bytes. O nome padrão evita o sufixo
/// `.pdf` para o `CheckFile.isFileEncrypted` não abrir o pdfium nativo.
File tempFile({String name = 'documento.PDF', int size = 3}) {
  final dir = Directory.systemTemp.createTempSync('morar_ownership');
  final file = File('${dir.path}/$name');
  file.writeAsBytesSync(List<int>.filled(size, 0x41));
  return file;
}

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
      PlatformFile(
          path: f.path, name: f.uri.pathSegments.last, size: f.lengthSync()),
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
  // Sem plugin nativo o `FilePicker.platform` ainda não foi inicializado.
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

/// `Uploader` falso: o real faz um PUT com o dio na URL do S3. Registre com
/// `harness.override<Uploader>` ANTES de resolver o `OwnershipController`.
class FakeUploader implements Uploader {
  FakeUploader({this.fail = false});
  bool fail;
  final uploaded = <String>[];

  @override
  Future<String> upload(String path, File file,
          {required Function(String) onComplete,
          required Function(Exception) onError}) =>
      uploadS3(path, file, onComplete: onComplete, onError: onError);

  @override
  Future<String> uploadWithProgress(
          String path, File file, StreamController<double> progress,
          {required Function(String) onComplete,
          required Function(Exception) onError}) =>
      uploadS3(path, file, onComplete: onComplete, onError: onError);

  @override
  Future<String> uploadS3(String url, File file,
      {required Function(String) onComplete,
      required Function(Exception) onError}) async {
    uploaded.add(url);
    if (fail) {
      onError(Exception('upload falhou'));
    } else {
      onComplete(url);
    }
    return url;
  }

  @override
  Future<String> uploadS3WithProgress(
          String url, File file, StreamController<double>? progress,
          {required Function(String) onComplete,
          required Function(Exception) onError}) =>
      uploadS3(url, file, onComplete: onComplete, onError: onError);
}

/// Empilha uma rota `/home` e depois [route] (com [arguments]) sobre a
/// página raiz do `pumpPage`, para que `Navigator.pop`/`popUntil(home)`
/// tenham para onde voltar.
class RouteLauncher extends StatefulWidget {
  const RouteLauncher({required this.route, this.arguments, super.key});

  final String route;
  final Object? arguments;

  @override
  State<RouteLauncher> createState() => _RouteLauncherState();
}

class _RouteLauncherState extends State<RouteLauncher> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navigator = Navigator.of(context);
      navigator.pushNamed(SharedApplicationRoute.home);
      navigator.pushNamed(widget.route, arguments: widget.arguments);
    });
  }

  @override
  Widget build(BuildContext context) =>
      const Scaffold(key: Key('launcher'), body: SizedBox());
}
