import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:morar/feature/reports_book/domain/entity/report.dart';
import 'package:morar/feature/reports_book/presentation/bloc/reports_state.dart';
import 'package:morar/feature/reports_book/presentation/controller/reports_controller.dart';
import 'package:morar/feature/reports_book/presentation/pages/reports_my_reports/reports_my_reports_page.dart';
import 'package:morar/feature/reports_book/presentation/widgets/reports_card_widget.dart';

import '../../helpers/firebase_mocks.dart';
import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';
import 'reports_book_page_helpers.dart';

void main() {
  late PageHarness harness;
  late RecordingNavigatorObserver observer;

  setUp(() async {
    harness = await installPageHarness();
    observer = RecordingNavigatorObserver();
    fakeAnalytics.reset();
  });

  ReportsController controller() => harness.resolve<ReportsController>();

  Future<void> pumpMyReports(
    WidgetTester tester, {
    String? notificationContext,
    bool settle = true,
  }) =>
      pumpPage(
        tester,
        const MyReportsPage(),
        observer: observer,
        arguments: MyReportsPageArgs(
          controller: controller(),
          reportNotificationContext: notificationContext,
        ),
        settle: settle,
      );

  testWidgets('estado inicial de loading mostra o indicador', (tester) async {
    await pumpMyReports(tester, settle: false);

    expect(controller().reportsBloc.state, const ReportsLoadingState());
    expect(find.byType(LoadingWidget), findsOneWidget);
    expect(find.text('reports_my_reports'), findsOneWidget);
  });

  testWidgets('lista as ocorrências da unidade', (tester) async {
    harness.http.on('GET', allReportsPath, body: [
      reportJson('1', newMessage: true),
      reportJson('2', type: 'SUGGESTION', closed: true, public: false,
          date: '2026-01-01T10:00:00'),
      reportJson('3', type: 'OTHERS', contents: [], date: '2025-12-01T10:00:00'),
    ]);
    await pumpMyReports(tester, settle: false);
    await controller().getAllReports();
    await tester.pumpAndSettle();

    expect(find.byType(ReportsCardWidget), findsNWidgets(3));
    expect(find.text('reports_type_complaint'), findsOneWidget);
    expect(find.text('reports_type_suggestion'), findsOneWidget);
    expect(find.text('reports_type_others'), findsOneWidget);
    expect(find.text('#101  03/02/2026 14h:05m'), findsOneWidget);
    expect(find.text('reports_new_message'), findsOneWidget);
    expect(find.text('reports_public'), findsNWidgets(2));
    expect(find.text('reports_not_public'), findsOneWidget);
    // Corrigido: a coluna da situação no `ReportsCardWidget` é `Flexible`, e
    // mesmo as chaves cruas (longas) cabem com reticências em 400px.
    expect(tester.takeException(), isNull);
    expect(find.text('reports_situation_open'), findsNWidgets(2));
    expect(find.text('reports_situation_closed'), findsOneWidget);
    expect(find.text('reports_no_content'), findsOneWidget);
    expect(find.text('Mensagem c1'), findsOneWidget);
    await expectLater(
      find.byType(MyReportsPage),
      matchesGoldenFile('goldens/my_reports_page.png'),
    );
  });

  testWidgets('sem ocorrências mostra a mensagem de vazio', (tester) async {
    harness.http.on('GET', allReportsPath, body: []);
    await pumpMyReports(tester, settle: false);
    await controller().getAllReports();
    await tester.pumpAndSettle();

    expect(find.text('reports_no_reports'), findsOneWidget);
    expect(find.byType(ReportsCardWidget), findsNothing);
  });

  testWidgets('erro na api mostra o widget de erro e o retry recarrega',
      (tester) async {
    harness.http.failAll();
    await pumpMyReports(tester, settle: false);
    await controller().getAllReports();
    await tester.pumpAndSettle();
    expect(find.byType(ErrorHandlingWidget), findsOneWidget);

    harness.http.on('GET', allReportsPath, body: [reportJson('9')]);
    await tester.tap(find.text('error_handling_widget_button_reTry').first);
    await tester.pumpAndSettle();

    expect(find.byType(ReportsCardWidget), findsOneWidget);
    expect(harness.http.requests.length, 2);
  });

  testWidgets('botão de voltar do erro fecha a página', (tester) async {
    await pumpMyReports(tester, settle: false);
    await emitState(tester, controller().reportsBloc, const ReportsFailureState());

    await tester.tap(find.text('back_to_the_previous_page').first);
    await tester.pumpAndSettle();

    expect(find.byType(MyReportsPage), findsNothing);
    expect(observer.popped, hasLength(1));
  });

  testWidgets('tocar em uma ocorrência busca os detalhes e navega',
      (tester) async {
    harness.http.on('GET', allReportsPath, body: [reportJson('1'), reportJson('2', closed: true)]);
    harness.http.on('GET', reportPath('2'), body: reportJson('2', closed: true));
    await pumpMyReports(tester, settle: false);
    await controller().getAllReports();
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ReportsCardWidget).last);
    await tester.pumpAndSettle();

    expect(observer.pushedNames.last, ApplicationRoute.myReportDetails);
    final args = observer.pushed.last.settings.arguments as List;
    expect(args[0], same(controller()));
    expect((args[1] as Report).idReport, '2');
    expect(harness.http.requests.map((r) => r.url.path), contains(reportPath('2')));
    final state = controller().reportsBloc.state as SeeReportDetailsState;
    expect(state.report!.idReport, '2');
    expect(fakeAnalytics.eventNames, contains('ocorrencias_minhas_encerradas'));
  });

  testWidgets('ocorrência aberta registra o evento de analytics de abertas',
      (tester) async {
    harness.http.on('GET', allReportsPath, body: [reportJson('1')]);
    harness.http.on('GET', reportPath('1'), body: reportJson('1'));
    await pumpMyReports(tester, settle: false);
    await controller().getAllReports();
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ReportsCardWidget));
    await tester.pumpAndSettle();

    expect(fakeAnalytics.eventNames, contains('ocorrencias_minhas_abertas'));
  });

  testWidgets('contexto de notificação abre a ocorrência pelo número',
      (tester) async {
    harness.http.on('GET', allReportsPath, body: [reportJson('1'), reportJson('2')]);
    harness.http.on('GET', reportPath('2'), body: reportJson('2'));
    await pumpMyReports(tester, notificationContext: '102', settle: false);
    await controller().getAllReports();
    await tester.pumpAndSettle();

    expect(observer.pushedNames.last, ApplicationRoute.myReportDetails);
    final args = observer.pushed.last.settings.arguments as List;
    expect(args, hasLength(1));
    expect(harness.http.requests.map((r) => r.url.path), contains(reportPath('2')));
  });

  testWidgets('contexto de notificação também casa pelo parâmetro',
      (tester) async {
    harness.http.on('GET', allReportsPath, body: [reportJson('1'), reportJson('2')]);
    harness.http.on('GET', reportPath('1'), body: reportJson('1'));
    await pumpMyReports(tester, notificationContext: 'np1', settle: false);
    await controller().getAllReports();
    await tester.pumpAndSettle();

    expect(observer.pushedNames.last, ApplicationRoute.myReportDetails);
    expect(harness.http.requests.map((r) => r.url.path), contains(reportPath('1')));
  });

  /// Corrigido: `reports_my_reports_page.dart` (`_buildReports`) usa
  /// `firstWhere(..., orElse: () => null)`; quando o contexto da notificação
  /// não bate com nenhuma ocorrência ela é simplesmente ignorada.
  testWidgets('contexto de notificação desconhecido é ignorado',
      (tester) async {
    harness.http.on('GET', allReportsPath, body: [reportJson('1')]);
    await pumpMyReports(tester, notificationContext: 'nao-existe', settle: false);
    await controller().getAllReports();
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(observer.pushedNames, isNot(contains(ApplicationRoute.myReportDetails)));
    expect(find.byType(ReportsCardWidget), findsOneWidget);
    expect(harness.http.requests.map((r) => r.url.path), [allReportsPath]);
  });

  testWidgets('seta de voltar volta ao menu de ocorrências', (tester) async {
    harness.http.on('GET', allReportsPath, body: []);
    await pumpMyReports(tester, settle: false);
    await controller().getAllReports();
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.arrow_back_ios));
    await tester.pumpAndSettle();

    expect(controller().reportsBloc.state, const ReportsBookFirstState());
    expect(find.byType(MyReportsPage), findsNothing);
  });

  testWidgets('voltar pelo sistema volta ao menu de ocorrências',
      (tester) async {
    harness.http.on('GET', allReportsPath, body: []);
    await pumpMyReports(tester, settle: false);
    await controller().getAllReports();
    await tester.pumpAndSettle();

    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    expect(await navigator.maybePop(), isTrue);
    await tester.pumpAndSettle();

    expect(controller().reportsBloc.state, const ReportsBookFirstState());
    expect(find.byType(MyReportsPage), findsNothing);
  });

  testWidgets('outros estados deixam o corpo vazio', (tester) async {
    await pumpMyReports(tester, settle: false);
    await emitState(tester, controller().reportsBloc,
        SeeReportDetailsState(report: buildReport()));

    expect(find.byType(ReportsCardWidget), findsNothing);
    expect(find.byType(LoadingWidget), findsNothing);
  });

  group('ReportsCardWidget', () {
    testWidgets('cores da situação', (tester) async {
      await pumpApp(
        tester,
        ReportsCardWidget(report: buildReport(closed: true), index: '#1 '),
        localized: true,
        shrinkWrap: false,
      );
      final widget = tester.widget<ReportsCardWidget>(find.byType(ReportsCardWidget));
      final theme = LelloTheme.light;
      expect(widget.color(closed: true, theme: theme), LelloTheme.palleteOf(theme).success());
      expect(widget.color(closed: false, theme: theme), theme.primaryColor);
      expect(find.text('reports_situation_closed'), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_arrow_right), findsOneWidget);
    });

    testWidgets('ocorrência privada com nova mensagem e sem conteúdo',
        (tester) async {
      var taps = 0;
      await pumpApp(
        tester,
        ReportsCardWidget(
          report: buildReport(public: false, newMessage: true, contents: []),
          index: '#1 ',
          onTap: () => taps++,
        ),
        localized: true,
        shrinkWrap: false,
      );

      expect(find.text('reports_not_public'), findsOneWidget);
      expect(find.text('reports_new_message'), findsOneWidget);
      expect(find.text('reports_no_content'), findsOneWidget);
      await tester.tap(find.byType(InkWell).first);
      expect(taps, 1);
    });
  });
}
