import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_rbac.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:morar/feature/reports_book/domain/entity/report_option.dart';
import 'package:morar/feature/reports_book/presentation/bloc/reports_state.dart';
import 'package:morar/feature/reports_book/presentation/controller/reports_controller.dart';
import 'package:morar/feature/reports_book/presentation/pages/reports_my_reports/reports_my_reports_page.dart';
import 'package:morar/feature/reports_book/presentation/pages/reports_new_report/reports_register_new_report_page.dart';
import 'package:morar/feature/reports_book/presentation/pages/reports_page.dart';
import 'package:morar/feature/reports_book/presentation/widgets/reports_option_card_widget.dart';

import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';
import 'reports_book_page_helpers.dart';

void main() {
  late PageHarness harness;
  late RecordingNavigatorObserver observer;

  setUp(() async {
    harness = await installPageHarness();
    observer = RecordingNavigatorObserver();
  });

  ReportsController controller() => harness.resolve<ReportsController>();

  testWidgets('mostra as opções de ocorrências com condomínio e unidade',
      (tester) async {
    await pumpPage(tester, const ReportsPage(), observer: observer);

    expect(controller().reportsBloc.state, const ReportsBookFirstState());
    expect(find.text('reports_title'), findsOneWidget);
    expect(find.text('Edifício Lello - 101'), findsOneWidget);
    expect(find.text('reports_description'), findsOneWidget);
    expect(find.text('reports_my_reports'), findsOneWidget);
    expect(find.text('reports_register_new_report'), findsOneWidget);
    expect(find.byType(ReportsOptionCardWidget), findsNWidgets(2));
    expect(
      harness.sessionBloc.rbacChecked,
      containsAll([
        ApplicationRbac.morarOcorrenciasMinhasOcorrencias,
        ApplicationRbac.morarOcorrenciasNovaOcorrencia,
      ]),
    );
    await expectLater(
      find.byType(ReportsPage),
      matchesGoldenFile('goldens/reports_page.png'),
    );
  });

  testWidgets('sem rbac as opções ficam escondidas', (tester) async {
    harness.sessionBloc.rbacAllowed = false;

    await pumpPage(tester, const ReportsPage());

    expect(find.byType(ReportsOptionCardWidget), findsNothing);
  });

  testWidgets('"minhas ocorrências" busca a lista e abre a página',
      (tester) async {
    harness.http.on('GET', allReportsPath, body: [reportJson('1')]);

    await pumpPage(tester, const ReportsPage(), observer: observer);
    await tester.tap(find.text('reports_my_reports'));
    await tester.pumpAndSettle();

    expect(observer.pushedNames.last, ApplicationRoute.myReports);
    final route = observer.pushed.last;
    final args = route.settings.arguments as MyReportsPageArgs;
    expect(args.controller, same(controller()));
    expect(args.reportNotificationContext, isNull);
    expect(harness.http.requests.single.url.path, allReportsPath);
    expect(controller().reportsBloc.state, isA<ReportsLoadedState>());
  });

  testWidgets('"registrar nova ocorrência" prepara o rascunho e navega',
      (tester) async {
    await pumpPage(tester, const ReportsPage(), observer: observer);
    await tester.tap(find.text('reports_register_new_report'));
    await tester.pumpAndSettle();

    expect(observer.pushedNames.last, ApplicationRoute.registerNewReport);
    final args =
        observer.pushed.last.settings.arguments as RegisterNewReportPageArgs;
    expect(args.controller, same(controller()));
    expect(args.isSucess, isFalse);
    final state = controller().reportsBloc.state as SendReportState;
    expect(state.report!.idReport, isNull);
    expect(state.content.typeUser, 0);
  });

  testWidgets('contexto de notificação abre "minhas ocorrências" sozinho',
      (tester) async {
    harness.http.on('GET', allReportsPath, body: [reportJson('1')]);

    await pumpPage(
      tester,
      const ReportsPage(),
      observer: observer,
      arguments: ReportsPageArgs(reportNotificationContext: 'np1'),
    );

    expect(observer.pushedNames.last, ApplicationRoute.myReports);
    final args =
        observer.pushed.last.settings.arguments as MyReportsPageArgs;
    expect(args.reportNotificationContext, 'np1');
    expect(harness.http.requests.single.url.path, allReportsPath);
    // O contexto é consumido: voltar não dispara de novo.
    final pageArgs = ModalRoute.of(
            tester.element(find.byType(ReportsPage, skipOffstage: false)))!
        .settings
        .arguments as ReportsPageArgs;
    expect(pageArgs.reportNotificationContext, isNull);
  });

  testWidgets('estado de loading mostra o indicador', (tester) async {
    await pumpPage(tester, const ReportsPage(), settle: false);

    await emitState(tester, controller().reportsBloc,
        const ReportsLoadingState(), settle: false);

    expect(find.byType(LoadingWidget), findsOneWidget);
  });

  testWidgets('estado de falha mostra a mensagem de erro', (tester) async {
    await pumpPage(tester, const ReportsPage());

    await emitState(tester, controller().reportsBloc, const ReportsFailureState());

    expect(find.text('reports_error'), findsOneWidget);
    expect(find.byType(ReportsOptionCardWidget), findsNothing);
  });

  testWidgets('outros estados deixam o corpo vazio', (tester) async {
    await pumpPage(tester, const ReportsPage());

    await emitState(tester, controller().reportsBloc,
        ReportsLoadedState(allReports: [buildReport()]));

    expect(find.byType(ReportsOptionCardWidget), findsNothing);
    expect(find.text('reports_error'), findsNothing);
  });

  testWidgets('voltar pelo sistema é permitido', (tester) async {
    await pumpPage(tester, const ReportsPage(), observer: observer);

    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    final popped = await navigator.maybePop();
    await tester.pumpAndSettle();

    // O WillPopScope libera o pop: volta para a rota inicial ('/').
    expect(popped, isTrue);
    expect(find.byType(ReportsPage), findsNothing);
    expect(findRoute('/'), findsOneWidget);
  });

  testWidgets('card de opção mostra o indicador de novas mensagens',
      (tester) async {
    var taps = 0;
    await pumpApp(
      tester,
      ReportsOptionCardWidget(
        reportOption: ReportOption(
          title: 'Minhas ocorrências',
          assetImage: 'assets/ic_my_reports.svg',
          newMessages: true,
          onTap: () => taps++,
        ),
      ),
      shrinkWrap: false,
    );

    await tester.tap(find.text('Minhas ocorrências'));
    expect(taps, 1);
    final dots = find.byWidgetPredicate((w) =>
        w is Container &&
        w.decoration is BoxDecoration &&
        (w.decoration as BoxDecoration).shape == BoxShape.circle);
    expect(dots, findsOneWidget);
  });
}
