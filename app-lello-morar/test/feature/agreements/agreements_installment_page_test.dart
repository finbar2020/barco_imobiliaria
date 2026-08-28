import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_created.dart';
import 'package:morar/feature/agreements/presentation/bloc/agreements_bloc.dart';
import 'package:morar/feature/agreements/presentation/bloc/agreements_state.dart';
import 'package:morar/feature/agreements/presentation/pages/agreements_installment_page.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreement_installments_option.dart';

import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';
import 'agreements_test_support.dart';

void main() {
  late PageHarness harness;
  late RecordingNavigatorObserver observer;
  late AgreementsBloc bloc;
  late AgreementCreated agreement;

  setUp(() async {
    harness = await installPageHarness();
    observer = RecordingNavigatorObserver();
    harness.sessionBloc.session.condominium!.reference = '77';
    agreement = AgreementCreated(totalValue: 300, paymentMethod: 0);
  });

  Future<void> pumpInstallment(WidgetTester tester, {bool load = true}) async {
    stubAgreementsApi(harness.http);
    bloc = harness.resolve<AgreementsBloc>();
    await pumpAgreementsStack(
      tester,
      [
        const RouteStep('/agreements'),
        const RouteStep('/agreements_choice_payment'),
        RouteStep(ApplicationRoute.agreementInstallment, arguments: [bloc, agreement]),
      ],
      routes: onlyRoute(ApplicationRoute.agreementInstallment),
      observer: observer,
      locOverrides: stepOverrides,
    );
    if (load) {
      bloc.getInstallments(300);
      await tester.pumpAndSettle();
    }
  }

  testWidgets('loading e erro', (tester) async {
    await pumpInstallment(tester, load: false);

    expect(find.text('agreements_installments'), findsOneWidget);
    expect(find.text('Etapa 2 de 3'), findsOneWidget);
    expect(find.text('agreement_tax_credit_info'), findsOneWidget);

    await emitState(tester, bloc, const AgreementsLoadingState(), settle: false);
    await tester.pump();
    expect(find.byType(LoadingWidget), findsOneWidget);

    await emitState(tester, bloc, const AgreementsErrorState(errorMessageKey: 'erro_w'));
    expect(find.text('erro_w'), findsOneWidget);
  });

  testWidgets('lista as opções de parcelamento com e sem taxas', (tester) async {
    await pumpInstallment(tester);

    expect(find.byType(AgreementInstallmentsOption), findsNWidgets(2));
    expect(find.text('[1x] R\$ 300.0'), findsOneWidget);
    expect(find.text('[2x] R\$ 150.0'), findsOneWidget);
    expect(find.text('agreement_card_tax'), findsOneWidget);
    expect(find.textContaining('agreement_installment_tax'), findsOneWidget);
    expect(find.textContaining('(1,5%)'), findsOneWidget);
    expect(harness.http.requests.map((r) => r.url.path), contains(installmentCreditPath));
  });

  testWidgets('próximo busca os dias e abre o dia de pagamento (cartão)', (tester) async {
    await pumpInstallment(tester);

    await tester.tap(find.text('next'));
    await tester.pumpAndSettle();

    expect(observer.pushedNames.last, ApplicationRoute.agreementDayPayment);
    expect(observer.pushed.last.settings.arguments, [bloc, agreement, false, true]);
    expect(harness.http.requests.map((r) => r.url.path), contains(rulePath));
  });

  testWidgets('voltar pela app bar volta para a escolha', (tester) async {
    await pumpInstallment(tester);

    await tester.tap(find.byIcon(Icons.arrow_back_ios));
    await tester.pumpAndSettle();

    expect(findRoute('/agreements_choice_payment'), findsOneWidget);
    expect(find.byType(AgreementsInstallmentPage), findsNothing);
    expect(bloc.state, isA<AgreementsChoiceLoadedState>());
  });

  testWidgets('voltar pelo sistema volta para a escolha', (tester) async {
    await pumpInstallment(tester);

    await systemBack(tester);

    expect(findRoute('/agreements_choice_payment'), findsOneWidget);
    expect(find.byType(AgreementsInstallmentPage), findsNothing);
  });
}
