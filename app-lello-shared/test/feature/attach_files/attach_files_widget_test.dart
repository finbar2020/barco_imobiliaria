import 'dart:io';

import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:shared_features/feature/access_settings_permission_denied/entity/access_settings_permissions_denied_item.dart';
import 'package:shared_features/feature/access_settings_permission_denied/presentation/page/access_settings_permission_denied_page.dart';
import 'package:shared_features/feature/attach_files/bloc/attach_files_bloc.dart';
import 'package:shared_features/feature/attach_files/widgets/attach_files_error_toasts.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;
import 'package:toastification/toastification.dart';

import '../../helpers/fake_permission_handler.dart';
import '../../helpers/pump_app.dart';
import '../../core/core_test_support.dart' as core;
import 'attach_files_support.dart';

/// Página que abre o bottom sheet e guarda o resultado.
class _Host extends StatefulWidget {
  const _Host({
    required this.container,
    this.showAttachment = true,
    this.showCamera = true,
    this.showGallery = true,
    this.colaborador = false,
  });

  final SharedApplicationContainer container;
  final bool showAttachment;
  final bool showCamera;
  final bool showGallery;
  final bool colaborador;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  final results = <List<File>>[];

  @override
  Widget build(BuildContext context) {
    final body = Builder(
      builder: (context) => Center(
        child: TextButton(
          key: const Key('abrir'),
          onPressed: () async {
            results.add(await AttachFilesBottomSheet.show(
              context: context,
              appContainer: widget.container,
              showAttachment: widget.showAttachment,
              showCamera: widget.showCamera,
              showGallery: widget.showGallery,
              maxWidth: 300,
              maxHeight: 200,
              maxFileSizePermitted: 1024,
              allowMultiple: true,
            ));
          },
          child: const Text('abrir'),
        ),
      ),
    );
    return Scaffold(
      body: widget.colaborador
          ? Theme(data: LelloTheme.carimbeira, child: body)
          : body,
    );
  }
}

/// O toastification insere o toast com atraso e anima a entrada: vários
/// frames curtos até ele ficar visível.
Future<void> settleToast(WidgetTester tester) async {
  for (var i = 0; i < 8; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

/// O gerenciador do toastification é global e só solta o OverlayEntry após
/// um `Future.delayed`: descarta os toasts DENTRO da zona do teste para o
/// próximo teste começar limpo.
Future<void> dismissToasts(WidgetTester tester) async {
  toastification.dismissAll(delayForAnimation: false);
  await tester.pump(const Duration(seconds: 1));
  await tester.pumpAndSettle();
}

void main() {
  late AttachFilesHarness h;

  setUp(() async {
    h = await installAttachFilesHarness();
  });


  Future<(_HostState, RecordingNavigatorObserver)> open(
    WidgetTester tester, {
    bool showAttachment = true,
    bool showCamera = true,
    bool showGallery = true,
    bool colaborador = false,
  }) async {
    h.createStore();
    final observer = RecordingNavigatorObserver();
    await pumpPage(
      tester,
      _Host(
        container: h.container,
        showAttachment: showAttachment,
        showCamera: showCamera,
        showGallery: showGallery,
        colaborador: colaborador,
      ),
      observer: observer,
      providers: core.withFakeAssets,
    );
    await tester.tap(find.byKey(const Key('abrir')));
    await tester.pumpAndSettle();
    return (tester.state<_HostState>(find.byType(_Host)), observer);
  }

  testWidgets('bottom sheet mostra os três botões', (tester) async {
    await open(tester);
    expect(find.byType(AttachFilesWidget), findsOneWidget);
    expect(find.text('attachment'), findsOneWidget);
    expect(find.text('camera'), findsOneWidget);
    expect(find.text('gallery'), findsOneWidget);
    expect(find.byType(SvgPicture), findsNWidgets(3));
    final widget = tester.widget<AttachFilesWidget>(find.byType(AttachFilesWidget));
    expect(widget.maxWidth, 300);
    expect(widget.maxHeight, 200);
    expect(widget.maxFileSizePermitted, 1024);
    expect(widget.allowMultiple, isTrue);
    expect(widget.aspectRatioPresets, [CropAspectRatioPreset.square]);
    expect(widget.cropStyle, CropStyle.rectangle);
  });

  testWidgets('golden do widget solto com os valores padrão', (tester) async {
    h.createStore();
    await pumpApp(
        tester, core.withFakeAssets(AttachFilesWidget(appContainer: h.container)));
    final widget = tester.widget<AttachFilesWidget>(find.byType(AttachFilesWidget));
    expect(widget.showAttachment, isTrue);
    expect(widget.showCamera, isTrue);
    expect(widget.showGallery, isTrue);
    expect(widget.allowMultiple, isFalse);
    expect(widget.maxFileSizePermitted, isNull);
    await expectLater(
        findGoldenSurface(), matchesGoldenFile('goldens/attach_files_widget.png'));
  });

  testWidgets('flags escondem os botões', (tester) async {
    await open(tester,
        showAttachment: false, showCamera: false, showGallery: true);
    expect(find.text('attachment'), findsNothing);
    expect(find.text('camera'), findsNothing);
    expect(find.text('gallery'), findsOneWidget);
  });

  testWidgets('Anexo abre o file_picker e devolve os arquivos escolhidos',
      (tester) async {
    final png = h.file('doc.png');
    h.filePicker.files = [platformFile(png.path)];
    final (host, _) = await open(tester);
    await tester.tap(find.text('attachment'));
    await tester.pumpAndSettle();
    expect(h.filePicker.calls.single['allowMultiple'], true);
    expect(find.byType(AttachFilesWidget), findsNothing);
    expect(host.results.single.map((f) => f.path), [png.path]);
  });

  testWidgets('cancelar o file_picker fecha com lista vazia', (tester) async {
    final (host, _) = await open(tester);
    await tester.tap(find.text('attachment'));
    await tester.pumpAndSettle();
    expect(host.results.single, isEmpty);
  });

  testWidgets('fechar o bottom sheet sem escolher devolve lista vazia',
      (tester) async {
    final (host, _) = await open(tester);
    await tester.tapAt(const Offset(200, 50)); // fora do sheet
    await tester.pumpAndSettle();
    expect(find.byType(AttachFilesWidget), findsNothing);
    expect(host.results.single, isEmpty);
  });

  testWidgets('Galeria abre o image_picker na galeria', (tester) async {
    final (host, _) = await open(tester);
    await tester.tap(find.text('gallery'));
    await tester.pumpAndSettle();
    expect(h.picker.sources, [ImageSource.gallery]);
    expect(host.results.single, isEmpty);
  });

  testWidgets('Câmera com permissão abre o image_picker na câmera',
      (tester) async {
    final (host, observer) = await open(tester);
    await tester.tap(find.text('camera'));
    await tester.pumpAndSettle();
    expect(h.picker.sources, [ImageSource.camera]);
    expect(observer.pushedNames,
        isNot(contains(SharedApplicationRoute.accessSettingsPermissionDenied)));
    expect(host.results.single, isEmpty);
  });

  testWidgets('Câmera sem permissão navega para a tela de permissão negada',
      (tester) async {
    setFakePermissionHandler(
        core.StubbornPermissionHandler(status: PermissionStatus.denied));
    final (_, observer) = await open(tester);
    await tester.tap(find.text('camera'));
    await tester.pumpAndSettle();
    expect(h.picker.sources, isEmpty);
    expect(findRoute(SharedApplicationRoute.accessSettingsPermissionDenied),
        findsOneWidget);
    final args = observer.pushed.last.settings.arguments
        as AcessSettingsPermissionDeniedPageArgs;
    expect(args.acessSettingsPermissionsDeniedItem.item,
        AcessSettingsPermissionsDeniedItemEnum.cam);
    expect(args.acessSettingsPermissionsDeniedItem.isColaboradorApp, isFalse);
  });

  testWidgets('no app colaborador (tema carimbeira) os argumentos marcam isColaboradorApp',
      (tester) async {
    setFakePermissionHandler(
        core.StubbornPermissionHandler(status: PermissionStatus.denied));
    final (_, observer) = await open(tester, colaborador: true);
    await tester.tap(find.text('camera'));
    await tester.pumpAndSettle();
    final args = observer.pushed.last.settings.arguments
        as AcessSettingsPermissionDeniedPageArgs;
    expect(args.acessSettingsPermissionsDeniedItem.isColaboradorApp, isTrue);
  });

  group('toasts de erro', () {
    Future<void> emit(WidgetTester tester, AttachFilesEmptyEvent event) async {
      h.bloc.add(event);
      await settleToast(tester);
    }

    testWidgets('arquivo protegido', (tester) async {
      await open(tester);
      await emit(tester, AttachFilesEmptyEvent(
          errorType: FileError.protected, fileName: 'seguro', fileExtension: '.pdf'));
      expect(find.text('seguro'), findsOneWidget);
      expect(find.text('.pdf'), findsOneWidget);
      expect(find.text('payments_rejected_file'), findsOneWidget);
      expect(find.text('payments_protected_file_error'), findsOneWidget);
      expect(find.byType(AttachFilesWidget), findsOneWidget); // não fecha
      await dismissToasts(tester);
    });

    testWidgets('arquivo grande demais', (tester) async {
      await open(tester);
      await emit(tester, AttachFilesEmptyEvent(
          errorType: FileError.size, fileName: 'grande', fileExtension: '.pdf'));
      expect(find.text('grande'), findsOneWidget);
      expect(find.text('payments_files_size_error'), findsOneWidget);
      expect(find.text('payments_max_file_size'), findsOneWidget);
      await dismissToasts(tester);
    });

    testWidgets('formato não suportado (nome e extensão nulos viram vazio)',
        (tester) async {
      await open(tester);
      await emit(tester, AttachFilesEmptyEvent(errorType: FileError.unsupportedFormat));
      expect(find.text('payments_file_type_error'), findsOneWidget);
      expect(find.text('payments_rejected_file'), findsOneWidget);
      await dismissToasts(tester);
    });

    testWidgets('sem tipo de erro ou FileError.none não mostra toast',
        (tester) async {
      await open(tester);
      await emit(tester, AttachFilesEmptyEvent());
      await emit(tester, AttachFilesEmptyEvent(errorType: FileError.none));
      expect(find.text('payments_rejected_file'), findsNothing);
      expect(find.byType(AttachFilesWidget), findsOneWidget);
    });
  });

  group('AttachFilesErrorToasts', () {
    testWidgets('showGenericFileError e showGenericError', (tester) async {
      await pumpPage(tester, const Scaffold(body: SizedBox(key: Key('ctx'))));
      final context = tester.element(find.byKey(const Key('ctx')));
      AttachFilesErrorToasts.showGenericFileError(
          context: context, errorMessage: 'falhou');
      await settleToast(tester);
      expect(find.text('Erro ao anexar arquivo'), findsOneWidget);
      expect(find.text('falhou'), findsOneWidget);

      AttachFilesErrorToasts.showGenericError(
        context: context,
        errorTitle: 'Título',
        errorMessage: 'Mensagem',
        autoCloseDuration: const Duration(seconds: 1),
      );
      await settleToast(tester);
      expect(find.text('Título'), findsOneWidget);
      expect(find.text('Mensagem'), findsOneWidget);
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      expect(find.text('Título'), findsNothing);
      expect(find.text('Erro ao anexar arquivo'), findsOneWidget);
      await dismissToasts(tester);
    });

    testWidgets('showEncryptedFileError, showFileTooLargeError e showUnsupportedFormatError',
        (tester) async {
      await pumpPage(tester, const Scaffold(body: SizedBox(key: Key('ctx'))));
      final context = tester.element(find.byKey(const Key('ctx')));
      AttachFilesErrorToasts.showEncryptedFileError(
          context: context, fileName: 'a', fileExtension: '.pdf');
      AttachFilesErrorToasts.showFileTooLargeError(
          context: context, fileName: 'b', fileExtension: '.pdf', maxSizeMB: 10);
      AttachFilesErrorToasts.showUnsupportedFormatError(
          context: context, fileName: 'c', fileExtension: '.txt');
      await settleToast(tester);
      expect(find.text('a'), findsOneWidget);
      expect(find.text('b'), findsOneWidget);
      expect(find.text('c'), findsOneWidget);
      expect(find.text('payments_rejected_file'), findsNWidgets(3));
      await dismissToasts(tester);
    });
  });
}
