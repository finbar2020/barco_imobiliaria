import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:morar/feature/reports_book/presentation/bloc/reports_state.dart';
import 'package:morar/feature/reports_book/presentation/controller/reports_controller.dart';
import 'package:morar/feature/reports_book/presentation/pages/reports_my_reports/reports_my_report_details_page.dart';
import 'package:morar/feature/reports_book/presentation/widgets/load_pdf_by_link.dart';
import 'package:morar/feature/reports_book/presentation/widgets/report_details_widget.dart';
import 'package:morar/feature/reports_book/presentation/widgets/report_preview_widget.dart';

import '../../helpers/firebase_mocks.dart';
import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';
import 'reports_book_page_helpers.dart';

void main() {
  late PageHarness harness;
  late RecordingNavigatorObserver observer;
  late List<String> reviewCalls;

  setUp(() async {
    harness = await installPageHarness();
    observer = RecordingNavigatorObserver();
    reviewCalls = installFakeInAppReview();
    fakeAnalytics.reset();
  });

  ReportsController controller() => harness.resolve<ReportsController>();

  Future<void> pumpDetails(WidgetTester tester, {bool settle = true}) =>
      pumpPage(
        tester,
        const MyReportDetailsPage(),
        observer: observer,
        arguments: [controller(), buildReport()],
        settle: settle,
      );

  testWidgets('estado de loading mostra o indicador', (tester) async {
    await pumpDetails(tester, settle: false);

    expect(find.byType(LoadingWidget), findsOneWidget);
    expect(find.text('reports_report '), findsOneWidget);
  });

  testWidgets('busca os detalhes e mostra as mensagens com o botão de responder',
      (tester) async {
    harness.http.on('GET', reportPath('r1'), body: reportJson('r1', numReport: '101', contents: [
      contentJson('a', typeUser: 0, date: '2026-02-01T10:00:00'),
      contentJson('b', typeUser: 1, date: '2026-02-02T11:30:00'),
    ]));
    await pumpDetails(tester, settle: false);
    await emitState(tester, controller().reportsBloc,
        ReportsLoadedState(allReports: [buildReport()]), settle: false);
    await controller().getReport(report: buildReport());
    await tester.pumpAndSettle();

    expect(find.text('reports_report #101'), findsOneWidget);
    expect(find.text('reports_type_complaint'), findsOneWidget);
    expect(find.byType(ReportDetailsWidget), findsNWidgets(2));
    expect(find.text('reports_your_reply'), findsOneWidget);
    expect(find.text('reports_manager_reply'), findsOneWidget);
    expect(find.text('01/02/2026 - 10h:00m'), findsOneWidget);
    expect(find.text('reply'), findsOneWidget);
    expect(find.text('back'), findsOneWidget);
    await expectLater(
      find.byType(MyReportDetailsPage),
      matchesGoldenFile('goldens/my_report_details_page.png'),
    );

    // Responder prepara o rascunho e abre a tela de resposta.
    await tester.tap(find.text('reply'));
    await tester.pumpAndSettle();
    expect(observer.pushedNames.last, ApplicationRoute.myReportReply);
    expect((observer.pushed.last.settings.arguments as List).single, same(controller()));
    final state = controller().reportsBloc.state as SendReportState;
    expect(state.report!.idReport, 'r1');
    expect(state.content.typeUser, 0);
    expect(fakeAnalytics.eventNames, contains('ocorrencias_minhas_responder'));
  });

  testWidgets('ocorrência sem mensagens mostra o aviso', (tester) async {
    await pumpDetails(tester, settle: false);
    await emitState(tester, controller().reportsBloc,
        SeeReportDetailsState(report: buildReport(contents: [])));

    expect(find.text('reports_no_content'), findsOneWidget);
    expect(find.byType(ReportDetailsWidget), findsNothing);
  });

  testWidgets('ocorrência encerrada não tem botão de responder e voltar pede avaliação',
      (tester) async {
    harness.http.on('GET', allReportsPath, body: []);
    await pumpDetails(tester, settle: false);
    await emitState(tester, controller().reportsBloc,
        SeeReportDetailsState(report: buildReport(closed: true, newMessage: true)));

    expect(find.text('reply'), findsNothing);
    await tester.tap(find.text('back'));
    await tester.pumpAndSettle();

    expect(reviewCalls, contains('isAvailable'));
    expect(harness.http.requests.single.url.path, allReportsPath);
    expect(find.byType(MyReportDetailsPage), findsNothing);
  });

  testWidgets('seta de voltar recarrega a lista sem pedir avaliação',
      (tester) async {
    harness.http.on('GET', allReportsPath, body: []);
    await pumpDetails(tester, settle: false);
    await emitState(tester, controller().reportsBloc,
        SeeReportDetailsState(report: buildReport()));

    await tester.tap(find.byIcon(Icons.arrow_back_ios));
    await tester.pumpAndSettle();

    expect(reviewCalls, isEmpty);
    expect(harness.http.requests.single.url.path, allReportsPath);
    expect(find.byType(MyReportDetailsPage), findsNothing);
  });

  testWidgets('voltar pelo sistema com ocorrência encerrada pede avaliação',
      (tester) async {
    harness.http.on('GET', allReportsPath, body: []);
    await pumpDetails(tester, settle: false);
    await emitState(tester, controller().reportsBloc,
        SeeReportDetailsState(report: buildReport(closed: true, newMessage: true)));

    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    await navigator.maybePop();
    await tester.pumpAndSettle();

    expect(reviewCalls, contains('isAvailable'));
    expect(find.byType(MyReportDetailsPage), findsNothing);
  });

  /// Corrigido: a falha ao buscar a ocorrência chega à tela como
  /// `ReportsGetReportFailureState` carregando `report` (sem o
  /// `ReportsFailureState` genérico em seguida) e
  /// `ReportsController.getReport` também busca a partir desse estado, então
  /// o "tentar novamente" da tela de detalhes refaz a busca.
  testWidgets('falha ao buscar mostra o erro e o retry refaz a busca',
      (tester) async {
    harness.http.on('GET', reportPath('r1'), status: 500, body: {'message': 'x'});
    await pumpDetails(tester, settle: false);
    await emitState(tester, controller().reportsBloc,
        ReportsLoadedState(allReports: [buildReport()]), settle: false);
    await controller().getReport(report: buildReport());
    await tester.pumpAndSettle();

    final state = controller().reportsBloc.state;
    expect(state, isA<ReportsGetReportFailureState>());
    expect(state.report?.idReport, 'r1');
    expect(find.text('reports_report #101'), findsOneWidget);
    expect(find.byType(ErrorHandlingWidget), findsOneWidget);

    // Retry com a API ainda falhando: refaz a busca e continua no erro.
    harness.http.requests.clear();
    await tester.tap(find.text('error_handling_widget_button_reTry').first);
    await tester.pumpAndSettle();
    expect(harness.http.requests.map((r) => r.url.path), [reportPath('r1')]);
    expect(controller().reportsBloc.state, isA<ReportsGetReportFailureState>());
    expect(find.byType(ErrorHandlingWidget), findsOneWidget);

    // Retry com a API de volta: mostra os detalhes.
    harness.http.on('GET', reportPath('r1'),
        body: reportJson('r1', numReport: '101', contents: [contentJson('a')]));
    await tester.tap(find.text('error_handling_widget_button_reTry').first);
    await tester.pumpAndSettle();
    expect(controller().reportsBloc.state, isA<SeeReportDetailsState>());
    expect(find.byType(ErrorHandlingWidget), findsNothing);
    expect(find.byType(ReportDetailsWidget), findsOneWidget);
  });

  testWidgets('falha ao buscar: voltar pela tela de erro fecha a página',
      (tester) async {
    harness.http.on('GET', reportPath('r1'), status: 500, body: {'message': 'x'});
    await pumpDetails(tester, settle: false);
    await emitState(tester, controller().reportsBloc,
        ReportsLoadedState(allReports: [buildReport()]), settle: false);
    await controller().getReport(report: buildReport());
    await tester.pumpAndSettle();
    expect(find.byType(ErrorHandlingWidget), findsOneWidget);

    await tester.tap(find.text('back_to_the_previous_page').first);
    await tester.pumpAndSettle();
    expect(find.byType(MyReportDetailsPage), findsNothing);
  });

  testWidgets('outros estados deixam o corpo vazio', (tester) async {
    await pumpDetails(tester, settle: false);
    await emitState(tester, controller().reportsBloc,
        ReportsLoadedState(allReports: [buildReport()]));

    expect(find.byType(LoadingWidget), findsNothing);
    expect(find.byType(ReportDetailsWidget), findsNothing);
  });

  group('ReportDetailsWidget', () {
    testWidgets('anexo de imagem abre a tela de detalhe e fecha ao tocar',
        (tester) async {
      await pumpApp(
        tester,
        ReportDetailsWidget(
          typeReport: 'reports_type_complaint',
          httpHeaders: const {'Authorization': 'x'},
          content: buildContent(
            typeUser: 1,
            attachment: 'foto.png',
            attachmentType: 'image/png',
            attachmentLink: 'http://localhost/foto.png',
          ),
        ),
        localized: true,
        shrinkWrap: false,
        settle: false,
      );

      expect(find.text('reports_attached_file'), findsOneWidget);
      expect(find.byType(CachedNetworkImage), findsOneWidget);
      await tester.tap(find.byType(CachedNetworkImage));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(DetailScreenLink), findsOneWidget);

      await tester.tap(find.byType(GestureDetector).first);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(DetailScreenLink), findsNothing);
    });

    testWidgets('anexo em pdf mostra o ícone de documento', (tester) async {
      await pumpApp(
        tester,
        ReportDetailsWidget(
          typeReport: 'reports_type_complaint',
          httpHeaders: null,
          content: buildContent(
            attachment: 'doc.pdf',
            attachmentType: 'application/pdf',
            attachmentLink: 'http://localhost/doc.pdf',
          ),
        ),
        localized: true,
        shrinkWrap: false,
      );

      expect(find.text('reports_attached_file'), findsOneWidget);
      expect(find.byType(SvgPicture), findsOneWidget);
      expect(find.byType(InkWell), findsOneWidget);
      expect(find.byType(ShowPDFWidget), findsNothing);
    });
  });
}
