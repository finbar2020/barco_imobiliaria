import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_created.dart';
import 'package:morar/feature/agreements/presentation/bloc/agreements_bloc.dart';
import 'package:morar/feature/agreements/presentation/bloc/agreements_state.dart';
import 'package:morar/feature/agreements/presentation/pages/agreements_recommendation_payment_page.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreement_installments_bottom_sheet.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreement_resume_bottom_sheet.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreements_recommendation_card.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreements_recommendation_syndic_card.dart';

import '../../helpers/firebase_mocks.dart';
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
    fakeAnalytics.reset();
    agreement = AgreementCreated(totalValue: 300, receiptList: ['rec1'], paymentMethod: 1);
  });

  Future<void> pumpRecommendation(
    WidgetTester tester, {
    bool load = true,
    List<Map<String, dynamic>>? recommendations,
    Map<String, dynamic>? posted,
  }) async {
    stubAgreementsApi(harness.http, recommendations: recommendations, posted: posted);
    bloc = harness.resolve<AgreementsBloc>();
    await pumpAgreementsStack(
      tester,
      [
        const RouteStep('/agreements'),
        const RouteStep('/agreements_choice_payment'),
        RouteStep(ApplicationRoute.agreementsRecommendationPayment,
            arguments: [bloc, agreement, false]),
      ],
      routes: onlyRoute(ApplicationRoute.agreementsRecommendationPayment),
      observer: observer,
      locOverrides: stepOverrides,
    );
    if (load) {
      bloc.getRecommendation();
      await tester.pumpAndSettle();
    }
  }

  testWidgets('loading e erro', (tester) async {
    await pumpRecommendation(tester, load: false);

    await emitState(tester, bloc, const AgreementsLoadingState(), settle: false);
    await tester.pump();
    expect(find.byType(LoadingWidget), findsOneWidget);

    await emitState(tester, bloc, const AgreementsErrorState(errorMessageKey: 'erro_x'));
    expect(find.text('erro_x'), findsOneWidget);
    expect(find.byType(LoadingWidget), findsNothing);
  });

  testWidgets('mostra a opção indicada e as outras opções', (tester) async {
    await pumpRecommendation(tester);

    expect(find.text('Etapa 2 de 3'), findsOneWidget);
    expect(find.text('payment_options'), findsOneWidget);
    expect(find.text('indicated_payment_condo'), findsOneWidget);
    expect(find.byType(AgreementsRecommendationCard), findsOneWidget);
    expect(find.textContaining('[3X]'), findsOneWidget);
    expect(find.text('10'), findsOneWidget);
    expect(find.byType(AgreementsRecommendationSyndicCard), findsNWidgets(2));
    expect(find.textContaining('[1X]'), findsOneWidget);
    expect(find.textContaining('[2X]'), findsOneWidget);
    expect(harness.http.requests.map((r) => r.url.path), contains(recommendationPath));
  });

  testWidgets('opção indicada abre o resumo e finaliza gerando o boleto', (tester) async {
    await pumpRecommendation(tester);

    await tester.tap(find.byType(AgreementsRecommendationCard));
    await tester.pumpAndSettle();

    expect(find.byType(AgreementResumeBottomSheet), findsOneWidget);
    expect(find.text('agreements_resume'), findsOneWidget);
    expect(find.text('1'), findsOneWidget); // 1 cota
    expect(find.text('income_billet_detail_billet'), findsWidgets);
    expect(find.textContaining('agreements_value_installment [3x]'), findsOneWidget);
    expect(agreement.installmentQuantity, 3);
    expect(agreement.dueDate, 10);
    expect(fakeAnalytics.events.keys, contains('acordos_escolher_opcoes_de_pagamento_mais_indicada'));

    await tester.tap(find.text('agreements_end'));
    await tester.pumpAndSettle();

    expect(find.byType(AgreementResumeBottomSheet), findsNothing);
    expect(observer.pushedNames.last, ApplicationRoute.agreementBillet);
    final args = observer.pushed.last.settings.arguments as List;
    expect(args[0], bloc);
    expect(args[1], isFalse);
    expect(args[2], agreement);
    expect(bloc.state, isA<PostAgreementLoadedState>());
    expect(fakeAnalytics.events['acordos_finalizar_acordo_sucesso']!['parcelas'], '3');
  });

  testWidgets('resumo pode ser fechado pela seta', (tester) async {
    await pumpRecommendation(tester);

    await tester.tap(find.byType(AgreementsRecommendationCard));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
    await tester.pumpAndSettle();

    expect(find.byType(AgreementResumeBottomSheet), findsNothing);
  });

  testWidgets('outra opção à vista abre o resumo; proposta pendente vai para sucesso', (tester) async {
    await pumpRecommendation(tester, posted: agreementJson('novo', status: 'pending'));

    await tester.tap(find.textContaining('[1X]'));
    await tester.pumpAndSettle();

    expect(find.byType(AgreementResumeBottomSheet), findsOneWidget);
    expect(agreement.installmentQuantity, 1);
    expect(agreement.dueDate, DateTime.now().add(const Duration(days: 3)).day);
    expect(fakeAnalytics.events.keys, contains('acordos_escolher_outras_opcoes_de_pagamento'));

    await tester.tap(find.text('agreements_end'));
    await tester.pumpAndSettle();

    expect(observer.pushedNames.last, ApplicationRoute.agreementSuccessSend);
    expect(observer.pushed.last.settings.arguments, [bloc]);
  });

  testWidgets('outra opção parcelada vai escolher o dia de pagamento', (tester) async {
    await pumpRecommendation(tester);

    await tester.tap(find.textContaining('[2X]'));
    await tester.pumpAndSettle();

    expect(agreement.installmentQuantity, 2);
    expect(observer.pushedNames.last, ApplicationRoute.agreementDayPayment);
    expect(observer.pushed.last.settings.arguments, [bloc, agreement]);
    expect(harness.http.requests.map((r) => r.url.path), contains(rulePath));
  });

  testWidgets('personalizar abre o slider de parcelas e segue para o dia', (tester) async {
    await pumpRecommendation(tester);

    await tester.tap(find.text('button_want_customize_agreements'));
    await tester.pumpAndSettle();

    expect(find.byType(AgreementInstallmentsBottomSheet), findsOneWidget);
    expect(find.text('agreements_liked_installments'), findsOneWidget);
    // mínimo = maior quantidade de parcelas das opções (3) até 12
    expect(find.text('3x'), findsOneWidget);
    expect(find.text('12x'), findsOneWidget);
    expect(fakeAnalytics.events.keys, contains('acordos_escolher_personalizar_acordo'));

    final slider = tester.widget<Slider>(find.byType(Slider));
    expect(slider.min, 3);
    expect(slider.max, 12);
    await tester.drag(find.byType(Slider), const Offset(600, 0));
    await tester.pumpAndSettle();
    expect(tester.widget<Slider>(find.byType(Slider)).value, 12);

    await tester.tap(find.text('agreements_accept_next'));
    await tester.pumpAndSettle();

    expect(find.byType(AgreementInstallmentsBottomSheet), findsNothing);
    expect(agreement.installmentQuantity, 12);
    expect(observer.pushedNames.last, ApplicationRoute.agreementDayPayment);
    expect(observer.pushed.last.settings.arguments, [bloc, agreement, true]);
  });

  testWidgets('slider de parcelas fecha pela seta', (tester) async {
    await pumpRecommendation(tester);

    await tester.tap(find.text('button_want_customize_agreements'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
    await tester.pumpAndSettle();

    expect(find.byType(AgreementInstallmentsBottomSheet), findsNothing);
  });

  testWidgets('voltar pela app bar e pelo sistema volta para a escolha', (tester) async {
    await pumpRecommendation(tester);

    await tester.tap(find.byIcon(Icons.arrow_back_ios));
    await tester.pumpAndSettle();
    expect(findRoute('/agreements_choice_payment'), findsOneWidget);
    expect(find.byType(AgreementsRecommendationPaymentPage), findsNothing);
    expect(bloc.state, isA<AgreementsChoiceLoadedState>());
  });

  testWidgets('voltar pelo sistema volta para a escolha', (tester) async {
    await pumpRecommendation(tester);

    await systemBack(tester);

    expect(findRoute('/agreements_choice_payment'), findsOneWidget);
    expect(find.byType(AgreementsRecommendationPaymentPage), findsNothing);
  });
}
