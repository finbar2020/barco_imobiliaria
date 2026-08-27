import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/agreements/domain/entity/agreement.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_created.dart';
import 'package:morar/feature/agreements/presentation/bloc/agreements_bloc.dart';
import 'package:morar/feature/agreements/presentation/pages/agreements_billet_page.dart';

import '../../helpers/firebase_mocks.dart';
import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';
import 'agreements_test_support.dart';

void main() {
  late PageHarness harness;
  late RecordingNavigatorObserver observer;
  late AgreementsBloc bloc;
  late AgreementCreated created;
  late FakeUrlLauncher launcher;

  setUp(() async {
    harness = await installPageHarness();
    observer = RecordingNavigatorObserver();
    harness.sessionBloc.session.condominium!.reference = '77';
    fakeAnalytics.reset();
    launcher = installFakeUrlLauncher();
    mockClipboard();
    created = AgreementCreated(totalValue: 300, receiptList: ['rec1']);
  });

  Future<void> pumpBillet(
    WidgetTester tester, {
    bool creditCard = false,
    Agreement? agreement,
  }) async {
    stubAgreementsApi(harness.http);
    bloc = harness.resolve<AgreementsBloc>();
    await pumpAgreementsStack(
      tester,
      [
        const RouteStep('/agreements'),
        RouteStep(ApplicationRoute.agreementBillet, arguments: [
          bloc,
          creditCard,
          created,
          agreement ?? testAgreement(status: 'approved_by_manager'),
        ]),
      ],
      routes: onlyRoute(ApplicationRoute.agreementBillet),
      observer: observer,
    );
  }

  testWidgets('mostra condomínio, unidade e valor do boleto', (tester) async {
    await pumpBillet(tester);

    expect(find.text('income_billet_detail_billet'), findsOneWidget);
    expect(find.text('Edifício Lello'), findsOneWidget);
    expect(find.text('non_payments_item_title 101'), findsOneWidget);
    expect(find.text('agreements_billet'), findsOneWidget);
    expect(find.textContaining('300'), findsOneWidget);
    expect(find.text('agreement_billet_info_digital'), findsNothing);
    expect(find.text('agreement_go_to_pay'), findsNothing);
    expect(find.text('agreement_billet_view'), findsOneWidget);
    expect(find.text('billet_copy_barcode'), findsOneWidget);
    expect(find.text('conclude'), findsOneWidget);
    await expectLater(
      find.byType(AgreementsBilletPage),
      matchesGoldenFile('goldens/agreements_billet_page.png'),
    );
  });

  testWidgets('copiar código de barras avisa e loga o evento', (tester) async {
    await pumpBillet(tester);

    await tester.tap(find.text('billet_copy_barcode'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(Flushbar), findsOneWidget);
    expect(find.text('billet_copied_barcode'), findsOneWidget);
    expect(fakeAnalytics.events.keys, contains('acordos_copiar_codigo_de_barras'));
    await settleFlushbar(tester);
    expect(find.byType(Flushbar), findsNothing);
  });

  testWidgets('visualizar boleto sem parcela pendente mostra erro', (tester) async {
    await pumpBillet(
      tester,
      agreement: testAgreement(
        status: 'approved_by_manager',
        installments: [testInstallment(status: 'paid')],
      ),
    );

    await tester.tap(find.text('agreement_billet_view'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('request_fine_error_message'), findsOneWidget);
    expect(fakeAnalytics.events.keys, contains('acordos_visualizar_boleto'));
    await settleFlushbar(tester);
  });

  testWidgets('cartão: mostra o aviso digital e abre o link de pagamento', (tester) async {
    await pumpBillet(
      tester,
      creditCard: true,
      agreement: testAgreement(
        status: 'approved_by_manager',
        installments: [testInstallment(paymentLink: 'https://pay.example/abc')],
      ),
    );

    expect(find.text('agreement_billet_info_digital'), findsOneWidget);
    await tester.tap(find.text('agreement_go_to_pay'));
    await tester.pumpAndSettle();

    expect(launcher.launched, ['https://pay.example/abc']);
    expect(fakeAnalytics.events.keys, contains('acordos_acessar_site_parceiro_vamos_parcelar'));
  });

  testWidgets('concluir volta para acordos recarregando as cotas', (tester) async {
    await pumpBillet(tester);
    final before = harness.http.requests.where((r) => r.url.path == allInfoPath).length;

    await tester.tap(find.text('conclude'));
    await tester.pumpAndSettle();

    expect(findRoute('/agreements'), findsOneWidget);
    expect(find.byType(AgreementsBilletPage), findsNothing);
    expect(created.totalValue, 0);
    expect(harness.http.requests.where((r) => r.url.path == allInfoPath).length, before + 1);
  });

  testWidgets('voltar pelo sistema volta para acordos', (tester) async {
    await pumpBillet(tester);

    await systemBack(tester);

    expect(findRoute('/agreements'), findsOneWidget);
    expect(find.byType(AgreementsBilletPage), findsNothing);
  });
}
