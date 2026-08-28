import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_created.dart';
import 'package:morar/feature/agreements/presentation/bloc/agreements_bloc.dart';
import 'package:morar/feature/agreements/presentation/bloc/agreements_state.dart';
import 'package:morar/feature/agreements/presentation/pages/agreements_details_page.dart';

import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';
import 'agreements_test_support.dart';

void main() {
  late PageHarness harness;
  late RecordingNavigatorObserver observer;
  late AgreementsBloc bloc;
  late AgreementCreated created;

  setUp(() async {
    harness = await installPageHarness();
    observer = RecordingNavigatorObserver();
    harness.sessionBloc.session.condominium!.reference = '77';
    created = AgreementCreated(totalValue: 300);
  });

  Future<void> pumpDetails(WidgetTester tester, {Map<String, dynamic>? detail}) async {
    stubAgreementsApi(harness.http);
    harness.http.on(
      'GET',
      detailsPath('a1'),
      body: detail ??
          agreementJson(
            'a1',
            status: 'completed',
            lastInstallmentDate: '2026-06-01T00:00:00',
            quotes: [quotaJson('q1'), quotaJson('q2', dueDate: '2026-02-10T00:00:00')],
            installments: [
              installmentJson(id: 'i1', status: 'paid'),
              installmentJson(id: 'i2', status: 'pending'),
              installmentJson(id: 'i3', status: 'calceled'),
            ],
          ),
    );
    bloc = harness.resolve<AgreementsBloc>();
    await pumpAgreementsStack(
      tester,
      [
        const RouteStep('/agreements'),
        RouteStep(ApplicationRoute.agreementDetail, arguments: [bloc, created]),
      ],
      routes: onlyRoute(ApplicationRoute.agreementDetail),
      observer: observer,
      surface: const Size(600, 1600),
    );
  }

  testWidgets('loading, erro e estado não tratado', (tester) async {
    await pumpDetails(tester);
    expect(find.text('agreements_in_progress_title'), findsOneWidget);

    await emitState(tester, bloc, const AgreementsLoadingState(), settle: false);
    await tester.pump();
    expect(find.byType(LoadingWidget), findsOneWidget);

    await emitState(tester, bloc, const AgreementsErrorState(errorMessageKey: 'erro_z'));
    expect(find.text('erro_z'), findsOneWidget);

    await emitState(tester, bloc, const AgreementsInitialState());
    expect(find.text('erro_z'), findsNothing);
    expect(find.byType(LoadingWidget), findsNothing);
  });

  testWidgets('mostra as cotas e as parcelas do acordo (golden)', (tester) async {
    await pumpDetails(tester);
    bloc.getDetails(agreementId: 'a1');
    await tester.pumpAndSettle();

    expect(harness.http.requests.map((r) => r.url.path), contains(detailsPath('a1')));
    expect(find.text('101 - Ana'), findsOneWidget);
    expect(find.text('agreements_quota 1 -  10/01/2026'), findsOneWidget);
    expect(find.text('agreements_quota 2 -  10/02/2026'), findsOneWidget);
    expect(find.text('AGREEMENTS_ORIGINAL_VALUE'), findsNWidgets(2));
    expect(find.text('income_billet_detail_billet'), findsNWidgets(2));
    expect(find.text('[2X] ${NumberFormat.currency(symbol: 'R\$').format(60)}'), findsNWidgets(2));
    // novo vencimento usa a data da última parcela quando existe
    expect(find.text('01/06/2026'), findsNWidgets(2));
    expect(find.byType(Divider), findsNWidgets(3)); // 2 entre cotas + 1 separador
    expect(find.text('agreements_installments'), findsOneWidget);
    expect(find.textContaining('1 - income_billet_detail_situation_paid_out'), findsOneWidget);
    expect(find.textContaining('2 - space_reserved_waiting'), findsOneWidget);
    expect(find.textContaining('3 - income_billet_detail_situation_canceled'), findsOneWidget);

    await expectLater(
      find.byType(AgreementsDetailsPage),
      matchesGoldenFile('goldens/agreements_details_page.png'),
    );
  });

  testWidgets('com uma cota só não desenha divisor entre cotas', (tester) async {
    await pumpDetails(
      tester,
      detail: agreementJson('a1', status: 'completed', paymentMethod: 'credit'),
    );
    bloc.getDetails(agreementId: 'a1');
    await tester.pumpAndSettle();

    expect(find.byType(Divider), findsOneWidget);
    expect(find.text('agreements_credit'), findsOneWidget);
  });

  testWidgets('voltar pela app bar volta para acordos sem recarregar', (tester) async {
    await pumpDetails(tester);
    bloc.getDetails(agreementId: 'a1');
    await tester.pumpAndSettle();
    final before = harness.http.requests.where((r) => r.url.path == allInfoPath).length;

    await tester.tap(find.byIcon(Icons.arrow_back_ios));
    await tester.pumpAndSettle();

    expect(findRoute('/agreements'), findsOneWidget);
    expect(find.byType(AgreementsDetailsPage), findsNothing);
    expect(bloc.state, isA<AgreementsQuotaAvailableLoadedState>());
    expect(harness.http.requests.where((r) => r.url.path == allInfoPath).length, before);
    expect(created.totalValue, 0);
  });

  testWidgets('voltar pelo sistema volta para acordos', (tester) async {
    await pumpDetails(tester);

    await systemBack(tester);

    expect(findRoute('/agreements'), findsOneWidget);
    expect(find.byType(AgreementsDetailsPage), findsNothing);
  });
}
