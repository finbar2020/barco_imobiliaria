import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart' show ImageSource;
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:morar/feature/reports_book/domain/entity/report.dart';
import 'package:morar/feature/reports_book/presentation/bloc/reports_state.dart';
import 'package:morar/feature/reports_book/presentation/controller/reports_controller.dart';
import 'package:morar/feature/reports_book/presentation/pages/reports_my_reports/reports_my_report_reply_failure_attachment_page.dart';
import 'package:morar/feature/reports_book/presentation/pages/reports_my_reports/reports_my_report_reply_page.dart';
import 'package:morar/feature/reports_book/presentation/pages/reports_my_reports/reports_my_report_reply_success_page.dart';
import 'package:morar/feature/reports_book/presentation/pages/reports_new_report/reports_register_new_report_page.dart';
import 'package:morar/feature/reports_book/presentation/widgets/report_message_widget.dart';

import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';
import 'reports_book_page_helpers.dart';

void main() {
  late PageHarness harness;
  late RecordingNavigatorObserver observer;
  late List<String> reviewCalls;
  late FakePickers pickers;

  setUp(() async {
    harness = await installPageHarness();
    observer = RecordingNavigatorObserver();
    reviewCalls = installFakeInAppReview();
    pickers = installFakePickers();
  });

  final routes = <String, WidgetBuilder>{
    ApplicationRoute.myReportReplySuccess: (_) => const MyReportReplySuccessPage(),
    ApplicationRoute.myReportReplyFailureAttachment: (_) =>
        const MyReportReplyFailureAttachmentPage(),
    ApplicationRoute.registerNewReport: (_) => const RegisterNewReportPage(),
  };

  Map<String, dynamic> putResponse() =>
      reportJson('r1', numReport: '101', contents: [contentJson('c2')]);

  /// Monta a tela de resposta já com o rascunho (`SendReportState`).
  Future<ControllerWithFakeUpload> pumpReply(
    WidgetTester tester, {
    bool failUpload = false,
    Report? report,
  }) async {
    final setup = await controllerWithFakeUpload(harness, failUpload: failUpload);
    await pumpPage(
      tester,
      const MyReportReplyPage(),
      observer: observer,
      arguments: [setup.controller],
      routes: routes,
      settle: false,
    );
    await setup.controller.replyReport(report ?? buildReport());
    await tester.pumpAndSettle();
    return setup;
  }

  group('MyReportReplyPage', () {
    testWidgets('estado de loading mostra o indicador', (tester) async {
      final controller = harness.resolve<ReportsController>();
      await pumpPage(tester, const MyReportReplyPage(),
          arguments: [controller], settle: false);

      expect(find.byType(LoadingWidget), findsOneWidget);
      expect(find.text('reports_report '), findsOneWidget);
    });

    testWidgets('mostra o formulário de resposta sem a opção de público',
        (tester) async {
      await pumpReply(tester);

      expect(find.text('reports_report #101'), findsOneWidget);
      expect(find.byType(ReportMessageWidget), findsOneWidget);
      expect(find.text('reports_message'), findsOneWidget);
      expect(find.text('reports_attach_file'), findsOneWidget);
      expect(find.text('reports_public'), findsNothing);
      expect(find.text('send'), findsOneWidget);
      await expectLater(
        find.byType(MyReportReplyPage),
        matchesGoldenFile('goldens/my_report_reply_page.png'),
      );
    });

    testWidgets('enviar sem texto avisa e não chama a api', (tester) async {
      await pumpReply(tester);

      await tester.tap(find.text('send'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('reports_empty_content_flushbar'), findsOneWidget);
      expect(harness.http.requests, isEmpty);
      await tester.pumpAndSettle();
    });

    testWidgets('enviar a resposta abre a tela de sucesso', (tester) async {
      harness.http.on('PUT', putContentPath('r1'), body: putResponse());
      harness.http.on('GET', allReportsPath, body: []);
      final setup = await pumpReply(tester);

      await tester.enterText(find.byType(TextField), 'Minha resposta');
      await tester.tap(find.text('send'));
      await tester.pumpAndSettle();

      final put = harness.http.requests.single;
      expect(put.method, 'PUT');
      expect(put.body, contains('"content":"Minha resposta"'));
      expect(setup.upload.calls, isEmpty);
      expect(setup.controller.reportsBloc.state, isA<ReportPostedState>());
      expect(observer.pushedNames.last, ApplicationRoute.myReportReplySuccess);
      expect(find.byType(MyReportReplySuccessPage), findsOneWidget);
      expect(find.text('reports_reply_success'), findsOneWidget);
      expect(find.text('reports_report #101'), findsOneWidget);
      expect(find.text('Edifício Lello - 101'), findsOneWidget);

      // Concluir pede avaliação, recarrega a lista e fecha.
      await tester.tap(find.text('conclude'));
      await tester.pumpAndSettle();
      expect(reviewCalls, contains('isAvailable'));
      expect(harness.http.requests.last.url.path, allReportsPath);
      expect(find.byType(MyReportReplySuccessPage), findsNothing);
    });

    /// Corrigido: `beginPickImage`/`beginTakeFile` emitem um `SendReportState`
    /// com uma cópia nova do `ReportContents` (o Equatable compara as
    /// referências), então o bloc emite o estado e a tela mostra a miniatura
    /// do anexo escolhido, que é enviado depois da resposta.
    testWidgets('anexo de imagem da galeria mostra a miniatura e é enviado depois da resposta',
        (tester) async {
      harness.http.on('PUT', putContentPath('r1'), body: putResponse());
      final png = tempPng();
      pickers.image.path = png.path;
      pickers.cropper.path = png.path;
      final setup = await pumpReply(tester);

      await tester.tap(findSvg('assets/ic_photo_bold.svg'));
      await tester.pumpAndSettle();

      expect(pickers.image.sources, [ImageSource.gallery]);
      expect(pickers.cropper.cropped, [png.path]);
      final state = setup.controller.reportsBloc.state as SendReportState;
      expect(state.content.attachmentType, 'image');
      expect(state.content.attachmentFile!.path, png.path);
      // A tela troca os botões de anexar pela miniatura com o botão de remover.
      expect(findSvg('assets/ic_photo_bold.svg'), findsNothing);
      expect(findSvg('assets/ic_close.svg'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Com foto');
      await tester.tap(find.text('send'));
      await tester.pumpAndSettle();

      expect(setup.upload.calls.single.contentId, 'c2');
      expect(setup.upload.calls.single.file.path, png.path);
      expect(find.byType(MyReportReplySuccessPage), findsOneWidget);
    });

    testWidgets('câmera cancelada e recorte cancelado não alteram o rascunho',
        (tester) async {
      final setup = await pumpReply(tester);

      await tester.tap(findSvg('assets/ic_camera_bold.svg'));
      await tester.pumpAndSettle();
      expect(pickers.image.sources, [ImageSource.camera]);
      expect(pickers.cropper.cropped, isEmpty);

      pickers.image.path = tempPng().path;
      await tester.tap(findSvg('assets/ic_camera_bold.svg'));
      await tester.pumpAndSettle();
      expect(pickers.cropper.cropped, hasLength(1));
      final state = setup.controller.reportsBloc.state as SendReportState;
      expect(state.content.attachmentFile, isNull);
      expect(findSvg('assets/ic_camera_bold.svg'), findsOneWidget);
    });

    testWidgets('arquivo escolhido vira anexo em pdf do rascunho', (tester) async {
      pickers.file.file = tempAttachment(name: 'documento.txt', size: 3);
      final setup = await pumpReply(tester);

      await tester.tap(findSvg('assets/ic_attachment_bold.svg'));
      await tester.pumpAndSettle();

      expect(pickers.file.picks, 1);
      final state = setup.controller.reportsBloc.state as SendReportState;
      expect(state.content.attachmentType, 'application/pdf');
      expect(state.content.attachmentFile!.path, pickers.file.file!.path);
      expect(state.flushbarMessage, isNull);
      // Corrigido: o estado novo é emitido e a tela mostra o ícone do documento.
      expect(findSvg('assets/ic_documents.svg'), findsOneWidget);
      expect(findSvg('assets/ic_attachment_bold.svg'), findsNothing);
    });

    testWidgets('arquivo cancelado não altera o rascunho', (tester) async {
      final setup = await pumpReply(tester);

      await tester.tap(findSvg('assets/ic_attachment_bold.svg'));
      await tester.pumpAndSettle();

      expect(pickers.file.picks, 1);
      final state = setup.controller.reportsBloc.state as SendReportState;
      expect(state.content.attachmentFile, isNull);
    });

    testWidgets('arquivo acima do limite é recusado com aviso', (tester) async {
      harness.remoteConfig.values = {'file_max_size_permitted': '2'};
      pickers.file.file = tempAttachment(name: 'grande.txt', size: 3);
      final setup = await pumpReply(tester);

      await tester.tap(findSvg('assets/ic_attachment_bold.svg'));
      await tester.pumpAndSettle();

      final state = setup.controller.reportsBloc.state as SendReportState;
      expect(state.flushbarMessage, 'document_size_exceeds_limit');
      expect(state.content.attachmentFile, isNull);
      expect(state.content.attachmentType, isNull);
    });

    testWidgets('falha no upload do anexo abre a tela de falha de anexo',
        (tester) async {
      harness.http.on('PUT', putContentPath('r1'), body: putResponse());
      final png = tempPng();
      pickers.image.path = png.path;
      pickers.cropper.path = png.path;
      final setup = await pumpReply(tester, failUpload: true);
      await tester.tap(findSvg('assets/ic_photo_bold.svg'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Com foto');

      await tester.tap(find.text('send'));
      await tester.pumpAndSettle();

      expect(observer.pushedNames.last,
          ApplicationRoute.myReportReplyFailureAttachment);
      final args = observer.pushed.last.settings.arguments
          as MyReportReplyFailureAttachmentPageArg;
      expect(args.report.reportContents!.first.id, 'c2');
      expect(args.attachment.path, png.path);
      expect(find.byType(MyReportReplyFailureAttachmentPage), findsOneWidget);
      expect(find.text('reports_attachment_failure_text'), findsOneWidget);
      expect(find.text('reports_report #101'), findsOneWidget);
      expect(find.text('try_again'), findsOneWidget);

      // Tentar de novo com o upload funcionando leva ao sucesso.
      setup.upload.failure = null;
      await tester.tap(find.text('try_again'));
      await tester.pumpAndSettle();
      expect(setup.upload.calls, hasLength(2));
      expect(find.byType(MyReportReplySuccessPage), findsOneWidget);
    });

    /// Corrigido: ao falhar o envio o bloc emite só o
    /// `NewReplyReportsFailureState` (que agora carrega `report`), sem o
    /// `ReportsFailureState` genérico em seguida; voltar devolve o rascunho
    /// para edição em vez de quebrar com null-check.
    testWidgets('falha ao enviar mostra o erro e voltar devolve o rascunho',
        (tester) async {
      harness.http.on('PUT', putContentPath('r1'), status: 500, body: {'message': 'x'});
      final setup = await pumpReply(tester);
      await tester.enterText(find.byType(TextField), 'Oi');

      await tester.tap(find.text('send'));
      await tester.pumpAndSettle();

      final state = setup.controller.reportsBloc.state;
      expect(state, isA<NewReplyReportsFailureState>());
      expect(state.report?.idReport, 'r1');
      expect(find.text('reports_report #101'), findsOneWidget);
      expect(find.text('reports_send_error'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back_ios));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final draft = setup.controller.reportsBloc.state as SendReportState;
      expect(draft.content.content, 'Oi');
      expect(find.byType(MyReportReplyPage), findsOneWidget);
      expect(find.text('Oi'), findsOneWidget);
    });

    testWidgets('voltar com falha específica devolve o rascunho', (tester) async {
      final setup = await pumpReply(tester);
      final report = buildReport();
      final content = buildContent(content: 'rascunho');
      await emitState(
        tester,
        setup.controller.reportsBloc,
        NewReplyReportsFailureState(
            CurrentReport: report, content: content, failure: null),
      );
      expect(find.text('reports_send_error'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back_ios));
      await tester.pumpAndSettle();

      final state = setup.controller.reportsBloc.state as SendReportState;
      expect(state.content.content, 'rascunho');
      expect(find.byType(MyReportReplyPage), findsOneWidget);
      expect(find.text('rascunho'), findsOneWidget);
    });

    testWidgets('seta de voltar volta para os detalhes', (tester) async {
      final setup = await pumpReply(tester);

      await tester.tap(find.byIcon(Icons.arrow_back_ios));
      await tester.pumpAndSettle();

      expect(setup.controller.reportsBloc.state, isA<SeeReportDetailsState>());
      expect(find.byType(MyReportReplyPage), findsNothing);
    });

    testWidgets('voltar pelo sistema volta para os detalhes', (tester) async {
      final setup = await pumpReply(tester);

      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      // O WillPopScope devolve false (doNotPop) e faz o pop por conta própria.
      expect(await navigator.maybePop(), isTrue);
      await tester.pumpAndSettle();

      expect(setup.controller.reportsBloc.state, isA<SeeReportDetailsState>());
      expect(find.byType(MyReportReplyPage), findsNothing);
    });

    testWidgets('outros estados deixam o corpo vazio e voltar sem ocorrência só fecha',
        (tester) async {
      final setup = await pumpReply(tester);
      await emitState(tester, setup.controller.reportsBloc, const ReportsBookFirstState());

      expect(find.byType(ReportMessageWidget), findsNothing);
      expect(find.byType(LoadingWidget), findsNothing);

      // Corrigido: `_onPop` é nulo-seguro quando o estado não tem `report`.
      await tester.tap(find.byIcon(Icons.arrow_back_ios));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(setup.controller.reportsBloc.state, const ReportsBookFirstState());
      expect(find.byType(MyReportReplyPage), findsNothing);
    });
  });

  group('MyReportReplySuccessPage', () {
    Future<ReportsController> pumpSuccess(WidgetTester tester,
        {bool settle = true}) async {
      final controller = harness.resolve<ReportsController>();
      await pumpPage(
        tester,
        const MyReportReplySuccessPage(),
        observer: observer,
        arguments: MyReportReplySuccessPageArg(controller: controller),
        routes: routes,
        settle: settle,
      );
      return controller;
    }

    testWidgets('loading, falha e outros estados', (tester) async {
      final controller = await pumpSuccess(tester, settle: false);
      expect(find.byType(LoadingWidget), findsOneWidget);

      await emitState(tester, controller.reportsBloc, const ReportsFailureState());
      expect(find.text('reports_create_error'), findsOneWidget);

      await emitState(tester, controller.reportsBloc, const ReportsBookFirstState());
      expect(find.text('reports_create_error'), findsNothing);
      expect(find.byType(LoadingWidget), findsNothing);
    });

    testWidgets('"registrar nova ocorrência" troca para o cadastro',
        (tester) async {
      final controller = await pumpSuccess(tester, settle: false);
      await emitState(tester, controller.reportsBloc,
          ReportPostedState(report: buildReport()));
      await expectLater(
        find.byType(MyReportReplySuccessPage),
        matchesGoldenFile('goldens/my_report_reply_success_page.png'),
      );

      await tester.tap(find.text('reports_register_new_report'));
      await tester.pumpAndSettle();

      expect(observer.pushedNames.last, ApplicationRoute.registerNewReport);
      final args =
          observer.pushed.last.settings.arguments as RegisterNewReportPageArgs;
      expect(args.isSucess, isTrue);
      expect(find.byType(RegisterNewReportPage), findsOneWidget);
      expect(find.byType(MyReportReplySuccessPage), findsNothing);
      expect(controller.reportsBloc.state, isA<SendReportState>());
    });

    testWidgets('voltar pelo sistema recarrega a lista', (tester) async {
      harness.http.on('GET', allReportsPath, body: []);
      final controller = await pumpSuccess(tester, settle: false);
      await emitState(tester, controller.reportsBloc,
          ReportPostedState(report: buildReport()));

      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      expect(await navigator.maybePop(), isTrue);
      await tester.pumpAndSettle();

      expect(harness.http.requests.single.url.path, allReportsPath);
    });
  });

  group('MyReportReplyFailureAttachmentPage', () {
    Future<ControllerWithFakeUpload> pumpFailure(WidgetTester tester) async {
      final setup = await controllerWithFakeUpload(harness);
      final report = buildReport(contents: [buildContent(id: 'c2')]);
      final content = buildContent();
      final attachment = tempPng();
      await pumpPage(
        tester,
        const MyReportReplyFailureAttachmentPage(),
        observer: observer,
        arguments: MyReportReplyFailureAttachmentPageArg(
          controller: setup.controller,
          report: report,
          content: content,
          attachment: attachment,
        ),
        routes: routes,
        settle: false,
      );
      // O bloc nasce em loading (spinner infinito): coloca o estado real.
      await emitState(
        tester,
        setup.controller.reportsBloc,
        AttachmentReportsFailureState(
            report: report, content: content, attachment: attachment, failure: null),
      );
      return setup;
    }

    testWidgets('concluir pede avaliação e volta ao menu', (tester) async {
      final setup = await pumpFailure(tester);
      await expectLater(
        find.byType(MyReportReplyFailureAttachmentPage),
        matchesGoldenFile('goldens/my_report_reply_failure_attachment_page.png'),
      );

      await tester.tap(find.text('conclude'));
      await tester.pumpAndSettle();

      expect(reviewCalls, contains('isAvailable'));
      expect(setup.controller.reportsBloc.state, const ReportsBookFirstState());
      expect(find.byType(MyReportReplyFailureAttachmentPage), findsNothing);
    });

    testWidgets('enquanto reenvia os botões ficam desabilitados', (tester) async {
      final setup = await pumpFailure(tester);
      await emitState(tester, setup.controller.reportsBloc,
          const ReportsLoadingState(), settle: false);
      await tester.pump();

      expect(find.text('resending'), findsOneWidget);
      expect(find.text('try_again'), findsNothing);
      final buttons = tester.widgetList<ElevatedButton>(find.byType(ElevatedButton));
      expect(buttons.every((b) => b.onPressed == null), isTrue);
    });

    testWidgets('tentar de novo com sucesso abre a tela de sucesso',
        (tester) async {
      final setup = await pumpFailure(tester);

      await tester.tap(find.text('try_again'));
      await tester.pumpAndSettle();

      expect(setup.upload.calls.single.contentId, 'c2');
      expect(find.byType(MyReportReplySuccessPage), findsOneWidget);
    });

    testWidgets('voltar pelo sistema recarrega a lista', (tester) async {
      harness.http.on('GET', allReportsPath, body: []);
      await pumpFailure(tester);

      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      expect(await navigator.maybePop(), isTrue);
      await tester.pumpAndSettle();

      expect(harness.http.requests.single.url.path, allReportsPath);
    });
  });
}
