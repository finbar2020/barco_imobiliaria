import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_created.dart';
import 'package:morar/feature/agreements/presentation/bloc/agreements_bloc.dart';
import 'package:morar/feature/agreements/presentation/bloc/agreements_state.dart';
import 'package:morar/feature/agreements/presentation/pages/agreements_page.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreement_card.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreement_day_quotas_dialog.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreement_quota_available_card.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreements_approved_proposal_bottom.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreements_rejected_proposal_bottom.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreements_taxes_information_bottom.dart';

import '../../helpers/firebase_mocks.dart';
import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';
import 'agreements_test_support.dart';

void main() {
  late PageHarness harness;
  late RecordingNavigatorObserver observer;

  setUp(() async {
    harness = await installPageHarness();
    observer = RecordingNavigatorObserver();
    // O bloc faz `int.parse` da referência do condomínio.
    harness.sessionBloc.session.condominium!.reference = '77';
    fakeAnalytics.reset();
  });

  AgreementsBloc bloc() => harness.resolve<AgreementsBloc>();
  AgreementsQuotaAvailableLoadedState loaded() =>
      bloc().state as AgreementsQuotaAvailableLoadedState;
  Finder tabMade() => find.widgetWithText(Tab, 'agreements_made');

  group('aba cotas disponíveis', () {
    testWidgets('busca as cotas na API e lista os cards', (tester) async {
      stubAgreementsApi(harness.http);

      await pumpAgreementsPage(tester, observer: observer, surface: const Size(600, 1400));

      expect(find.text('agreements'), findsOneWidget);
      expect(find.text('available_quotas_title'), findsOneWidget);
      expect(find.text('description_available_quota_subtitle'), findsOneWidget);
      expect(find.byType(AgreementsQuotaAvailableWidget), findsNWidgets(3));
      expect(
        harness.http.requests.map((r) => r.url.path),
        contains(allInfoPath),
      );
      expect(harness.http.requests.first.url.queryParameters['unitName'], '101');
      expect(loaded().checkList, [false, false, false]);
    });

    testWidgets('estado de loading mostra o indicador nas duas abas', (tester) async {
      /// Corrigido: `_AgreementsPageState.dispose()` chama
      /// `controller.dispose()` (TabController); ver o teste de desmontagem
      /// com a animação da aba em andamento logo abaixo.
      stubAgreementsApi(harness.http);
      await pumpAgreementsPage(tester);

      // A entrega do estado é assíncrona: precisa de um frame extra.
      await emitState(tester, bloc(), const AgreementsQuotaLoadingState(), settle: false);
      await tester.pump();
      expect(find.byType(LoadingWidget), findsOneWidget);

      // Sem pumpAndSettle (spinner infinito): dois frames para a animação
      // da aba terminar antes do dispose.
      await tester.tap(tabMade());
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(LoadingWidget), findsWidgets);
      await emitState(tester, bloc(), const AgreementsQuotaErrorState(errorMessageKey: 'x'));
    });

    testWidgets('desmontar com a animação da aba em andamento não vaza o Ticker',
        (tester) async {
      /// Corrigido: sem `controller.dispose()` o TabController ficaria com o
      /// Ticker ativo e o `TickerProviderStateMixin` lançaria assertion aqui.
      stubAgreementsApi(harness.http);
      await pumpAgreementsPage(tester);

      await tester.tap(tabMade());
      await tester.pump(const Duration(milliseconds: 50));

      await tester.pumpWidget(const SizedBox());
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(bloc().isFirstMadeCall, isFalse);
    });

    testWidgets('seleciona cotas em sequência, remove e limpa a seleção', (tester) async {
      stubAgreementsApi(harness.http);
      await pumpAgreementsPage(tester, observer: observer, surface: const Size(600, 1400));

      // O botão "próximo" fica ignorado enquanto nada está selecionado.
      IgnorePointer nextIgnore() => tester.widget<IgnorePointer>(
            find.ancestor(of: find.byType(PrimaryButton), matching: find.byType(IgnorePointer)).first,
          );
      expect(nextIgnore().ignoring, isTrue);

      // 1ª cota via checkbox
      await tester.tap(find.byType(Checkbox).at(0));
      await tester.pumpAndSettle();
      expect(loaded().checkList, [true, false, false]);
      expect(nextIgnore().ignoring, isFalse);

      // 2ª cota via toque no card
      await tester.tap(find.byType(AgreementsQuotaAvailableWidget).at(1));
      await tester.pumpAndSettle();
      expect(loaded().checkList, [true, true, false]);

      // 3ª cota
      await tester.tap(find.byType(Checkbox).at(2));
      await tester.pumpAndSettle();
      expect(loaded().checkList, [true, true, true]);

      // Desmarcar a 2ª limpa dela em diante
      await tester.tap(find.byType(Checkbox).at(1));
      await tester.pumpAndSettle();
      expect(loaded().checkList, [true, false, false]);

      // Desmarcar a 1ª limpa tudo
      await tester.tap(find.byType(Checkbox).at(0));
      await tester.pumpAndSettle();
      expect(loaded().checkList, [false, false, false]);
      expect(nextIgnore().ignoring, isTrue);

      // Seleciona a 1ª de novo e avança
      await tester.tap(find.byType(Checkbox).at(0));
      await tester.pumpAndSettle();
      await tester.tap(find.text('next'));
      await tester.pumpAndSettle();

      expect(observer.pushedNames.last, ApplicationRoute.agreementsChoicePayment);
      final args = observer.pushed.last.settings.arguments as List;
      expect(args[0], same(bloc()));
      final created = args[1] as AgreementCreated;
      expect(created.receiptList, ['rec1']);
      expect(created.totalValue, 110);
      expect(bloc().state, isA<AgreementsChoiceLoadedState>());
    });

    testWidgets('cota fora de ordem fica ignorada até a anterior ser marcada', (tester) async {
      /// Corrigido: `checkIgnoringPointer`/`checkOpacity` testam o bool
      /// `!state.checkList[index]`: cota não marcada depende da anterior;
      /// cota já marcada fica sempre ativa (ramo `else`) para poder desmarcar.
      stubAgreementsApi(harness.http);
      await pumpAgreementsPage(tester, surface: const Size(600, 1400));

      Opacity opacityOf(int index) => tester.widget<Opacity>(
            find.ancestor(
              of: find.byType(AgreementsQuotaAvailableWidget).at(index),
              matching: find.byType(Opacity),
            ).first,
          );
      IgnorePointer ignoreOf(int index) => tester.widget<IgnorePointer>(
            find.ancestor(
              of: find.byType(AgreementsQuotaAvailableWidget).at(index),
              matching: find.byType(IgnorePointer),
            ).first,
          );

      await tester.tap(find.byType(Checkbox).at(1), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(loaded().checkList, [false, false, false]);
      expect(opacityOf(1).opacity, 0.3);
      expect(ignoreOf(1).ignoring, isTrue);

      // Marcando a anterior, a cota fica ativa.
      await tester.tap(find.byType(Checkbox).at(0));
      await tester.pumpAndSettle();
      expect(loaded().checkList, [true, false, false]);
      expect(opacityOf(1).opacity, 1.0);
      expect(ignoreOf(1).ignoring, isFalse);

      // Cota marcada continua ativa (ramo `else`) para poder ser desmarcada.
      await tester.tap(find.byType(Checkbox).at(1));
      await tester.pumpAndSettle();
      expect(loaded().checkList, [true, true, false]);
      expect(opacityOf(1).opacity, 1.0);
      expect(ignoreOf(1).ignoring, isFalse);
      expect(opacityOf(2).opacity, 1.0);
      expect(ignoreOf(2).ignoring, isFalse);
    });

    testWidgets('com acordo pendente abre o diálogo em vez de selecionar', (tester) async {
      stubAgreementsApi(
        harness.http,
        allInfo: allInfoJson(agreements: [agreementJson('a1', status: 'pending')]),
      );
      await pumpAgreementsPage(tester, surface: const Size(600, 1400));

      await tester.tap(find.byType(Checkbox).at(0));
      await tester.pumpAndSettle();

      expect(find.byType(AgreementDayQuotasDialog), findsOneWidget);
      expect(find.text('agreement_pending'), findsOneWidget);
      expect(loaded().checkList, [false, false, false]);

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(find.byType(AgreementDayQuotasDialog), findsNothing);
    });

    testWidgets('link de taxas abre o bottom sheet e o botão fecha', (tester) async {
      stubAgreementsApi(harness.http);
      await pumpAgreementsPage(tester, surface: const Size(600, 1400));

      await tester.tap(find.text('taxes').first);
      await tester.pumpAndSettle();
      expect(find.byType(AgreementsTaxesInformationBottom), findsOneWidget);
      expect(find.text('taxes_information_title'), findsOneWidget);

      await tester.tap(find.text('agreements_ok_understood_button'));
      await tester.pumpAndSettle();
      expect(find.byType(AgreementsTaxesInformationBottom), findsNothing);
    });

    testWidgets('sem cotas mostra a mensagem de vazio', (tester) async {
      stubAgreementsApi(harness.http, allInfo: allInfoJson(quotes: []));
      await pumpAgreementsPage(tester);

      expect(find.text('you_have_no_quotas'), findsOneWidget);
      expect(find.byType(AgreementsQuotaAvailableWidget), findsNothing);
    });

    testWidgets('puxar para atualizar recarrega as cotas', (tester) async {
      stubAgreementsApi(harness.http);
      await pumpAgreementsPage(tester);
      final before = harness.http.requests.length;

      await tester.fling(find.byType(CustomScrollView).first, const Offset(0, 400), 1000);
      await tester.pumpAndSettle();

      expect(harness.http.requests.length, greaterThan(before));
    });

    testWidgets('erro genérico mostra o widget de erro com retry e voltar', (tester) async {
      harness.http.failAll();
      await pumpAgreementsPage(tester, observer: observer);
      expect(find.byType(ErrorHandlingWidget), findsOneWidget);

      stubAgreementsApi(harness.http);
      await tester.tap(find.text('error_handling_widget_button_reTry').first);
      await tester.pumpAndSettle();
      expect(find.byType(AgreementsQuotaAvailableWidget), findsWidgets);

      harness.http.failAll();
      await emitState(tester, bloc(), const AgreementsQuotaErrorState(errorMessageKey: 'x'));
      await tester.tap(find.text('error_handling_widget_button_back').first);
      await tester.pumpAndSettle();
      expect(findRoute('launcher'), findsOneWidget);
      expect(find.byType(AgreementsPage), findsNothing);
    });

    testWidgets('acordo indisponível (406) fecha a tela devolvendo exceção', (tester) async {
      harness.http.on('GET', allInfoPath,
          status: 406, body: {'status': 406, 'failure': 'agreement_not_avaliable_failure'});

      await pumpAgreementsPage(tester, observer: observer);

      expect(find.byType(AgreementsPage), findsNothing);
      expect(findRoute('launcher'), findsOneWidget);
      expect(observer.popped, isNotEmpty);
    });

    testWidgets('voltar pelo sistema fecha a página', (tester) async {
      stubAgreementsApi(harness.http);
      await pumpAgreementsPage(tester);

      await systemBack(tester);

      expect(find.byType(AgreementsPage), findsNothing);
      expect(findRoute('launcher'), findsOneWidget);
    });
  });

  group('aba acordos realizados', () {
    testWidgets('sem acordos mostra a mensagem de vazio e loga o evento da aba', (tester) async {
      stubAgreementsApi(harness.http);
      await pumpAgreementsPage(tester);

      await tester.tap(tabMade());
      await tester.pumpAndSettle();

      expect(find.text('agreements_made_title'), findsOneWidget);
      expect(find.text('you_have_no_agreements'), findsOneWidget);
      expect(fakeAnalytics.events.keys, contains('acordos_acessar_acordos_realizados'));
    });

    testWidgets('lista os acordos e bate com o golden', (tester) async {
      /// Corrigido (layout): a primeira `Row` de `_buildCanceledAndReleasedBody`
      /// (agreement_card.dart) usa Flexible + ellipsis e não estoura mais em
      /// telas estreitas (400px) com textos de status longos.
      stubAgreementsApi(
        harness.http,
        allInfo: allInfoJson(agreements: [
          agreementJson('a1', status: 'pending'),
          agreementJson('a2', status: 'completed'),
        ]),
      );
      await pumpAgreementsPage(tester, surface: const Size(400, 1000));

      await tester.tap(tabMade());
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(AgreementCard), findsNWidgets(2));
      expect(find.text('agreement_pending_status'), findsOneWidget);
      expect(find.text('agreement_end'), findsOneWidget);
      await expectLater(
        find.byType(AgreementsPage),
        matchesGoldenFile('goldens/agreements_page_made.png'),
      );
    });

    testWidgets('contexto de notificação anima para a aba e destaca o acordo', (tester) async {
      stubAgreementsApi(
        harness.http,
        allInfo: allInfoJson(agreements: [
          agreementJson('a1', status: 'pending'),
          agreementJson('a2', status: 'completed', notificationParameter: 'np2'),
        ]),
      );

      await pumpAgreementsPage(
        tester,
        arguments: AgreementsPageArgs(agreementsNotificationContext: 'np2'),
        surface: const Size(600, 1000),
      );

      final tabs = tester.widget<TabBar>(find.byType(TabBar));
      expect(tabs.controller!.index, 1);
      expect(find.byType(AgreementCard), findsNWidgets(2));
      expect(loaded().agreements[1].highlight, isTrue);
      expect(loaded().agreements[0].highlight, isFalse);
    });

    testWidgets('puxar para atualizar na aba de acordos recarrega', (tester) async {
      stubAgreementsApi(
        harness.http,
        allInfo: allInfoJson(agreements: [
          for (var i = 0; i < 5; i++) agreementJson('a$i', status: 'pending'),
        ]),
      );
      await pumpAgreementsPage(tester, surface: const Size(600, 600));
      await tester.tap(tabMade());
      await tester.pumpAndSettle();
      final before = harness.http.requests.length;

      await tester.fling(find.byType(CustomScrollView).last, const Offset(0, 400), 1000);
      await tester.pumpAndSettle();

      expect(harness.http.requests.length, greaterThan(before));
    });

    testWidgets('contexto de notificação sem acordo correspondente não destaca nada', (tester) async {
      stubAgreementsApi(
        harness.http,
        allInfo: allInfoJson(agreements: [agreementJson('a1', status: 'pending')]),
      );

      await pumpAgreementsPage(
        tester,
        arguments: AgreementsPageArgs(agreementsNotificationContext: 'nao-existe'),
      );

      expect(find.byType(AgreementCard), findsOneWidget);
      expect(loaded().agreements.single.highlight, isFalse);
    });

    testWidgets('voltar para a aba de cotas loga o evento e recarrega se necessário', (tester) async {
      stubAgreementsApi(harness.http);
      await pumpAgreementsPage(tester);

      // simula um bloc que ainda não fez a primeira chamada ao abrir a aba
      bloc().isFirstMadeCall = false;
      final before = harness.http.requests.length;
      await tester.tap(tabMade());
      await tester.pumpAndSettle();
      expect(bloc().isFirstMadeCall, isTrue);
      expect(harness.http.requests.length, greaterThan(before));

      await tester.tap(find.widgetWithText(Tab, 'agreements_available'));
      await tester.pumpAndSettle();
      expect(fakeAnalytics.events.keys, contains('acordos_acessar_cotas_disponiveis'));
    });

    testWidgets('acordo liberado abre a proposta aprovada uma única vez', (tester) async {
      stubAgreementsApi(
        harness.http,
        allInfo: allInfoJson(agreements: [agreementJson('a1', status: 'approved_by_manager')]),
      );
      await pumpAgreementsPage(tester);

      await tester.tap(tabMade());
      await tester.pumpAndSettle();
      expect(find.byType(AgreementsApprovedProposalBottom), findsOneWidget);
      expect(find.text('approved_proposal_title'), findsOneWidget);

      await tester.tap(find.text('agreements_ok_understood_button'));
      await tester.pumpAndSettle();
      expect(find.byType(AgreementsApprovedProposalBottom), findsNothing);

      // Recarregar não reabre o bottom sheet (firstLoad já consumido)
      bloc().getQuotaAvailable();
      await tester.pumpAndSettle();
      expect(find.byType(AgreementsApprovedProposalBottom), findsNothing);
    });

    testWidgets('acordo rejeitado abre o bottom sheet com o motivo', (tester) async {
      stubAgreementsApi(
        harness.http,
        allInfo: allInfoJson(agreements: [agreementJson('a1', status: 'rejected', reason: 'motivo x')]),
      );
      await pumpAgreementsPage(tester);

      await tester.tap(tabMade());
      await tester.pumpAndSettle();

      expect(find.byType(AgreementsRejectedProposalBottom), findsOneWidget);
      expect(find.text('rejected_proposal_title'), findsOneWidget);
      expect(find.text('rejected_proposal_returned_following_message'), findsOneWidget);
      expect(find.text('motivo x'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
      await tester.pumpAndSettle();
      expect(find.byType(AgreementsRejectedProposalBottom), findsNothing);
    });

    testWidgets('acordo cancelado automaticamente mostra a mensagem própria', (tester) async {
      stubAgreementsApi(
        harness.http,
        allInfo: allInfoJson(agreements: [agreementJson('a1', status: 'canceled_automatically')]),
      );
      await pumpAgreementsPage(tester);

      await tester.tap(tabMade());
      await tester.pumpAndSettle();

      expect(find.text('rejected_proposal_title_automatically'), findsOneWidget);
      expect(find.text('rejected_proposal_automatically_message'), findsOneWidget);
      await tester.tap(find.text('agreements_ok_understood_button'));
      await tester.pumpAndSettle();
      expect(find.byType(AgreementsRejectedProposalBottom), findsNothing);
    });

    testWidgets('tocar em um acordo liberado abre os detalhes', (tester) async {
      stubAgreementsApi(
        harness.http,
        allInfo: allInfoJson(agreements: [agreementJson('a1', status: 'completed')]),
      );
      harness.http.on('GET', detailsPath('a1'), body: agreementJson('a1', status: 'completed'));
      await pumpAgreementsPage(tester, observer: observer);

      await tester.tap(tabMade());
      await tester.pumpAndSettle();
      await tester.tap(find.text('agreement_end'));
      await tester.pumpAndSettle();

      expect(observer.pushedNames.last, ApplicationRoute.agreementDetail);
      expect(harness.http.requests.map((r) => r.url.path), contains(detailsPath('a1')));
    });
  });
}
