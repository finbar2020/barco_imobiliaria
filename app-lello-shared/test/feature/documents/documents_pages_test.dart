import 'dart:io';

import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:share_plus_platform_interface/share_plus_platform_interface.dart';
import 'package:shared_features/core/widgets/custom_app_bar.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';
import 'package:shared_features/feature/documents/domain/entity/document_file.dart';
import 'package:shared_features/feature/documents/domain/entity/documents_list_result.dart';
import 'package:shared_features/feature/documents/presentation/bloc/documents_state.dart';
import 'package:shared_features/feature/documents/presentation/controllers/documents_controller.dart';
import 'package:shared_features/feature/documents/presentation/page/documents_menu_item.dart';
import 'package:shared_features/feature/documents/presentation/page/documents_menu_strategy.dart';
import 'package:shared_features/feature/documents/presentation/page/documents_page.dart';
import 'package:shared_features/feature/documents/presentation/page/documents_selected_info_page.dart';
import 'package:shared_features/feature/documents/presentation/page/documents_selected_page.dart';
import 'package:shared_features/feature/documents/presentation/widget/documents_card_widget.dart';

import '../../helpers/fake_permission_handler.dart';
import '../../helpers/pump_app.dart';
import 'documents_support.dart';

/// Estratégia que envolve cada card em um `Container` com chave.
class _WrappingStrategy extends DocumentsMenuStrategy {
  @override
  List<DocumentsMenuItem> get items =>
      const [DocumentsMenuItem('documents_minutes'), DocumentsMenuItem('outro')];

  @override
  Widget wrapItem(BuildContext context, DocumentsMenuItem item, Widget card) =>
      Container(key: Key('wrap:${item.documentType}'), child: card);
}

void main() {
  late FakeDocumentsRepository repo;
  late RecordingDocumentsAnalytics analytics;
  late DocumentsHarness harness;
  late DocumentsController controller;
  late RecordingNavigatorObserver observer;
  late Directory dir;
  late FakePermissionHandler permissions;
  late FakeSharePlatform share;

  setUpAll(() {
    dir = Directory.systemTemp.createTempSync('shared_docs_pages');
    // O `ErrorHandlingWidget` lê a versão do app.
    PackageInfo.setMockInitialValues(
      appName: 'Lello',
      packageName: 'br.com.lello.morar',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
    );
    // O `SharePlus.instance` guarda o `SharePlatform.instance` na primeira
    // resolução: um único fake para o arquivo inteiro.
    share = FakeSharePlatform();
    SharePlatform.instance = share;
  });

  tearDownAll(() => dir.deleteSync(recursive: true));

  setUp(() {
    repo = FakeDocumentsRepository();
    analytics = RecordingDocumentsAnalytics();
    harness = DocumentsHarness(repository: repo, analytics: analytics);
    observer = RecordingNavigatorObserver();
    permissions = FakePermissionHandler(status: PermissionStatus.granted);
    setFakePermissionHandler(permissions);
    share.shared.clear();
  });

  /// O bloc precisa nascer dentro da zona do `testWidgets` (handlers criados
  /// fora dela não completam para o `BlocBuilder`).
  void buildController() => controller = harness.buildController();

  /// `DocumentsController.refresh()` aguarda o `cancel()` da assinatura
  /// anterior, cujo future completa em microtask da zona raiz: fora do
  /// fake-async do teste. Um instante de tempo real destrava a revalidação.
  Future<void> letRefreshRun(WidgetTester tester) async {
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)));
    await tester.pumpAndSettle();
  }

  final at = DateTime(2026, 1, 1);

  group('DocumentsCardWidget', () {
    testWidgets('traduz o título no menu e mostra a seta na lista',
        (tester) async {
      var taps = 0;
      await pumpApp(
        tester,
        Column(children: [
          DocumentsCardWidget(title: 'documents_minutes', onTap: () => taps++),
          DocumentsCardWidget(
              title: 'Ata 1', isFirstPage: false, onTap: () => taps++),
        ]),
        locOverrides: const {'documents_minutes': 'Atas'},
        shrinkWrap: false,
      );
      expect(find.text('Atas'), findsOneWidget);
      expect(find.text('Ata 1'), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_arrow_right), findsOneWidget);
      await tester.tap(find.text('Atas'));
      await tester.tap(find.text('Ata 1'));
      expect(taps, 2);
      await expectLater(findGoldenSurface(),
          matchesGoldenFile('goldens/documents_card_widget.png'));
    });
  });

  group('DocumentsPage', () {
    Future<void> pumpMenu(WidgetTester tester,
        {DocumentsMenuStrategy? strategy,
        String? subtitle,
        String? initialType,
        String? notificationContext}) async {
      await tester.pumpWidget(const SizedBox());
      buildController();
      await pumpPage(
        tester,
        DocumentsPage(
          controller: controller,
          strategy: strategy ?? DefaultDocumentsMenuStrategy(),
          subtitle: subtitle,
          initialType: initialType,
          notificationContext: notificationContext,
        ),
        observer: observer,
      );
    }

    testWidgets('lista os itens padrão com subtítulo e abre a lista ao tocar',
        (tester) async {
      repo.results = [
        DocsListResult.fresh(docs: [buildDocument()], lastFetchedAt: at)
      ];
      await pumpMenu(tester, subtitle: 'Condomínio - 101');

      expect(find.text('documents'), findsOneWidget);
      expect(find.text('Condomínio - 101'), findsOneWidget);
      expect(find.byType(DocumentsCardWidget), findsNWidgets(4));
      expect(find.text('documents_minutes'), findsOneWidget);
      expect(find.text('documents_divers'), findsOneWidget);
      await expectLater(find.byType(DocumentsPage),
          matchesGoldenFile('goldens/documents_page.png'));

      await tester.tap(find.text('documents_notices'));
      await tester.pumpAndSettle();

      expect(find.byType(DocumentsSelectedPage), findsOneWidget);
      expect(repo.watchCalls.single, ['C1', '3', 'U1', false]);
      expect(find.text('Ata da assembleia'), findsOneWidget);
    });

    testWidgets('estratégia customizada envolve os cards', (tester) async {
      await pumpMenu(tester, strategy: _WrappingStrategy());
      expect(find.byKey(const Key('wrap:documents_minutes')), findsOneWidget);
      expect(find.byKey(const Key('wrap:outro')), findsOneWidget);
      expect(find.byType(DocumentsCardWidget), findsNWidgets(2));
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('deep-link abre o tipo inicial com o contexto da notificação',
        (tester) async {
      final pdf = writePdf(dir, 'deep.pdf');
      repo.download = () => Success(pdf);
      repo.results = [
        DocsListResult.fresh(
            docs: [buildDocument(id: 'd1', notificationParameter: 'np1')],
            lastFetchedAt: at)
      ];
      await pumpMenu(tester,
          initialType: 'documents_minutes', notificationContext: 'np1');

      expect(find.byType(DocumentsSelectedInfoPage), findsOneWidget);
      expect(repo.watchCalls.single, ['C1', '2', 'U1', false]);
      expect(repo.downloadCalls.single, ['d1', '2']);
      expect(find.text('Ata da assembleia'), findsOneWidget);

      // Tipo vazio não abre nada.
      await pumpMenu(tester, initialType: '');
      expect(find.byType(DocumentsSelectedPage), findsNothing);
    });
  });

  group('DocumentsSelectedPage', () {
    Future<void> pumpList(WidgetTester tester,
        {String title = minutesType,
        String? notificationContext,
        bool settle = true}) async {
      await tester.pumpWidget(const SizedBox());
      buildController();
      await pumpPage(
        tester,
        DocumentsSelectedPage(
          controller: controller,
          title: title,
          notificationContext: notificationContext,
        ),
        observer: observer,
        settle: settle,
      );
    }

    testWidgets('carrega e lista os documentos', (tester) async {
      repo.results = [DocsListResult.coldLoading()];
      await pumpList(tester, settle: false);
      await tester.pump();
      await tester.pump();
      expect(find.byType(LoadingWidget), findsOneWidget);
      expect(find.text(minutesType), findsOneWidget);

      repo.results = [
        DocsListResult.fresh(
            docs: [buildDocument(id: 'd1'), buildDocument(id: 'd2', name: 'Ata 2')],
            lastFetchedAt: at),
      ];
      await pumpList(tester);

      expect(find.byType(CustomAppBar), findsOneWidget);
      expect(find.text(minutesType), findsOneWidget);
      expect(find.byType(DocumentsCardWidget), findsNWidgets(2));
      expect(find.text('Ata da assembleia'), findsOneWidget);
      expect(find.text('Ata 2'), findsOneWidget);
      expect(find.byIcon(Icons.cloud_off), findsNothing);
      expect(analytics.accesses, [minutesType]);
      await expectLater(find.byType(DocumentsSelectedPage),
          matchesGoldenFile('goldens/documents_selected_page.png'));
    });

    testWidgets('tocar em um documento baixa e abre o detalhe', (tester) async {
      final pdf = writePdf(dir, 'lista.pdf');
      repo.download = () => Success(pdf);
      repo.results = [
        DocsListResult.fresh(docs: [buildDocument()], lastFetchedAt: at)
      ];
      await pumpList(tester);

      await tester.tap(find.byType(DocumentsCardWidget));
      await tester.pumpAndSettle();

      expect(find.byType(DocumentsSelectedInfoPage), findsOneWidget);
      expect(repo.downloadCalls.single, ['d1', '2']);
      expect(find.text('registration_use_terms_share'), findsOneWidget);
      expect(find.text('payment_list_show_document'), findsOneWidget);
    });

    testWidgets('vazio mostra o aviso e puxar recarrega', (tester) async {
      repo.results = [
        DocsListResult.fresh(docs: const [], lastFetchedAt: at)
      ];
      await pumpList(tester);
      expect(find.text('documents_not_found'), findsOneWidget);

      await tester.fling(
          find.text('documents_not_found'), const Offset(0, 300), 1000);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      await letRefreshRun(tester);

      expect(repo.watchCalls.last, ['C1', '2', 'U1', true]);
      expect(find.text('documents_not_found'), findsOneWidget);
    });

    testWidgets('erro mostra o widget de erro com tentar de novo e voltar',
        (tester) async {
      repo.results = [DocsListResult.error('boom')];
      await pumpList(tester);
      expect(find.byType(ErrorHandlingWidget), findsOneWidget);

      repo.results = [
        DocsListResult.fresh(docs: [buildDocument()], lastFetchedAt: at)
      ];
      await tester.tap(find.text('error_handling_widget_button_reTry').first);
      await letRefreshRun(tester);
      expect(repo.watchCalls.last, ['C1', '2', 'U1', true]);
      expect(find.byType(DocumentsCardWidget), findsOneWidget);

      repo.results = [DocsListResult.error('boom')];
      await pumpList(tester);
      await tester.tap(find.text('error_handling_widget_button_back').first);
      await tester.pumpAndSettle();
      expect(find.byType(DocumentsSelectedPage), findsNothing);
      expect(observer.popped, isNotEmpty);
    });

    testWidgets('revalidando mostra o spinner do RefreshIndicator',
        (tester) async {
      repo.results = [
        DocsListResult.staleRevalidating(
            docs: [buildDocument()], lastFetchedAt: at),
      ];
      await pumpList(tester, settle: false);
      await tester.pump();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(RefreshProgressIndicator), findsOneWidget);
      expect(find.byType(DocumentsCardWidget), findsOneWidget);
      // O `show()` chama o onRefresh, que revalida e recebe dados frescos.
      repo.results = [
        DocsListResult.fresh(docs: [buildDocument()], lastFetchedAt: at)
      ];
      await letRefreshRun(tester);
      expect(repo.watchCalls.last, ['C1', '2', 'U1', true]);
      expect(find.byType(RefreshProgressIndicator), findsNothing);
      expect(find.byType(DocumentsCardWidget), findsOneWidget);
    });

    testWidgets('sem conexão mostra a faixa com o tempo do cache',
        (tester) async {
      Future<void> check(DateTime? fetchedAt, String text) async {
        if (fetchedAt == null) {
          // O repositório sempre informa a data; o estado sem data só é
          // alcançável emitindo direto no bloc.
          repo.results = [
            DocsListResult.fresh(docs: [buildDocument()], lastFetchedAt: at)
          ];
          await pumpList(tester);
          // ignore: invalid_use_of_visible_for_testing_member
          controller.bloc.emit(DocumentsLoadedState(
              documents: [buildDocument()],
              freshness: DocsFreshness.staleFailed));
          await tester.pump();
          await tester.pump();
        } else {
          repo.results = [
            DocsListResult.staleFailed(
                docs: [buildDocument()], lastFetchedAt: fetchedAt)
          ];
          await pumpList(tester);
        }
        expect(find.byIcon(Icons.cloud_off), findsOneWidget);
        expect(find.text(text), findsOneWidget);
      }

      final now = DateTime.now();
      await check(null, 'Sem conexão. Mostrando dados salvos.');
      await check(now.subtract(const Duration(seconds: 20)),
          'Sem conexão. Mostrando dados de instantes atrás.');
      await check(now.subtract(const Duration(minutes: 5)),
          'Sem conexão. Mostrando dados de 5 min atrás.');
      await check(now.subtract(const Duration(hours: 3)),
          'Sem conexão. Mostrando dados de 3 h atrás.');
      await check(now.subtract(const Duration(days: 2)),
          'Sem conexão. Mostrando dados de 2 d atrás.');
      await expectLater(find.byType(DocumentsSelectedPage),
          matchesGoldenFile('goldens/documents_selected_page_offline.png'));
    });

    testWidgets('deep-link da notificação abre o documento pelo id ou parâmetro',
        (tester) async {
      final pdf = writePdf(dir, 'deeplink.pdf');
      repo.download = () => Success(pdf);
      repo.results = [
        DocsListResult.fresh(docs: [
          buildDocument(id: 'd1', notificationParameter: 'np1'),
          buildDocument(id: 'd2', name: 'Ata 2', notificationParameter: 'np2'),
        ], lastFetchedAt: at)
      ];
      await pumpList(tester, notificationContext: 'd2');
      expect(find.byType(DocumentsSelectedInfoPage), findsOneWidget);
      expect(find.text('Ata 2'), findsOneWidget);
      expect(repo.downloadCalls.single, ['d2', '2']);

      repo.downloadCalls.clear();
      await pumpList(tester, notificationContext: 'np1');
      expect(find.byType(DocumentsSelectedInfoPage), findsOneWidget);
      expect(repo.downloadCalls.single, ['d1', '2']);

      repo.downloadCalls.clear();
      await pumpList(tester, notificationContext: 'nao-existe');
      expect(find.byType(DocumentsSelectedInfoPage), findsNothing);
      expect(repo.downloadCalls, isEmpty);
    });

    testWidgets('estado do arquivo não afeta a lista', (tester) async {
      repo.results = [
        DocsListResult.fresh(docs: [buildDocument()], lastFetchedAt: at)
      ];
      await pumpList(tester);
      // ignore: invalid_use_of_visible_for_testing_member
      controller.bloc.emit(DocumentsFileLoadingState());
      await tester.pump();
      expect(find.byType(DocumentsCardWidget), findsOneWidget);
      expect(find.byType(LoadingWidget), findsNothing);
    });
  });

  group('DocumentsSelectedInfoPage', () {
    Future<void> pumpInfo(WidgetTester tester,
        {DocumentsState? state,
        bool accessible = false,
        bool settle = true}) async {
      await tester.pumpWidget(const SizedBox());
      buildController();
      if (state != null) {
        // ignore: invalid_use_of_visible_for_testing_member
        controller.bloc.emit(state);
      }
      Widget page = DocumentsSelectedInfoPage(
        controller: controller,
        document: buildDocument(),
        appBarTitle: minutesType,
      );
      if (accessible) {
        page = MediaQuery(
          data: const MediaQueryData(accessibleNavigation: true),
          child: page,
        );
      }
      await pumpPage(tester, page, observer: observer, settle: settle);
    }

    DocumentFile loadedFile(File pdf, {Future<String?> Function()? text}) =>
        DocumentFile(
          id: 'd1',
          name: 'ata.pdf',
          documentName: 'Ata',
          localFile: pdf,
          loadExtractedText: text,
        );

    testWidgets('loading, falha (tentar de novo e voltar) e estados neutros',
        (tester) async {
      await pumpInfo(tester, state: DocumentsFileLoadingState(), settle: false);
      await tester.pump();
      expect(find.byType(LoadingWidget), findsOneWidget);

      final pdf = writePdf(dir, 'retry.pdf');
      repo.download = () => Success(pdf);
      await pumpInfo(tester, state: DocumentsFileFailureState(error: 'x'));
      expect(find.byType(ErrorHandlingWidget), findsOneWidget);
      await tester.tap(find.text('error_handling_widget_button_reTry').first);
      await tester.pumpAndSettle();
      expect(repo.downloadCalls.single, ['d1', '2']);
      expect(find.text('registration_use_terms_share'), findsOneWidget);

      await pumpInfo(tester, state: DocumentsFileFailureState(error: 'x'));
      await tester.tap(find.text('error_handling_widget_button_back').first);
      await tester.pumpAndSettle();
      expect(find.byType(DocumentsSelectedInfoPage), findsNothing);

      await pumpInfo(tester, state: DocumentsEmptyState());
      expect(find.byType(ElevatedButton), findsNothing);

      await pumpInfo(tester,
          state: DocumentsFileLoadedState(file: DocumentFile(id: 'sem')));
      expect(find.byType(ElevatedButton), findsNothing);
    });

    testWidgets('arquivo carregado: compartilhar usa o share e loga',
        (tester) async {
      final pdf = writePdf(dir, 'share.pdf');
      await pumpInfo(tester,
          state: DocumentsFileLoadedState(file: loadedFile(pdf)));
      expect(find.text('Ata da assembleia'), findsOneWidget);
      await expectLater(find.byType(DocumentsSelectedInfoPage),
          matchesGoldenFile('goldens/documents_selected_info_page.png'));

      await tester.tap(find.text('registration_use_terms_share'));
      await tester.pumpAndSettle();

      expect(analytics.shares, [minutesType]);
      expect(share.shared.single.files!.single.path, pdf.path);
      expect(share.shared.single.sharePositionOrigin, isNotNull);
    });

    testWidgets('sem permissão de armazenamento não compartilha',
        (tester) async {
      permissions.status = PermissionStatus.denied;
      final pdf = writePdf(dir, 'denied.pdf');
      await pumpInfo(tester,
          state: DocumentsFileLoadedState(
              file: loadedFile(pdf)..name = null));
      // O handler falso concede na primeira solicitação: a página pede a
      // permissão e só então compartilha.
      await tester.tap(find.text('registration_use_terms_share'));
      await tester.pumpAndSettle();
      expect(permissions.requestCount, 1);
      expect(share.shared.single.files!.single.path, pdf.path);
      expect(analytics.shares, [minutesType]);
    });

    testWidgets('ver documento navega para o visualizador de PDF',
        (tester) async {
      final pdf = writePdf(dir, 'view.pdf');
      await pumpInfo(tester,
          state: DocumentsFileLoadedState(file: loadedFile(pdf)));
      final before = observer.pushed.length;

      // O visualizador (pdfrx) não roda no `flutter test`: deixamos o push
      // acontecer e desmontamos antes do frame que o construiria.
      await tester.runAsync(() async {
        await tester.tap(find.text('payment_list_show_document'));
        await Future<void>.delayed(const Duration(milliseconds: 50));
      });
      expect(observer.pushed.length, before + 1);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('com leitor de tela carrega o texto extraído antes de abrir',
        (tester) async {
      final pdf = writePdf(dir, 'a11y.pdf');
      var loads = 0;
      await pumpInfo(tester,
          accessible: true,
          state: DocumentsFileLoadedState(
              file: loadedFile(pdf, text: () async {
            loads++;
            return 'texto';
          })));
      final before = observer.pushed.length;

      await tester.runAsync(() async {
        await tester.tap(find.text('payment_list_show_document'));
        await Future<void>.delayed(const Duration(milliseconds: 50));
      });
      expect(loads, 1);
      expect(observer.pushed.length, before + 1);
      await tester.pumpWidget(const SizedBox());
    });
  });
}
