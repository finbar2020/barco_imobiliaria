import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:morar/feature/reports_book/presentation/bloc/reports_state.dart';
import 'package:morar/feature/reports_book/presentation/controller/reports_controller.dart';
import 'package:morar/feature/reports_book/presentation/pages/reports_new_report/reports_new_report_failure_attachment_page.dart';
import 'package:morar/feature/reports_book/presentation/pages/reports_new_report/reports_new_report_success_page.dart';
import 'package:morar/feature/reports_book/presentation/pages/reports_new_report/reports_register_new_report_page.dart';
import 'package:morar/feature/reports_book/presentation/pages/reports_new_report/reports_review_new_report_page.dart';
import 'package:morar/feature/reports_book/presentation/widgets/report_message_widget.dart';
import 'package:morar/feature/reports_book/presentation/widgets/report_preview_widget.dart';

import '../../helpers/firebase_mocks.dart';
import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';
import 'reports_book_page_helpers.dart';

/// `Report.setTypeReport` só reconhece os nomes reais dos assuntos.
const typeTexts = {
  'reports_type_compliment': 'Elogios',
  'reports_type_suggestion': 'Sugestões',
  'reports_type_complaint': 'Reclamações',
  'reports_type_others': 'Outros',
};

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
    fakeAnalytics.reset();
  });

  final routes = <String, WidgetBuilder>{
    ApplicationRoute.reviewNewReport: (_) => const ReviewNewReportPage(),
    ApplicationRoute.newReportSuccess: (_) => const NewReportSuccessPage(),
    ApplicationRoute.reportNewReportFailureAttachment: (_) =>
        const ReportsNewReportFailureAttachmentPage(),
    ApplicationRoute.registerNewReport: (_) => const RegisterNewReportPage(),
  };

  Map<String, dynamic> postResponse() =>
      reportJson('new', numReport: '555', contents: [contentJson('c9')]);

  /// Monta o cadastro já com o rascunho vazio (`SendReportState`).
  Future<ControllerWithFakeUpload> pumpRegister(
    WidgetTester tester, {
    bool failUpload = false,
    bool isSucess = false,
    Map<String, WidgetBuilder>? customRoutes,
  }) async {
    final setup = await controllerWithFakeUpload(harness, failUpload: failUpload);
    await pumpPage(
      tester,
      const RegisterNewReportPage(),
      observer: observer,
      arguments: RegisterNewReportPageArgs(
          controller: setup.controller, isSucess: isSucess),
      routes: customRoutes ?? routes,
      settle: false,
      locOverrides: typeTexts,
      surface: const Size(400, 900),
    );
    await setup.controller.createNewReport();
    await tester.pumpAndSettle();
    return setup;
  }

  Finder dropdown() => find.byWidgetPredicate((w) => w is DropdownButton);

  Future<void> chooseType(WidgetTester tester, String text) async {
    await tester.tap(dropdown());
    await tester.pumpAndSettle();
    await tester.tap(find.text(text).last);
    await tester.pumpAndSettle();
  }

  Future<void> fillAndGoNext(WidgetTester tester, {String text = 'Barulho'}) async {
    await chooseType(tester, 'Reclamações');
    await tester.enterText(find.byType(TextField), text);
    await tester.tap(find.text('reports_next'));
    await tester.pumpAndSettle();
  }

  group('RegisterNewReportPage', () {
    testWidgets('estado de loading mostra o indicador', (tester) async {
      final controller = harness.resolve<ReportsController>();
      await pumpPage(tester, const RegisterNewReportPage(),
          arguments: RegisterNewReportPageArgs(controller: controller),
          settle: false);

      expect(find.byType(LoadingWidget), findsOneWidget);
      expect(find.text('reports_new_report'), findsOneWidget);
    });

    testWidgets('mostra o formulário completo da nova ocorrência', (tester) async {
      await pumpRegister(tester);

      expect(find.text('reports_subject'), findsOneWidget);
      expect(find.text('reports_choose_type'), findsOneWidget);
      expect(find.byType(ReportMessageWidget), findsOneWidget);
      expect(find.text('reports_public'), findsOneWidget);
      expect(find.text('yes'), findsOneWidget);
      expect(find.text('no'), findsOneWidget);
      // Corrigido: a linha de anexos do `ReportMessageWidget` usa `Expanded`;
      // as legendas (mesmo as chaves cruas) quebram de linha em 400px.
      expect(tester.takeException(), isNull);
      expect(find.text('reports_request_pick_image_from_gallery'), findsOneWidget);
      expect(find.text('reports_camera'), findsOneWidget);
      expect(find.text('reports_create_attachment'), findsOneWidget);
      expect(find.text('send'), findsNothing);
      expect(find.text('reports_next'), findsOneWidget);
      expect(fakeAnalytics.eventNames, contains('ocorrencias_registrar_nova_ocorrencia'));
      await expectLater(
        find.byType(RegisterNewReportPage),
        matchesGoldenFile('goldens/register_new_report_page.png'),
      );
    });

    testWidgets('avançar sem assunto e sem texto mostra os avisos', (tester) async {
      await pumpRegister(tester);

      await tester.tap(find.text('reports_next'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('reports_empty_content_type_flushbar'), findsOneWidget);
      await tester.pumpAndSettle();

      await chooseType(tester, 'Sugestões');
      await tester.enterText(find.byType(TextField), '   ');
      await tester.tap(find.text('reports_next'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('reports_empty_content_flushbar'), findsOneWidget);
      await tester.pumpAndSettle();

      expect(observer.pushedNames, isNot(contains(ApplicationRoute.reviewNewReport)));
    });

    testWidgets('escolher o assunto guarda o tipo no rascunho', (tester) async {
      final setup = await pumpRegister(tester);

      await chooseType(tester, 'Elogios');
      final state = setup.controller.reportsBloc.state as SendReportState;
      expect(state.report!.typeReport, 'COMPLIMENT');
      expect(find.text('Elogios'), findsOneWidget);

      await chooseType(tester, 'Outros');
      expect(state.report!.typeReport, 'OTHERS');
    });

    testWidgets('fluxo completo: revisar, enviar e concluir', (tester) async {
      harness.http.on('POST', postReportPath, body: postResponse());
      final setup = await pumpRegister(tester);

      // Ocorrência não pública.
      await tester.tap(find.text('no'));
      await tester.pumpAndSettle();
      await fillAndGoNext(tester);

      expect(observer.pushedNames.last, ApplicationRoute.reviewNewReport);
      expect(find.byType(ReviewNewReportPage), findsOneWidget);
      expect(find.byType(ReportPreviewWidget), findsOneWidget);
      expect(find.text('Reclamações'), findsOneWidget);
      expect(find.text('Barulho'), findsOneWidget);
      expect(find.text('no'), findsOneWidget);
      expect(find.text('send'), findsOneWidget);
      await expectLater(
        find.byType(ReviewNewReportPage),
        matchesGoldenFile('goldens/review_new_report_page.png'),
      );

      await tester.tap(find.text('send'));
      await tester.pumpAndSettle();

      final post = harness.http.requests.single;
      expect(post.method, 'POST');
      expect(post.body, contains('"type_report":"COMPLAINT"'));
      expect(post.body, contains('"public":false'));
      expect(post.body, contains('"id_unit":"$unitId"'));
      expect(setup.upload.calls, isEmpty);
      expect(fakeAnalytics.eventNames,
          contains('ocorrencias_registrar_nova_ocorrencia_sucesso'));
      expect(observer.pushedNames.last, ApplicationRoute.newReportSuccess);
      expect(find.byType(NewReportSuccessPage), findsOneWidget);
      expect(find.text('reports_registered_success'), findsOneWidget);
      expect(find.text('reports_report #555'), findsOneWidget);
      expect(find.text('Edifício Lello - 101'), findsOneWidget);
      await expectLater(
        find.byType(NewReportSuccessPage),
        matchesGoldenFile('goldens/new_report_success_page.png'),
      );

      await tester.tap(find.text('conclude'));
      await tester.pumpAndSettle();
      expect(reviewCalls, contains('isAvailable'));
      expect(setup.controller.reportsBloc.state, const ReportsBookFirstState());
      expect(find.byType(NewReportSuccessPage), findsNothing);
    });

    testWidgets('ocorrência com foto envia o anexo depois de criar', (tester) async {
      harness.http.on('POST', postReportPath, body: postResponse());
      final png = tempPng();
      pickers.image.path = png.path;
      pickers.cropper.path = png.path;
      final setup = await pumpRegister(tester);

      await tester.tap(findSvg('assets/ic_camera_bold.svg'));
      await tester.pumpAndSettle();
      final draft = setup.controller.reportsBloc.state as SendReportState;
      expect(draft.content.attachmentFile!.path, png.path);

      await fillAndGoNext(tester);
      expect(find.byType(ReviewNewReportPage), findsOneWidget);
      expect(find.text('reports_attached_file'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);

      await tester.tap(find.text('send'));
      await tester.pumpAndSettle();

      expect(setup.upload.calls.single.contentId, 'c9');
      expect(find.byType(NewReportSuccessPage), findsOneWidget);
    });

    testWidgets('falha no upload do anexo abre a tela de falha e permite reenviar',
        (tester) async {
      harness.http.on('POST', postReportPath, body: postResponse());
      pickers.file.file = tempAttachment(name: 'laudo.txt', size: 2);
      final setup = await pumpRegister(tester, failUpload: true);

      await tester.tap(findSvg('assets/ic_attachment_bold.svg'));
      await tester.pumpAndSettle();
      await fillAndGoNext(tester);
      expect(findSvg('assets/ic_documents.svg'), findsOneWidget);

      await tester.tap(find.text('send'));
      await tester.pumpAndSettle();

      expect(observer.pushedNames.last,
          ApplicationRoute.reportNewReportFailureAttachment);
      final args = observer.pushed.last.settings.arguments
          as ReportsNewReportFailureAttachmentPageArg;
      expect(args.report.numReport, '555');
      expect(find.byType(ReportsNewReportFailureAttachmentPage), findsOneWidget);
      expect(find.text('reports_report #555'), findsOneWidget);
      expect(find.text('reports_attachment_failure_text'), findsOneWidget);

      setup.upload.failure = null;
      await tester.tap(find.text('try_again'));
      await tester.pumpAndSettle();
      expect(setup.upload.calls, hasLength(2));
      expect(find.byType(NewReportSuccessPage), findsOneWidget);
    });

    testWidgets('sucesso: "registrar nova ocorrência" reabre o cadastro e voltar recarrega a lista',
        (tester) async {
      harness.http.on('POST', postReportPath, body: postResponse());
      harness.http.on('GET', allReportsPath, body: []);
      final setup = await pumpRegister(tester);
      await fillAndGoNext(tester);
      await tester.tap(find.text('send'));
      await tester.pumpAndSettle();
      expect(find.byType(NewReportSuccessPage), findsOneWidget);

      await tester.tap(find.text('reports_register_new_report'));
      await tester.pumpAndSettle();

      expect(observer.pushedNames.last, ApplicationRoute.registerNewReport);
      final args =
          observer.pushed.last.settings.arguments as RegisterNewReportPageArgs;
      expect(args.isSucess, isTrue);
      expect(find.byType(RegisterNewReportPage), findsOneWidget);
      final draft = setup.controller.reportsBloc.state as SendReportState;
      expect(draft.report!.idReport, isNull);
      expect(draft.content.content, isNull);

      await tester.tap(find.byIcon(Icons.arrow_back_ios));
      await tester.pumpAndSettle();
      expect(harness.http.requests.last.url.path, allReportsPath);
      expect(find.byType(RegisterNewReportPage), findsNothing);
    });

    testWidgets('revisão devolvendo a ocorrência fecha o cadastro com ela',
        (tester) async {
      final report = buildReport(id: 'devolvida');
      final custom = <String, WidgetBuilder>{
        ApplicationRoute.reviewNewReport: (_) => Builder(
              builder: (context) => TextButton(
                onPressed: () => Navigator.pop(context, report),
                child: const Text('devolver'),
              ),
            ),
      };
      await pumpRegister(tester, customRoutes: custom);
      await fillAndGoNext(tester);

      await tester.tap(find.text('devolver'));
      await tester.pumpAndSettle();

      expect(find.byType(RegisterNewReportPage), findsNothing);
      expect(observer.popped.last.settings.name, pageRouteName);
    });

    testWidgets('aviso do bloc vira snackbar', (tester) async {
      final setup = await pumpRegister(tester);
      final draft = setup.controller.reportsBloc.state as SendReportState;

      await emitState(
        tester,
        setup.controller.reportsBloc,
        SendReportState(
            report: draft.report,
            content: draft.content,
            flushbarMessage: 'document_size_exceeds_limit'),
        settle: false,
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('document_size_exceeds_limit'), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('seta de voltar sem sucesso volta ao menu', (tester) async {
      final setup = await pumpRegister(tester);

      await tester.tap(find.byIcon(Icons.arrow_back_ios));
      await tester.pumpAndSettle();

      expect(setup.controller.reportsBloc.state, const ReportsBookFirstState());
      expect(find.byType(RegisterNewReportPage), findsNothing);
    });

    testWidgets('voltar pelo sistema depois de sucesso recarrega a lista',
        (tester) async {
      harness.http.on('GET', allReportsPath, body: []);
      await pumpRegister(tester, isSucess: true);

      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      expect(await navigator.maybePop(), isTrue);
      await tester.pumpAndSettle();

      expect(harness.http.requests.single.url.path, allReportsPath);
      expect(find.byType(RegisterNewReportPage), findsNothing);
    });

    testWidgets('falha e outros estados', (tester) async {
      final setup = await pumpRegister(tester);

      await emitState(tester, setup.controller.reportsBloc, const ReportsFailureState());
      expect(find.text('reports_error'), findsOneWidget);

      await emitState(tester, setup.controller.reportsBloc, const ReportsBookFirstState());
      expect(find.text('reports_error'), findsNothing);
      expect(find.byType(ReportMessageWidget), findsNothing);
    });
  });

  group('ReviewNewReportPage', () {
    testWidgets('seta de voltar devolve o rascunho para edição', (tester) async {
      final setup = await pumpRegister(tester);
      await fillAndGoNext(tester, text: 'Editar depois');
      expect(find.byType(ReviewNewReportPage), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back_ios));
      await tester.pumpAndSettle();

      expect(find.byType(RegisterNewReportPage), findsOneWidget);
      final draft = setup.controller.reportsBloc.state as SendReportState;
      expect(draft.content.content, 'Editar depois');
      expect(draft.report!.typeReport, 'COMPLAINT');
      expect(find.text('Editar depois'), findsOneWidget);
      expect(find.text('Reclamações'), findsOneWidget);
    });

    testWidgets('voltar pelo sistema devolve o rascunho para edição',
        (tester) async {
      final setup = await pumpRegister(tester);
      await fillAndGoNext(tester);

      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      expect(await navigator.maybePop(), isTrue);
      await tester.pumpAndSettle();

      expect(find.byType(RegisterNewReportPage), findsOneWidget);
      expect(setup.controller.reportsBloc.state, isA<SendReportState>());
    });

    /// Corrigido: `ReportsBloc` registra handler para
    /// `NewReportsFailureEvent`; a falha ao criar chega à tela como
    /// `NewReportsFailureState` com o rascunho, e voltar devolve o que foi
    /// digitado para edição em vez de descartar.
    testWidgets('falha ao criar mostra o erro e voltar devolve o rascunho',
        (tester) async {
      harness.http.on('POST', postReportPath, status: 500, body: {'message': 'x'});
      final setup = await pumpRegister(tester);
      await fillAndGoNext(tester);

      await tester.tap(find.text('send'));
      await tester.pumpAndSettle();

      final failure = setup.controller.reportsBloc.state;
      expect(failure, isA<NewReportsFailureState>());
      expect((failure as NewReportsFailureState).content.content, 'Barulho');
      expect(failure.report!.typeReport, 'COMPLAINT');
      expect(find.text('reports_create_error'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back_ios));
      await tester.pumpAndSettle();
      expect(find.byType(RegisterNewReportPage), findsOneWidget);
      final draft = setup.controller.reportsBloc.state as SendReportState;
      expect(draft.content.content, 'Barulho');
      expect(find.text('Barulho'), findsOneWidget);
      expect(find.text('Reclamações'), findsOneWidget);
    });

    testWidgets('voltar pelo sistema com a falha específica devolve o rascunho',
        (tester) async {
      final setup = await pumpRegister(tester);
      await fillAndGoNext(tester);
      await emitState(
        tester,
        setup.controller.reportsBloc,
        NewReportsFailureState(
            report: buildReport(id: null),
            content: buildContent(content: 'guardado'),
            failure: null),
      );
      expect(find.text('reports_create_error'), findsOneWidget);

      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      expect(await navigator.maybePop(), isTrue);
      await tester.pumpAndSettle();

      final draft = setup.controller.reportsBloc.state as SendReportState;
      expect(draft.content.content, 'guardado');
    });

    testWidgets('seta de voltar com a falha específica devolve o rascunho',
        (tester) async {
      final setup = await pumpRegister(tester);
      await fillAndGoNext(tester);
      await emitState(
        tester,
        setup.controller.reportsBloc,
        NewReportsFailureState(
            report: buildReport(id: null),
            content: buildContent(content: 'guardado'),
            failure: null),
      );

      await tester.tap(find.byIcon(Icons.arrow_back_ios));
      await tester.pumpAndSettle();

      final draft = setup.controller.reportsBloc.state as SendReportState;
      expect(draft.content.content, 'guardado');
      expect(find.text('guardado'), findsOneWidget);
    });

    testWidgets('loading e outros estados', (tester) async {
      final setup = await pumpRegister(tester);
      await fillAndGoNext(tester);

      await emitState(tester, setup.controller.reportsBloc,
          const ReportsLoadingState(), settle: false);
      await tester.pump();
      expect(find.byType(LoadingWidget), findsOneWidget);

      await emitState(tester, setup.controller.reportsBloc, const ReportsBookFirstState());
      expect(find.byType(LoadingWidget), findsNothing);
      expect(find.byType(ReportPreviewWidget), findsNothing);
    });
  });

  group('NewReportSuccessPage', () {
    Future<ReportsController> pumpSuccess(WidgetTester tester) async {
      final controller = harness.resolve<ReportsController>();
      await pumpPage(
        tester,
        const NewReportSuccessPage(),
        observer: observer,
        arguments: [controller],
        routes: routes,
        settle: false,
      );
      return controller;
    }

    testWidgets('loading, falha e outros estados', (tester) async {
      final controller = await pumpSuccess(tester);
      expect(find.byType(LoadingWidget), findsOneWidget);

      await emitState(tester, controller.reportsBloc, const ReportsFailureState());
      expect(find.text('reports_create_error'), findsOneWidget);

      await emitState(tester, controller.reportsBloc, const ReportsBookFirstState());
      expect(find.text('reports_create_error'), findsNothing);
      expect(find.byType(LoadingWidget), findsNothing);
    });

    testWidgets('voltar pelo sistema volta ao menu', (tester) async {
      final controller = await pumpSuccess(tester);
      await emitState(tester, controller.reportsBloc,
          ReportPostedState(report: buildReport()));

      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      expect(await navigator.maybePop(), isTrue);
      await tester.pumpAndSettle();

      expect(controller.reportsBloc.state, const ReportsBookFirstState());
    });
  });

  group('ReportsNewReportFailureAttachmentPage', () {
    Future<ControllerWithFakeUpload> pumpFailure(WidgetTester tester) async {
      final setup = await controllerWithFakeUpload(harness);
      final report = buildReport(numReport: '777', contents: [buildContent(id: 'c9')]);
      final content = buildContent();
      final attachment = tempPng();
      await pumpPage(
        tester,
        const ReportsNewReportFailureAttachmentPage(),
        observer: observer,
        arguments: ReportsNewReportFailureAttachmentPageArg(
          controller: setup.controller,
          report: report,
          content: content,
          attachment: attachment,
        ),
        routes: routes,
        settle: false,
      );
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
      expect(find.text('reports_report #777'), findsOneWidget);
      await expectLater(
        find.byType(ReportsNewReportFailureAttachmentPage),
        matchesGoldenFile('goldens/new_report_failure_attachment_page.png'),
      );

      await tester.tap(find.text('conclude'));
      await tester.pumpAndSettle();

      expect(reviewCalls, contains('isAvailable'));
      expect(setup.controller.reportsBloc.state, const ReportsBookFirstState());
      expect(find.byType(ReportsNewReportFailureAttachmentPage), findsNothing);
    });

    testWidgets('enquanto reenvia os botões ficam desabilitados', (tester) async {
      final setup = await pumpFailure(tester);
      await emitState(tester, setup.controller.reportsBloc,
          const ReportsLoadingState(), settle: false);
      await tester.pump();

      expect(find.text('resending'), findsOneWidget);
      final buttons = tester.widgetList<ElevatedButton>(find.byType(ElevatedButton));
      expect(buttons.every((b) => b.onPressed == null), isTrue);
    });

    testWidgets('tentar de novo com sucesso abre a tela de sucesso', (tester) async {
      final setup = await pumpFailure(tester);

      await tester.tap(find.text('try_again'));
      await tester.pumpAndSettle();

      expect(setup.upload.calls.single.contentId, 'c9');
      expect(find.byType(NewReportSuccessPage), findsOneWidget);
      expect(find.text('reports_report #777'), findsOneWidget);
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
