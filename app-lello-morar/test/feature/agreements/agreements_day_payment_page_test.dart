import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_created.dart';
import 'package:morar/feature/agreements/presentation/bloc/agreements_bloc.dart';
import 'package:morar/feature/agreements/presentation/bloc/agreements_state.dart';
import 'package:morar/feature/agreements/presentation/pages/agreements_day_payment_page.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreement_day_quotas_dialog.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreement_options_card.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreement_payday_bottom_sheet.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreement_resume_bottom_sheet.dart';

import '../../helpers/firebase_mocks.dart';
import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';
import 'agreements_test_support.dart';

void main() {
  late PageHarness harness;
  late RecordingNavigatorObserver observer;
  late AgreementsBloc bloc;
  late AgreementCreated agreement;
  late FakeUrlLauncher launcher;

  setUp(() async {
    harness = await installPageHarness();
    observer = RecordingNavigatorObserver();
    harness.sessionBloc.session.condominium!.reference = '77';
    fakeAnalytics.reset();
    launcher = installFakeUrlLauncher();
    agreement = AgreementCreated(
      totalValue: 300,
      receiptList: ['rec1'],
      paymentMethod: 1,
      installmentQuantity: 2,
    );
  });

  Future<void> pumpDay(
    WidgetTester tester, {
    bool indicate = false,
    bool creditCard = false,
    bool load = true,
    Map<String, dynamic>? posted,
  }) async {
    stubAgreementsApi(harness.http, posted: posted);
    bloc = harness.resolve<AgreementsBloc>();
    final args = <Object>[bloc, agreement];
    if (indicate || creditCard) args.add(indicate);
    if (creditCard) args.add(true);
    await pumpAgreementsStack(
      tester,
      [
        const RouteStep('/agreements'),
        const RouteStep('/agreements_choice_payment'),
        const RouteStep('/agreements_recommendation_payment'),
        RouteStep(ApplicationRoute.agreementDayPayment, arguments: args),
      ],
      routes: onlyRoute(ApplicationRoute.agreementDayPayment),
      observer: observer,
      locOverrides: stepOverrides,
    );
    if (load) {
      if (creditCard) {
        bloc.getInstallments(agreement.totalValue);
      } else {
        bloc.getPayday();
      }
      await tester.pumpAndSettle();
    }
  }

  /// O RichText da política de privacidade (único com um span clicável).
  Finder findPolicyRichText() => find.byWidgetPredicate(
        (w) =>
            w is RichText &&
            w.text is TextSpan &&
            ((w.text as TextSpan).children?.any((c) => c is TextSpan && c.recognizer != null) ?? false),
      );

  IgnorePointer nextIgnore(WidgetTester tester) => tester.widget<IgnorePointer>(
        find.ancestor(of: find.text('next'), matching: find.byType(IgnorePointer)).first,
      );

  group('boleto', () {
    testWidgets('loading e erro', (tester) async {
      await pumpDay(tester, load: false);

      expect(find.text('agreements_day_payment'), findsOneWidget);
      expect(find.text('Etapa 2 de 2'), findsOneWidget);
      await emitState(tester, bloc, const AgreementsLoadingState(), settle: false);
      await tester.pump();
      expect(find.byType(LoadingWidget), findsOneWidget);
      /// Corrigido: no fluxo boleto o botão usa `ignoring: !checked || loading`
      /// (agreements_day_payment_page.dart), alinhado ao fluxo de cartão:
      /// durante o loading ele fica ignorado, não só com opacidade 0.3.
      expect(nextIgnore(tester).ignoring, isTrue);

      await emitState(tester, bloc, const AgreementsErrorState(errorMessageKey: 'erro_x'));
      expect(find.text('erro_x'), findsOneWidget);
    });

    testWidgets('lista os dias, seleciona um e finaliza gerando o boleto', (tester) async {
      await pumpDay(tester);

      expect(find.byType(AgreementOptionsCard), findsNWidgets(3));
      expect(find.textContaining(' 5'), findsOneWidget);
      expect(find.text('agreement_attention'), findsNothing); // faz parte de um RichText
      expect(find.byType(RichText), findsWidgets);
      expect(nextIgnore(tester).ignoring, isTrue);

      await tester.tap(find.byType(AgreementOptionsCard).first);
      await tester.pumpAndSettle();
      expect(agreement.dueDate, 5);
      expect((bloc.state as AgreementsPaydayLoadedState).checkList, [true, false, false]);
      expect(nextIgnore(tester).ignoring, isFalse);

      // pelo checkbox
      await tester.tap(find.byType(Checkbox).at(1));
      await tester.pumpAndSettle();
      expect(agreement.dueDate, 10);
      expect((bloc.state as AgreementsPaydayLoadedState).checkList, [false, true, false]);

      await tester.tap(find.text('next'));
      await tester.pumpAndSettle();
      expect(find.byType(AgreementResumeBottomSheet), findsOneWidget);
      expect(find.text('agreements_end'), findsOneWidget);
      expect(find.text('agreements_recuse_back'), findsNothing);
      expect(find.textContaining(' 10'), findsWidgets);

      await tester.tap(find.text('agreements_end'));
      await tester.pumpAndSettle();

      expect(observer.pushedNames.last, ApplicationRoute.agreementBillet);
      final args = observer.pushed.last.settings.arguments as List;
      expect(args[0], bloc);
      expect(args[1], isFalse);
      expect(args[2], agreement);
    });

    testWidgets('dia 29 avisa sobre meses curtos', (tester) async {
      await pumpDay(tester);

      await tester.tap(find.byType(AgreementOptionsCard).last);
      await tester.pumpAndSettle();

      expect(find.byType(AgreementDayQuotasDialog), findsOneWidget);
      expect(find.text('agreement_day_dialog_subtitle'), findsOneWidget);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(find.byType(AgreementDayQuotasDialog), findsNothing);
      expect(agreement.dueDate, 29);
    });

    testWidgets('proposta pendente (indicate) mostra o resumo de proposta e vai para sucesso',
        (tester) async {
      await pumpDay(tester, indicate: true, posted: agreementJson('novo', status: 'pending'));

      await tester.tap(find.byType(AgreementOptionsCard).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('next'));
      await tester.pumpAndSettle();

      expect(find.text('agreements_end_proposal'), findsOneWidget);
      expect(find.text('agreements_recuse_back'), findsOneWidget);
      expect(find.byType(RichText), findsWidgets);

      await tester.tap(find.text('agreements_end_proposal'));
      await tester.pumpAndSettle();

      expect(observer.pushedNames.last, ApplicationRoute.agreementSuccessSend);
      expect(bloc.state, isA<PostPendingProposalLoadedState>());
    });

    testWidgets('recusar a proposta volta para acordos recarregando', (tester) async {
      await pumpDay(tester, indicate: true);

      await tester.tap(find.byType(AgreementOptionsCard).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('next'));
      await tester.pumpAndSettle();
      final before = harness.http.requests.where((r) => r.url.path == allInfoPath).length;

      await tester.tap(find.text('agreements_recuse_back'));
      await tester.pumpAndSettle();

      expect(find.byType(AgreementResumeBottomSheet), findsNothing);
      expect(fakeAnalytics.events.keys, contains('acordos_recusar_acordo'));
      expect(agreement.totalValue, 0);
      expect(harness.http.requests.where((r) => r.url.path == allInfoPath).length, before + 1);
      expect(observer.pushedNames.last, ApplicationRoute.agreements);
      expect(find.byType(AgreementsDayPaymentPage), findsNothing);
    });

    testWidgets('"outro dia" abre o calendário e segue para o resumo da proposta', (tester) async {
      await pumpDay(tester);
      await tester.tap(find.byType(AgreementOptionsCard).first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('agreements_other_day_choice'));
      await tester.pumpAndSettle();

      expect(find.byType(AgreementPaydayBottomSheet), findsOneWidget);
      expect(find.text('agreements_day_payment_title_sheet'), findsOneWidget);
      // a seleção anterior é limpa
      expect((bloc.state as AgreementsPaydayLoadedState).checkList, [false, false, false]);
      expect(find.text('31'), findsOneWidget);
      IgnorePointer accept() => tester.widget<IgnorePointer>(
            find.ancestor(of: find.text('agreements_accept_next'), matching: find.byType(IgnorePointer)).first,
          );
      expect(accept().ignoring, isTrue);

      // dia já oferecido pelo condomínio não é selecionável
      await tester.tap(find.text('5'));
      await tester.pumpAndSettle();
      expect(accept().ignoring, isTrue);

      // dia 30 avisa sobre meses curtos
      await tester.tap(find.text('30'));
      await tester.pumpAndSettle();
      expect(find.byType(AgreementDayQuotasDialog), findsOneWidget);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(accept().ignoring, isFalse);

      await tester.tap(find.text('7'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('agreements_accept_next'));
      await tester.pumpAndSettle();

      expect(find.byType(AgreementPaydayBottomSheet), findsNothing);
      expect(agreement.dueDate, 7);
      expect(find.byType(AgreementResumeBottomSheet), findsOneWidget);
      expect(find.text('agreements_end_proposal'), findsOneWidget);
    });

    testWidgets('calendário fecha pela seta', (tester) async {
      await pumpDay(tester);

      await tester.tap(find.text('agreements_other_day_choice'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
      await tester.pumpAndSettle();

      expect(find.byType(AgreementPaydayBottomSheet), findsNothing);
    });

    testWidgets('voltar (app bar) volta para a recomendação', (tester) async {
      await pumpDay(tester);

      await tester.tap(find.byIcon(Icons.arrow_back_ios));
      await tester.pumpAndSettle();

      expect(findRoute('/agreements_recommendation_payment'), findsOneWidget);
      expect(find.byType(AgreementsDayPaymentPage), findsNothing);
      expect(bloc.state, isA<AgreementsRecommendationLoadedState>());
    });

    testWidgets('voltar (sistema) volta para a recomendação', (tester) async {
      await pumpDay(tester);

      await systemBack(tester);

      expect(findRoute('/agreements_recommendation_payment'), findsOneWidget);
      expect(find.byType(AgreementsDayPaymentPage), findsNothing);
    });
  });

  group('cartão de crédito', () {
    testWidgets('loading e erro', (tester) async {
      await pumpDay(tester, creditCard: true, load: false);

      expect(find.text('agreement_only_billet'), findsOneWidget);
      await emitState(tester, bloc, const AgreementsLoadingState(), settle: false);
      await tester.pump();
      expect(find.byType(LoadingWidget), findsOneWidget);
      expect(nextIgnore(tester).ignoring, isTrue);

      await emitState(tester, bloc, const AgreementsErrorState(errorMessageKey: 'erro_y'));
      expect(find.text('erro_y'), findsOneWidget);
    });

    testWidgets('aceitar a política libera o próximo e finaliza no boleto digital', (tester) async {
      await pumpDay(tester, creditCard: true);

      expect(find.text('agreement_privacy_policy_description'), findsOneWidget);
      expect(nextIgnore(tester).ignoring, isTrue);

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isTrue);
      expect(nextIgnore(tester).ignoring, isFalse);

      // tocar no texto (fora do link) também alterna
      await tester.tapAt(tester.getTopLeft(findPolicyRichText()) + const Offset(4, 4));
      await tester.pumpAndSettle();
      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isFalse);
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      await tester.tap(find.text('next'));
      await tester.pumpAndSettle();
      expect(find.byType(AgreementResumeBottomSheet), findsOneWidget);
      expect(find.text('agreement_credit_expiration'), findsOneWidget);
      expect(find.text('agreement_billet_total_value'), findsOneWidget);
      expect(find.text('agreement_info_resume_credit'), findsOneWidget);
      expect(find.textContaining('agreements_value_installment'), findsNothing);

      await tester.tap(find.text('agreements_end'));
      await tester.pumpAndSettle();

      expect(observer.pushedNames.last, ApplicationRoute.agreementBillet);
      final args = observer.pushed.last.settings.arguments as List;
      expect(args[1], isTrue);
      expect((bloc.state as PostAgreementLoadedState).creditCard, isTrue);
    });

    testWidgets('link da política de privacidade abre a URL', (tester) async {
      await pumpDay(tester, creditCard: true);

      final rich = tester.widget<RichText>(findPolicyRichText());
      final link = (rich.text as TextSpan).children!.single as TextSpan;
      (link.recognizer as TapGestureRecognizer).onTap!();
      await tester.pumpAndSettle();

      expect(launcher.launched.single, contains('politica-de-privacidade'));
    });

    testWidgets('voltar (app bar e sistema) volta para a escolha', (tester) async {
      await pumpDay(tester, creditCard: true);

      await tester.tap(find.byIcon(Icons.arrow_back_ios));
      await tester.pumpAndSettle();
      expect(findRoute('/agreements_choice_payment'), findsOneWidget);
      expect(bloc.state, isA<AgreementsChoiceLoadedState>());
    });

    testWidgets('voltar pelo sistema volta para a escolha', (tester) async {
      await pumpDay(tester, creditCard: true);

      await systemBack(tester);

      expect(findRoute('/agreements_choice_payment'), findsOneWidget);
      expect(find.byType(AgreementsDayPaymentPage), findsNothing);
    });
  });
}
