// Apoio dos testes de `feature/attach_files`: plugins falsos (image_picker,
// image_cropper, file_picker, path_provider) e um harness com o store REAL
// ligado ao bloc real.
import 'dart:io';

import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:file_picker/file_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_cropper_platform_interface/image_cropper_platform_interface.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:shared_features/feature/attach_files/bloc/attach_files_bloc.dart';
import 'package:shared_features/feature/attach_files/store/attach_files_store.dart';

import '../../helpers/fake_permission_handler.dart';
import '../../helpers/firebase_mocks.dart';
import '../../helpers/test_container.dart';

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
  int? lastMaxWidth;
  int? lastMaxHeight;

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
    lastMaxWidth = maxWidth;
    lastMaxHeight = maxHeight;
    final p = path;
    return p == null ? null : CroppedFile(p);
  }
}

/// file_picker falso: devolve [files] (ou `null` = cancelou).
class FakeFilePicker extends FilePicker with MockPlatformInterfaceMixin {
  List<PlatformFile>? files;
  final calls = <Map<String, Object?>>[];

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
    calls.add({
      'type': type,
      'allowedExtensions': allowedExtensions,
      'allowMultiple': allowMultiple,
    });
    final f = files;
    return f == null ? null : FilePickerResult(f);
  }
}

/// path_provider falso apontando para um diretório temporário.
class FakePathProvider extends PathProviderPlatform {
  FakePathProvider(this.dir);
  final Directory dir;

  @override
  Future<String?> getApplicationDocumentsPath() async => dir.path;

  @override
  Future<String?> getTemporaryPath() async => dir.path;
}

PlatformFile platformFile(String path) =>
    PlatformFile(path: path, name: path.split('/').last, size: 1);

class AttachFilesHarness {
  AttachFilesHarness._();

  final picker = FakeImagePickerPlatform();
  final cropper = FakeImageCropperPlatform();
  final filePicker = FakeFilePicker();
  final permissions = FakePermissionHandler(status: PermissionStatus.granted);
  final container = TestSharedContainer();
  late Directory tempDir;
  late AttachFilesBloc bloc;
  late AttachFilesStore store;

  /// Estados emitidos pelo bloc desde a instalação.
  final states = <AttachFilesState>[];

  /// Cria um arquivo com [bytes] bytes dentro do diretório temporário.
  File file(String name, {int bytes = 10}) {
    final f = File('${tempDir.path}/$name');
    f.writeAsBytesSync(List<int>.filled(bytes, 65));
    return f;
  }
}

/// Instala Firebase falso (remote config lido pelo `CheckFile`), plugins
/// falsos e o container com o store REAL. Chame no `setUp`.
Future<AttachFilesHarness> installAttachFilesHarness() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final h = AttachFilesHarness._();
  await setUpFakeFirebase();
  setFakePermissionHandler(h.permissions);
  ImagePickerPlatform.instance = h.picker;
  ImageCropperPlatform.instance = h.cropper;
  FilePicker.platform = h.filePicker;
  h.tempDir = Directory.systemTemp.createTempSync('shared_attach_files');
  PathProviderPlatform.instance = FakePathProvider(h.tempDir);
  addTearDown(() {
    if (h.tempDir.existsSync()) h.tempDir.deleteSync(recursive: true);
  });
  return h;
}

extension AttachFilesHarnessStore on AttachFilesHarness {
  /// Cria o bloc e o store REAIS e registra o store no container. Chame
  /// DENTRO do `testWidgets` (bloc criado fora da zona fake não entrega os
  /// estados ao `BlocConsumer`).
  void createStore() {
    bloc = AttachFilesBloc();
    bloc.stream.listen(states.add);
    store = AttachFilesStore(bloc: bloc);
    container.register<AttachFilesStore>(store);
    addTearDown(() => bloc.close());
  }
}
