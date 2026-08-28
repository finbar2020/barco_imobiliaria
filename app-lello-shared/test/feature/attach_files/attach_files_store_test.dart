import 'dart:io';

import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:shared_features/feature/attach_files/bloc/attach_files_bloc.dart';

import '../../helpers/fake_permission_handler.dart';
import '../../helpers/pump_app.dart';
import '../../core/core_test_support.dart' as core;
import 'attach_files_support.dart';

void main() {
  late AttachFilesHarness h;

  setUp(() async {
    h = await installAttachFilesHarness();
  });

  /// Monta um widget só para obter um `BuildContext` real e executa [body]
  /// com IO real (`runAsync`), aguardando o bloc processar os eventos.
  Future<void> run(WidgetTester tester,
      Future<void> Function(BuildContext context) body) async {
    await pumpApp(tester, const SizedBox(key: Key('ctx')));
    final context = tester.element(find.byKey(const Key('ctx')));
    // O store faz IO real: bloc e chamada dentro do `runAsync`.
    await tester.runAsync(() async {
      h.createStore();
      await body(context);
      await Future<void>.delayed(const Duration(milliseconds: 20));
    });
  }

  Future<void> chooseImage(BuildContext context,
          {ImageSource source = ImageSource.gallery,
          int? maxFileSizePermitted,
          int? maxWidth,
          int? maxHeight}) =>
      h.store.chooseImage(
        context: context,
        imageSource: source,
        maxHeight: maxHeight,
        maxWidth: maxWidth,
        maxFileSizePermitted: maxFileSizePermitted,
        aspectRatioPresets: const [CropAspectRatioPreset.square],
        cropStyle: CropStyle.rectangle,
      );

  group('chooseImage', () {
    testWidgets('câmera sem permissão não abre o picker nem emite estado',
        (tester) async {
      setFakePermissionHandler(
          core.StubbornPermissionHandler(status: PermissionStatus.denied));
      await run(tester, (c) => chooseImage(c, source: ImageSource.camera));
      expect(h.picker.sources, isEmpty);
      expect(h.states, isEmpty);
    });

    testWidgets('câmera com permissão concedida no pedido abre o picker',
        (tester) async {
      h.permissions.status = PermissionStatus.denied;
      await run(tester, (c) => chooseImage(c, source: ImageSource.camera));
      expect(h.permissions.requestCount, 1);
      expect(h.picker.sources, [ImageSource.camera]);
      expect(h.states.single, isA<AttachFilesSuccessState>());
      expect((h.states.single as AttachFilesSuccessState).files, isEmpty);
    });

    testWidgets('galeria cancelada emite sucesso sem arquivos', (tester) async {
      await run(tester, (c) => chooseImage(c));
      expect(h.permissions.requestCount, 0);
      expect(h.picker.sources, [ImageSource.gallery]);
      expect(h.cropper.cropped, isEmpty);
      expect((h.states.single as AttachFilesSuccessState).files, isEmpty);
    });

    testWidgets('recorte cancelado emite sucesso sem arquivos', (tester) async {
      h.picker.path = h.file('foto.jpg').path;
      await run(tester, (c) => chooseImage(c, maxWidth: 300, maxHeight: 200));
      expect(h.cropper.cropped, [h.picker.path]);
      expect(h.cropper.lastMaxWidth, 300);
      expect(h.cropper.lastMaxHeight, 200);
      expect((h.states.single as AttachFilesSuccessState).files, isEmpty);
    });

    testWidgets('imagem recortada é copiada para os documentos e emitida',
        (tester) async {
      h.picker.path = h.file('foto.jpg').path;
      h.cropper.path = h.file('recorte.jpg', bytes: 5).path;
      await run(tester, (c) => chooseImage(c));
      final files = (h.states.single as AttachFilesSuccessState).files;
      expect(files, hasLength(1));
      expect(files.single.path, startsWith('${h.tempDir.path}/image_'));
      expect(files.single.path, endsWith('.jpg'));
      expect(files.single.lengthSync(), 5);
    });

    testWidgets('imagem maior que o permitido emite erro de tamanho',
        (tester) async {
      h.picker.path = h.file('foto.png').path;
      h.cropper.path = h.file('recorte.png', bytes: 50).path;
      await run(tester, (c) => chooseImage(c, maxFileSizePermitted: 10));
      final state = h.states.single as AttachFilesEmptyState;
      expect(state.errorType, FileError.size);
      expect(state.fileName, startsWith('image_'));
      expect(state.fileExtension, '.png');
    });

    testWidgets('formato não suportado emite erro de formato', (tester) async {
      h.picker.path = h.file('foto.bmp').path;
      h.cropper.path = h.file('recorte.bmp').path;
      await run(tester, (c) => chooseImage(c));
      final state = h.states.single as AttachFilesEmptyState;
      expect(state.errorType, FileError.unsupportedFormat);
      expect(state.fileExtension, '.bmp');
    });

    testWidgets('sem limite explícito usa o padrão de 10MB do remote config',
        (tester) async {
      h.picker.path = h.file('foto.jpg').path;
      h.cropper.path = h.file('recorte.jpg', bytes: 2048).path;
      await run(tester, (c) => chooseImage(c));
      expect(h.states.single, isA<AttachFilesSuccessState>());
    });
  });

  group('chooseFile', () {
    testWidgets('pede só PDF ao file_picker e cancelar emite sucesso vazio',
        (tester) async {
      await run(tester, (_) => h.store.chooseFile(allowMultiple: true));
      expect(h.filePicker.calls.single, {
        'type': FileType.custom,
        'allowedExtensions': ['pdf'],
        'allowMultiple': true,
      });
      expect((h.states.single as AttachFilesSuccessState).files, isEmpty);
    });

    testWidgets('ignora entradas sem caminho e emite os arquivos válidos',
        (tester) async {
      final a = h.file('a.png');
      final b = h.file('b.jpeg');
      h.filePicker.files = [
        platformFile(a.path),
        PlatformFile(name: 'sem-caminho', size: 0),
        platformFile(b.path),
      ];
      await run(tester, (_) => h.store.chooseFile());
      expect(h.filePicker.calls.single['allowMultiple'], false);
      final files = (h.states.single as AttachFilesSuccessState).files;
      expect(files.map((f) => f.path), [a.path, b.path]);
    });

    testWidgets('arquivo grande demais emite erro de tamanho e nada de sucesso',
        (tester) async {
      h.filePicker.files = [
        platformFile(h.file('ok.png', bytes: 5).path),
        platformFile(h.file('grande.pdf', bytes: 100).path),
      ];
      await run(tester, (_) => h.store.chooseFile(maxFileSizePermitted: 50));
      expect(h.states, hasLength(1));
      final state = h.states.single as AttachFilesEmptyState;
      expect(state.errorType, FileError.size);
      expect(state.fileName, 'grande');
      expect(state.fileExtension, '.pdf');
    });

    testWidgets('formato não suportado emite erro de formato', (tester) async {
      h.filePicker.files = [platformFile(h.file('doc.txt').path)];
      await run(tester, (_) => h.store.chooseFile());
      final state = h.states.single as AttachFilesEmptyState;
      expect(state.errorType, FileError.unsupportedFormat);
      expect(state.fileName, 'doc');
      expect(state.fileExtension, '.txt');
    });

    testWidgets('vários arquivos inválidos geram um evento por arquivo',
        (tester) async {
      h.filePicker.files = [
        platformFile(h.file('a.txt').path),
        platformFile(h.file('b.gif').path),
      ];
      await run(tester, (_) => h.store.chooseFile());
      expect(h.states, hasLength(2));
      expect(h.states.map((s) => (s as AttachFilesEmptyState).fileName),
          ['a', 'b']);
    });
  });

  test('AttachFilesStore guarda o bloc', () {
    h.createStore();
    expect(h.store.bloc, same(h.bloc));
    expect(File('x').path, 'x');
  });
}
