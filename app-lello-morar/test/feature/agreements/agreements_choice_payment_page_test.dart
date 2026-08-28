import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/white_app_bar.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_created.dart';
import 'package:morar/feature/agreements/domain/entity/agreements_payment_method_enum.dart';
import 'package:morar/feature/agreements/presentation/bloc/agreements_bloc.dart';
import 'package:morar/feature/agreements/presentation/pages/agreements_choice_payment_page.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreement_options_card.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreement_options_payment_bottom_sheet.dart';
import 'package:morar/feature/me/presentation/pages/me_page.dart';

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
    agreement = AgreementCreated(totalValue: 300, receiptList: ['rec1']);
  });

  /// Empilha acordos (stub) + página de escolha (real) e deixa o bloc no
  /// estado de escolha.
  Future<void> pumpChoice(
    WidgetTester tester, {
    bool loadChoice = true,
    Size surface = const Size(600, 1000),
  }) async {
    stubAgreementsApi(harness.http);
    bloc = harness.resolve<AgreementsBloc>();
    await pumpAgreementsStack(
      tester,
      [
        const RouteStep('/agreements'),
        RouteStep(ApplicationRoute.agreementsChoicePayment,
            arguments: [bloc, agreement]),
      ],
      routes: onlyRoute(ApplicationRoute.agreementsChoicePayment),
      observer: observer,
      surface: surface,
      locOverrides: stepOverrides,
    );
    if (loadChoice) {
      bloc.getChoicePayment();
      await tester.pumpAndSettle();
    }
  }

  IgnorePointer nextIgnore(WidgetTester tester) => tester.widget<IgnorePointer>(
        find.ancestor(of: find.text('next'), matching: find.byType(IgnorePointer)).first,
      );

  testWidgets('fora do estado de escolha mostra só uma tela branca', (tester) async {
    await pumpChoice(tester, loadChoice: false);

    expect(find.byType(AgreementsChoicePaymentPage), findsOneWidget);
    expect(find.byType(WhiteAppBar), findsNothing);
    expect(find.text('agreements_choice_payment'), findsNothing);
  });

  testWidgets('lista as formas de pagamento e bate com o golden', (tester) async {
    /// Corrigido (layout): a `Row` de "entenda as opções"
    /// (agreements_choice_payment_page.dart) envolve os dois `Text` em
    /// Flexible, então não estoura mais em 400px de largura.
    await pumpChoice(tester, surface: const Size(400, 1000));

    expect(tester.takeException(), isNull);
    expect(find.text('pendency_type_payment'), findsOneWidget);
    expect(find.text('Etapa 1 de 2'), findsOneWidget);
    expect(find.byType(AgreementOptionsCard), findsNWidgets(2));
    expect(find.text('income_billet_detail_billet'), findsOneWidget);
    expect(find.text('agreements_credit'), findsOneWidget);
    expect(find.text('[desc]'), findsNWidgets(2));
    expect(nextIgnore(tester).ignoring, isTrue);

    await expectLater(
      find.byType(AgreementsChoicePaymentPage),
      matchesGoldenFile('goldens/agreements_choice_payment_page.png'),
    );
  });

  testWidgets('boleto: muda o passo e avança para a recomendação', (tester) async {
    await pumpChoice(tester);

    await tester.tap(find.text('income_billet_detail_billet'));
    await tester.pumpAndSettle();
    expect(find.text('Etapa 1 de 3'), findsOneWidget);
    expect(nextIgnore(tester).ignoring, isFalse);
    expect(tester.widget<Checkbox>(find.byType(Checkbox).first).value, isTrue);

    await tester.tap(find.text('next'));
    await tester.pumpAndSettle();

    expect(observer.pushedNames.last, ApplicationRoute.agreementsRecommendationPayment);
    final args = observer.pushed.last.settings.arguments as List;
    expect(args, [bloc, agreement, false]);
    expect(agreement.paymentMethod, AgreementPaymentMethodEnum.billet.index);
    expect(harness.http.requests.map((r) => r.url.path), containsAll([rulePath, recommendationPath]));
    expect(fakeAnalytics.events.keys, contains('acordos_escolher_pagar_boleto'));
  });

  testWidgets('cartão: seleciona pelo checkbox e avança para o dia de pagamento', (tester) async {
    await pumpChoice(tester);

    await tester.tap(find.byType(Checkbox).last);
    await tester.pumpAndSettle();
    expect(find.text('Etapa 1 de 2'), findsOneWidget);

    await tester.tap(find.text('next'));
    await tester.pumpAndSettle();

    expect(observer.pushedNames.last, ApplicationRoute.agreementDayPayment);
    final args = observer.pushed.last.settings.arguments as List;
    expect(args, [bloc, agreement, false, true]);
    expect(agreement.paymentMethod, AgreementPaymentMethodEnum.credit.index);
    final credit = harness.http.requests.firstWhere((r) => r.url.path == installmentCreditPath);
    expect(credit.url.queryParameters['value'], '300.0');
    expect(fakeAnalytics.events.keys, contains('acordos_escolher_pagar_cartao_de_credito'));
  });

  testWidgets('forma desabilitada abre o diálogo com a descrição', (tester) async {
    agreement = AgreementCreated(totalValue: 300);
    stubAgreementsApi(
      harness.http,
      allInfo: allInfoJson(
        rule: ruleJson(methods: [
          paymentMethodJson('billet'),
          paymentMethodJson('credit', enabled: false, disabledDescription: 'Cartão indisponível'),
        ]),
      ),
    );
    bloc = harness.resolve<AgreementsBloc>();
    await pumpAgreementsStack(
      tester,
      [
        const RouteStep('/agreements'),
        RouteStep(ApplicationRoute.agreementsChoicePayment, arguments: [bloc, agreement]),
      ],
      routes: onlyRoute(ApplicationRoute.agreementsChoicePayment),
    );
    bloc.getChoicePayment();
    await tester.pumpAndSettle();

    final disabled = tester.widget<AgreementOptionsCard>(find.byType(AgreementOptionsCard).last);
    expect(disabled.enabled, isFalse);

    await tester.tap(find.text('agreements_credit'));
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsOneWidget);
    expect(find.textContaining('Cartão indisponível'), findsOneWidget);

    await tester.tap(find.text('ok'));
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsNothing);
    expect(nextIgnore(tester).ignoring, isTrue);
  });

  testWidgets('cartão sem e-mail e telefone pede o cadastro', (tester) async {
    harness.sessionBloc.session.me!
      ..email = ''
      ..phone = null;
    await pumpChoice(tester);

    await tester.tap(find.text('agreements_credit'));
    await tester.pumpAndSettle();
    expect(find.text('agreements_credit_incomplete_info_title'), findsOneWidget);
    expect(find.text('me_email_title'), findsOneWidget);
    expect(find.text('me_phone_title'), findsOneWidget);

    await tester.tap(find.text('CANCEL'));
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsNothing);
    expect(nextIgnore(tester).ignoring, isTrue);

    await tester.tap(find.text('agreements_credit'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('VAMOS LÁ'));
    await tester.pumpAndSettle();

    expect(find.byType(Dialog), findsNothing);
    expect(observer.pushedNames.last, ApplicationRoute.me);
    final args = observer.pushed.last.settings.arguments as MePageArgs;
    expect(args.autoEditMode, isTrue);
    expect(args.emailRequired, isTrue);
    expect(args.phoneRequired, isTrue);
    expect(args.backAfterSave, isTrue);
  });

  testWidgets('cartão só sem telefone mostra apenas o telefone', (tester) async {
    harness.sessionBloc.session.me!.phone = '';
    await pumpChoice(tester);

    await tester.tap(find.text('agreements_credit'));
    await tester.pumpAndSettle();

    expect(find.text('me_email_title'), findsNothing);
    expect(find.text('me_phone_title'), findsOneWidget);
    await tester.tap(find.text('CANCEL'));
    await tester.pumpAndSettle();
  });

  testWidgets('"entenda as opções" abre o bottom sheet explicativo', (tester) async {
    await pumpChoice(tester);

    await tester.tap(find.text('agreements_understand'));
    await tester.pumpAndSettle();
    expect(find.byType(AgreementOptionsPaymentBottomSheet), findsOneWidget);
    expect(find.text('agreements_billet_bank'), findsOneWidget);
    expect(find.text('agreements_creditcard_bank'), findsOneWidget);

    await tester.tap(find.text('agreements_ok_understood_button'));
    await tester.pumpAndSettle();
    expect(find.byType(AgreementOptionsPaymentBottomSheet), findsNothing);

    await tester.tap(find.text('agreements_understand'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
    await tester.pumpAndSettle();
    expect(find.byType(AgreementOptionsPaymentBottomSheet), findsNothing);
  });

  testWidgets('voltar pela app bar recarrega as cotas e volta para acordos', (tester) async {
    await pumpChoice(tester);
    agreement.totalValue = 300;
    final before = harness.http.requests.where((r) => r.url.path == allInfoPath).length;

    await tester.tap(find.byIcon(Icons.arrow_back_ios));
    await tester.pumpAndSettle();

    expect(findRoute('/agreements'), findsOneWidget);
    expect(find.byType(AgreementsChoicePaymentPage), findsNothing);
    expect(agreement.totalValue, 0);
    expect(harness.http.requests.where((r) => r.url.path == allInfoPath).length, before + 1);
  });

  testWidgets('voltar pelo sistema também volta para acordos', (tester) async {
    await pumpChoice(tester);

    await systemBack(tester);

    expect(findRoute('/agreements'), findsOneWidget);
    expect(find.byType(AgreementsChoicePaymentPage), findsNothing);
  });

  testWidgets('o corpo do POST usa a unidade e a referência da sessão', (tester) async {
    await pumpChoice(tester);
    bloc.postAgreement(agreement, false, false);
    await tester.pumpAndSettle();

    final post = harness.http.requests.firstWhere((r) => r.method == 'POST');
    final body = jsonDecode(post.body) as Map<String, dynamic>;
    expect(body['unit'], '101');
    expect(body['reference'], 77);
    expect(body['receipt_list'], ['rec1']);
    expect(body['email'], 'ana@lello.com');
  });
}
