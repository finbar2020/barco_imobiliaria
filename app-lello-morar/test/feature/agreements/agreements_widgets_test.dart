import 'package:essentials/essentials.dart' hide isNull, isNotNull, Slider;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/error_message_widget.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:morar/feature/agreements/domain/entity/agreement.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_created.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_installment_credit.dart';
import 'package:morar/feature/agreements/presentation/bloc/agreements_bloc.dart';
import 'package:morar/feature/agreements/presentation/bloc/agreements_state.dart';
import 'package:morar/feature/agreements/presentation/pages/agreements_made_card_details_page.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreement_access_not_allowed_dialog.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreement_card.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreement_installments_bottom_sheet.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreement_installments_option.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreement_no_avaible.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreement_not_avaliable_dialog.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreement_options_card.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreements_approved_proposal_bottom.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreements_introduction_details_card.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreements_payment_details.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreements_taxes_information_bottom.dart';

import '../../helpers/firebase_mocks.dart';
import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';
import 'agreements_test_support.dart';

void main() {
  late PageHarness harness;
  late RecordingNavigatorObserver observer;
  late FakeUrlLauncher launcher;

  setUp(() async {
    harness = await installPageHarness();
    observer = RecordingNavigatorObserver();
    harness.sessionBloc.session.condominium!.reference = '77';
    fakeAnalytics.reset();
    launcher = installFakeUrlLauncher();
    mockClipboard();
    stubAgreementsApi(harness.http);
  });

  /// Monta [child] numa página com um botão "abrir" que executa [open].
  Future<void> pumpOpener(
    WidgetTester tester,
    void Function(BuildContext context) open, {
    Map<String, String> locOverrides = const {},
  }) async {
    await pumpPage(
      tester,
      Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () => open(context),
            child: const Text('abrir'),
          ),
        ),
      ),
      observer: observer,
      locOverrides: locOverrides,
    );
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
  }

  group('AgreementCard', () {
    late AgreementsBloc bloc;
    late AgreementCreated created;

    Future<void> pumpCard(WidgetTester tester, Agreement agreement) async {
      bloc = harness.resolve<AgreementsBloc>();
      created = AgreementCreated(totalValue: 10);
      await pumpPage(
        tester,
        Builder(
          builder: (context) => Scaffold(
            body: AgreementCard(
              agreement: agreement,
              agreementCreated: created,
              bloc: bloc,
              anotherContext: context,
            ),
          ),
        ),
        observer: observer,
        surface: const Size(600, 1000),
      );
    }

    testWidgets('acordo pendente mostra valores e não navega ao tocar', (tester) async {
      await pumpCard(tester, testAgreement(status: 'pending'));

      expect(find.text('09/03/2026'), findsOneWidget);
      expect(find.text('original_value'), findsOneWidget);
      expect(find.text('taxes'), findsOneWidget);
      expect(find.text('update_value'), findsOneWidget);
      expect(find.text('agreement_pending_status'), findsOneWidget);
      expect(find.text('agreement_billet_view'), findsNothing);

      await tester.tap(find.byType(AgreementCard));
      await tester.pumpAndSettle();
      expect(observer.pushedNames, isNot(contains(ApplicationRoute.agreementDetail)));
    });

    testWidgets('acordo liberado com link abre o site de pagamento', (tester) async {
      await pumpCard(
        tester,
        testAgreement(
          status: 'approved_by_manager',
          installments: [testInstallment(paymentLink: 'https://pay.example/x')],
        ),
      );

      expect(find.text('AGREEMENT_NEW_EXPIRATION'), findsOneWidget);
      expect(find.text('01/02/2026'), findsOneWidget);
      expect(find.text('AGREEMENT_NEW_VALUE'), findsOneWidget);
      expect(find.text('2x'), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_arrow_right), findsOneWidget);
      expect(find.text('agreement_billet_view'), findsOneWidget);
      expect(find.text('agreement_payment_released'), findsOneWidget);

      await tester.tap(find.text('agreement_go_to_pay'));
      await tester.pumpAndSettle();

      expect(launcher.launched, ['https://pay.example/x']);
      /// Corrigido (agreement_card.dart): ao abrir o link de pagamento o
      /// card loga `acordos_acessar_site_parceiro_vamos_parcelar`, como a
      /// página do boleto, e não mais `acordos_copiar_codigo_de_barras`.
      expect(fakeAnalytics.events.keys,
          contains('acordos_acessar_site_parceiro_vamos_parcelar'));
      expect(fakeAnalytics.events.keys,
          isNot(contains('acordos_copiar_codigo_de_barras')));
    });

    testWidgets('acordo liberado sem link copia o código de barras', (tester) async {
      await pumpCard(tester, testAgreement(status: 'approved_automatically'));

      await tester.tap(find.text('billet_copy_barcode'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(Flushbar), findsOneWidget);
      expect(find.text('billet_copied_barcode'), findsOneWidget);
      await settleFlushbar(tester);
    });

    testWidgets('sem parcela pendente: copiar não faz nada e ver boleto mostra erro', (tester) async {
      await pumpCard(
        tester,
        testAgreement(
          status: 'approved_by_manager',
          installments: [testInstallment(status: 'paid')],
        ),
      );

      await tester.tap(find.text('billet_copy_barcode'));
      await tester.pumpAndSettle();
      expect(find.byType(Flushbar), findsNothing);

      await tester.tap(find.text('agreement_billet_view'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('request_fine_error_message'), findsOneWidget);
      expect(fakeAnalytics.events.keys, contains('acordos_visualizar_boleto'));
      await settleFlushbar(tester);
    });

    testWidgets('acordo concluído abre os detalhes ao tocar', (tester) async {
      harness.http.on('GET', detailsPath('a1'), body: agreementJson('a1', status: 'completed'));
      await pumpCard(tester, testAgreement(status: 'completed'));

      expect(find.byIcon(Icons.keyboard_arrow_right), findsNothing);
      expect(find.text('agreement_billet_view'), findsNothing);

      await tester.tap(find.byType(AgreementCard));
      await tester.pumpAndSettle();

      expect(observer.pushedNames.last, ApplicationRoute.agreementDetail);
      expect(observer.pushed.last.settings.arguments, [bloc, created]);
      expect(bloc.state, isA<AgreementDetailLoadedState>());
    });

    testWidgets('acordo rejeitado em destaque usa a cor de highlight', (tester) async {
      await pumpCard(tester, testAgreement(status: 'rejected')..highlight = true);

      expect(find.text('income_billet_detail_situation_canceled'), findsOneWidget);
      final card = tester.widget<Card>(find.byType(Card));
      final theme = Theme.of(tester.element(find.byType(Card)));
      expect(card.color, theme.highlightColor);
    });
  });

  group('diálogos de indisponibilidade', () {
    testWidgets('AgreementAccessNotAllowedDialog copia o e-mail, abre o WhatsApp e fecha',
        (tester) async {
      /// Corrigido (layout): a `Row` inferior do diálogo
      /// (agreement_access_not_allowed_dialog.dart) usa Flexible + ellipsis,
      /// então não estoura em 400px mesmo com o texto longo (a chave crua).
      await pumpOpener(
        tester,
        (context) => showDialog(
          context: context,
          // ignore: prefer_const_constructors
          builder: (_) => AgreementAccessNotAllowedDialog(),
        ),
      );
      expect(tester.takeException(), isNull);

      expect(find.text('chat_error_title!'), findsOneWidget);
      expect(find.text('agreement_access_not_allowed'), findsOneWidget);
      final email = FlavorConfig.config.supportEmail;
      expect(find.text(email), findsOneWidget);

      await tester.tap(find.text(email));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('email_copied'), findsOneWidget);
      await settleFlushbar(tester);

      await tester.tap(find.text('REGISTRATION_LELLO_WARNING_NO_DATA_BTN'));
      await tester.pumpAndSettle();
      expect(launcher.launched.single, contains('wa.me'));

      await tester.tap(find.text('LATER'));
      await tester.pumpAndSettle();
      expect(find.byType(AgreementAccessNotAllowedDialog), findsNothing);
    });

    testWidgets('AgreementNotAvaliableDialog copia o e-mail e fecha', (tester) async {
      await pumpOpener(
        tester,
        (context) => showDialog(
          context: context,
          // ignore: prefer_const_constructors
          builder: (_) => AgreementNotAvaliableDialog(message: 'm'),
        ),
      );

      expect(find.text('agreement_not_avaliable_failure'), findsOneWidget);
      final email = FlavorConfig.config.supportEmail;

      await tester.tap(find.text(email));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('email_copied'), findsOneWidget);
      await settleFlushbar(tester);

      await tester.tap(find.text('LATER'));
      await tester.pumpAndSettle();
      expect(find.byType(AgreementNotAvaliableDialog), findsNothing);
    });
  });

  group('bottom sheets', () {
    testWidgets('taxas fecha pela seta', (tester) async {
      await pumpOpener(
        tester,
        (context) => Modal.showBottomSheet(
          context: context,
          builder: (_) => AgreementsTaxesInformationBottom(dialogOnPressed: () {}),
        ),
      );
      expect(find.text('taxes_information_description'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
      await tester.pumpAndSettle();
      expect(find.byType(AgreementsTaxesInformationBottom), findsNothing);
    });

    testWidgets('proposta aprovada fecha pela seta', (tester) async {
      await pumpOpener(
        tester,
        (context) => Modal.showBottomSheet(
          context: context,
          builder: (_) => const AgreementsApprovedProposalBottom(),
        ),
      );
      expect(find.text('approved_proposal_message'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
      await tester.pumpAndSettle();
      expect(find.byType(AgreementsApprovedProposalBottom), findsNothing);
    });

    testWidgets('slider de parcelas limita o mínimo a 12', (tester) async {
      final agreement = AgreementCreated();
      var pressed = 0;
      await pumpOpener(
        tester,
        (context) => Modal.showBottomSheet(
          context: context,
          builder: (_) => AgreementInstallmentsBottomSheet(
            agreement: agreement,
            min: 15,
            onPressed: () => pressed++,
          ),
        ),
      );

      final slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.min, 12);
      expect(slider.max, 12);
      expect(slider.divisions, 1);
      expect(find.text('12x'), findsOneWidget);

      await tester.tap(find.text('agreements_accept_next'));
      await tester.pumpAndSettle();
      expect(agreement.installmentQuantity, 12);
      expect(pressed, 1);
    });

    testWidgets('slider com intervalo destaca só o valor atual', (tester) async {
      final agreement = AgreementCreated();
      await pumpOpener(
        tester,
        (context) => Modal.showBottomSheet(
          context: context,
          builder: (_) => AgreementInstallmentsBottomSheet(
            agreement: agreement,
            min: 2,
            onPressed: () {},
          ),
        ),
      );

      final theme = Theme.of(tester.element(find.byType(Slider)));
      TextStyle styleOf(String label) => tester.widget<Text>(find.text(label)).style!;
      expect(styleOf('2x').color, theme.primaryColor);
      expect(styleOf('12x').color, LelloTheme.palleteOf(theme).grey());
      expect(styleOf('5x').color, Colors.transparent);

      await tester.drag(find.byType(Slider), const Offset(120, 0));
      await tester.pumpAndSettle();
      final value = tester.widget<Slider>(find.byType(Slider)).value.toInt();
      expect(value, greaterThan(2));
      expect(styleOf('${value}x').color, theme.primaryColor);
      expect(styleOf('2x').color, LelloTheme.palleteOf(theme).grey());
    });
  });

  group('widgets simples', () {
    testWidgets('AgreementOptionsCard desabilitado, com ícone e texto simples', (tester) async {
      await pumpApp(
        tester,
        Column(
          children: [
            AgreementOptionsCard(
              check: true,
              onChanged: (_) {},
              title: 'income_billet_detail_billet',
              subtitle: 'sub',
              icon: 'assets/ic_agreement_billet.svg',
              enabled: false,
            ),
            AgreementOptionsCard(
              check: false,
              onChanged: (_) {},
              title: 'Dia 5',
              simpleText: true,
            ),
          ],
        ),
        localized: true,
        surface: const Size(600, 800),
      );

      expect(find.text('income_billet_detail_billet'), findsOneWidget);
      expect(find.text('[sub]'), findsOneWidget);
      expect(find.text('Dia 5'), findsOneWidget);
      expect(find.byType(SvgPicture), findsOneWidget);
      final opacity = tester.widget<Opacity>(find.byType(Opacity).first);
      expect(opacity.opacity, 0.5);
    });

    testWidgets('AgreementInstallmentsOption sem taxas mostra só a parcela', (tester) async {
      await pumpApp(
        tester,
        AgreementInstallmentsOption(
          installment: AgreementInstallmentCredit(
            billetValue: 100,
            installmentQtd: 4,
            totalValue: 100,
            installmentValue: 25,
          ),
        ),
        localized: true,
      );

      expect(find.text('[4x] R\$ 25.0'), findsOneWidget);
      expect(find.text('agreement_card_tax'), findsNothing);
      expect(find.textContaining('agreement_installment_tax'), findsNothing);
    });

    testWidgets('AgreementsNoAvailableWidget muda a mensagem', (tester) async {
      await pumpApp(
        tester,
        const Column(children: [
          AgreementsNoAvailableWidget(),
          AgreementsNoAvailableWidget(agreement: true),
        ]),
        localized: true,
      );

      expect(find.text('you_have_no_quotas'), findsOneWidget);
      expect(find.text('you_have_no_agreements'), findsOneWidget);
    });

    testWidgets('IntroductionDetailsCard e PaymentDetailsCard renderizam', (tester) async {
      await pumpApp(
        tester,
        Column(children: [
          IntroductionDetailsCard(theme: LelloTheme.light),
          const PaymentDetailsCard(),
        ]),
        localized: true,
        shrinkWrap: false,
        surface: const Size(600, 900),
      );

      expect(find.text('101 - JOSE ANTONIO DE SOUZA'), findsOneWidget);
      expect(find.text('agreements_payment_method '), findsOneWidget);
      expect(find.text('Boleto'), findsOneWidget);
      expect(find.text('agreements_payments'), findsOneWidget);
    });
  });

  group('AgreementsMadeCardDetailsPage', () {
    testWidgets('mostra loading, erro e nada nos demais estados', (tester) async {
      final bloc = harness.resolve<AgreementsBloc>();
      await pumpPage(
        tester,
        const AgreementsMadeCardDetailsPage(),
        arguments: [bloc],
      );

      expect(find.text('agreements_in_progress_title'), findsOneWidget);
      expect(find.byType(LoadingWidget), findsNothing);

      await emitState(tester, bloc, const AgreementsLoadingState(), settle: false);
      await tester.pump();
      expect(find.byType(LoadingWidget), findsOneWidget);

      await emitState(tester, bloc, const AgreementsErrorState(errorMessageKey: 'erro_k'));
      expect(find.byType(ErrorMessageWidget), findsOneWidget);
      expect(find.text('erro_k'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.byType(AgreementsMadeCardDetailsPage), findsOneWidget);
    });
  });
}
