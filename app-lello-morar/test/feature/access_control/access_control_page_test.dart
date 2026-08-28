import 'package:cached_network_image/cached_network_image.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/access_control/presentation/bloc/access_control_state.dart';
import 'package:morar/feature/access_control/presentation/controllers/access_control_store.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_appointments_page.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_page.dart';
import 'package:morar/feature/access_control/presentation/widget/access_control_on_boarding.dart';
import 'package:morar/feature/access_control/presentation/widget/access_control_on_boarding_page.dart';
import 'package:morar/feature/access_control/presentation/widget/access_control_provider_tab.dart';
import 'package:morar/feature/access_control/presentation/widget/access_control_visitant_card.dart';
import 'package:morar/feature/access_control/presentation/widget/access_control_visitant_tab.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';
import 'access_control_test_helpers.dart';

void main() {
  late PageHarness harness;
  late RecordingNavigatorObserver observer;

  setUp(() async {
    harness = await installPageHarness();
    observer = RecordingNavigatorObserver();
  });

  AccessControlStore store() => harness.resolve<AccessControlStore>();

  Future<void> pumpAccess(
    WidgetTester tester, {
    AcessControlPageArgs? args,
    bool settle = true,
  }) =>
      pumpPage(
        tester,
        const AccessControlPage(),
        arguments: args ?? AcessControlPageArgs(isGeneric: false),
        observer: observer,
        settle: settle,
      );

  group('onboarding', () {
    testWidgets('aparece na primeira visita e pode ser fechado no fim',
        (tester) async {
      harness.http.on('GET', listPath, body: [visitantJson()]);

      await pumpAccess(tester);

      expect(find.byType(AccessControlOnBoardingWidget), findsOneWidget);
      expect(find.byType(Image), findsOneWidget); // logo Lello (não genérico)
      expect(find.text('access_control_onboarding_title_1'), findsOneWidget);
      expect(harness.http.requests, isEmpty);

      await tester.tap(find.text('next'));
      await tester.pumpAndSettle();
      expect(find.text('access_control_onboarding_title_2'), findsOneWidget);
      await tester.tap(find.text('next'));
      await tester.pumpAndSettle();
      expect(find.text('access_control_onboarding_title_3'), findsOneWidget);
      expect(find.text('login'), findsOneWidget);

      await tester.tap(find.text('access_control_close_onboarding'));
      await tester.pumpAndSettle();

      expect(find.byType(AccessControlOnBoardingWidget), findsNothing);
      expect(find.byType(AccessControlVisitantCard), findsOneWidget);
      expect(harness.http.requests.single.url.path, listPath);
    });

    testWidgets('botão "login" da última página também fecha', (tester) async {
      harness.http.on('GET', listPath, body: []);
      await pumpAccess(tester);
      await tester.tap(find.text('next'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('next'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('login'));
      await tester.pumpAndSettle();
      expect(find.text('access_control_empty_visitants_error'), findsOneWidget);
    });

    testWidgets('pode ser pulado logo na primeira página e usa logo do layout quando genérico',
        (tester) async {
      harness.http.on('GET', listPath, body: []);
      // O logo genérico é um CachedNetworkImage com spinner infinito no
      // placeholder: não dá para usar pumpAndSettle enquanto ele existir.
      await pumpAccess(tester, args: AcessControlPageArgs(isGeneric: true), settle: false);
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(AccessControlOnBoardingPage), findsWidgets);
      expect(find.byType(CachedNetworkImage), findsOneWidget);
      await tester.tap(find.text('access_control_exit_onboarding'));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.byType(AccessControlOnBoardingWidget), findsNothing);
      expect(find.byType(AccessControlVisitantTab), findsOneWidget);
    });

    testWidgets('não aparece quando o condomínio não usa biometria',
        (tester) async {
      harness.sessionBloc.session.condominium!.useFacialBiometric = false;
      harness.http.on('GET', listPath, body: []);
      await pumpAccess(tester);
      expect(find.byType(AccessControlOnBoardingWidget), findsNothing);
      expect(find.byType(AccessControlVisitantTab), findsOneWidget);
    });
  });

  group('listas', () {
    setUp(closeOnboardingPrefs);

    testWidgets('mostra visitantes e prestadores nas abas (golden)',
        (tester) async {
      harness.http.on('GET', listPath, body: [
        visitantJson(),
        visitantJson(id: 'g2', name: 'Ana Lima', authorizations: [
          authJson(id: 'a2', type: 'PONTUAL'),
          authJson(id: 'a3', type: 'ACESSO_GRANTED', end: today.add(const Duration(days: 3)), days: [2, 4]),
        ]),
        visitantJson(id: 'p1', name: 'Pedro Eletricista', type: 'SERVICE', business: 'Elétrica SA'),
        visitantJson(id: 'p2', name: 'Sem Firma', type: 'SERVICE'),
      ]);

      await pumpAccess(tester);

      expect(find.text('access_control_title'), findsOneWidget);
      expect(find.byType(AccessControlVisitantCard), findsNWidgets(3));
      expect(find.text('Carlos Souza'), findsOneWidget);
      expect(find.text('access_control_phone'), findsOneWidget);
      expect(find.text('Pontual'), findsOneWidget);
      expect(find.text('Recorrente'), findsOneWidget);
      expect(store().visitants, hasLength(2));
      expect(store().providers, hasLength(2));

      await expectLater(
        find.byType(AccessControlPage),
        matchesGoldenFile('goldens/access_control_page_visitants.png'),
      );

      await tester.tap(find.text('access_control_providers'));
      await tester.pumpAndSettle();

      expect(find.byType(AccessControlProviderTab), findsOneWidget);
      expect(find.text('Pedro Eletricista'), findsOneWidget);
      expect(find.text('Elétrica SA'), findsOneWidget);
      expect(find.text('access_control_provider'), findsOneWidget);

      await expectLater(
        find.byType(AccessControlPage),
        matchesGoldenFile('goldens/access_control_page_providers.png'),
      );
    });

    testWidgets('tabIndex dos argumentos abre direto a aba de prestadores',
        (tester) async {
      harness.http.on('GET', listPath, body: [visitantJson(id: 'p1', type: 'SERVICE')]);
      await pumpAccess(tester, args: AcessControlPageArgs(isGeneric: false, tabIndex: 1));
      expect(find.byType(AccessControlProviderTab), findsOneWidget);
      expect(find.byType(AccessControlVisitantCard), findsOneWidget);
    });

    testWidgets('lista vazia mostra mensagem e "novo visitante" abre o cadastro',
        (tester) async {
      harness.http.on('GET', listPath, body: []);
      await pumpAccess(tester);

      expect(find.text('access_control_empty_visitants_error'), findsOneWidget);
      await tester.tap(find.text('access_control_new_visitor'));
      await tester.pumpAndSettle();

      expect(observer.pushedNames.last, ApplicationRoute.accessControlInsert);
      final state = store().bloc.state as EditVisitantState;
      expect(state.visitant.type, 'GEST');
    });

    testWidgets('aba de prestadores vazia e "novo prestador"', (tester) async {
      harness.http.on('GET', listPath, body: [visitantJson()]);
      await pumpAccess(tester, args: AcessControlPageArgs(isGeneric: false, tabIndex: 1));

      expect(find.text('access_control_empty_provider_error'), findsOneWidget);
      await tester.tap(find.text('access_control_new_providers'));
      await tester.pumpAndSettle();

      expect(findRoute(ApplicationRoute.accessControlInsert), findsOneWidget);
      final state = store().bloc.state as EditVisitantState;
      expect(state.visitant.type, 'SERVICE');
    });

    testWidgets('botão "novo" da lista cheia também abre o cadastro', (tester) async {
      harness.http.on('GET', listPath, body: [
        visitantJson(),
        visitantJson(id: 'p1', type: 'SERVICE'),
      ]);
      await pumpAccess(tester);
      await tester.tap(find.text('access_control_new_visitor'));
      await tester.pumpAndSettle();
      expect(findRoute(ApplicationRoute.accessControlInsert), findsOneWidget);

      await resetApp(tester);
      await pumpAccess(tester, args: AcessControlPageArgs(isGeneric: false, tabIndex: 1));
      await tester.tap(find.text('access_control_new_providers'));
      await tester.pumpAndSettle();
      expect(findRoute(ApplicationRoute.accessControlInsert), findsOneWidget);
    });

    testWidgets('sem permissão de cadastrar esconde o botão "novo"', (tester) async {
      harness.sessionBloc.rbacAllowed = false;
      harness.http.on('GET', listPath, body: []);
      await pumpAccess(tester);
      expect(find.text('access_control_new_visitor'), findsNothing);
    });

    testWidgets('busca filtra visitantes e avisa quando não encontra',
        (tester) async {
      harness.http.on('GET', listPath, body: [
        visitantJson(),
        visitantJson(id: 'g2', name: 'Ana Lima', document: '98765432100'),
      ]);
      await pumpAccess(tester);
      expect(find.byType(AccessControlVisitantCard), findsNWidgets(2));

      await tester.enterText(find.byType(TextFormField), 'ana');
      await tester.pumpAndSettle();
      expect(store().bloc.state, isA<SearchingVisitantState>());
      expect(find.byType(AccessControlVisitantCard), findsOneWidget);
      expect(find.text('Ana Lima'), findsOneWidget);

      // busca por documento
      await tester.enterText(find.byType(TextFormField), '12345');
      await tester.pumpAndSettle();
      expect(find.text('Carlos Souza'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), 'zzz');
      await tester.pumpAndSettle();
      expect(find.text('access_control_no_visitants_found'), findsOneWidget);

      // texto vazio não altera o estado
      await tester.enterText(find.byType(TextFormField), '');
      await tester.pumpAndSettle();
      expect(find.text('access_control_no_visitants_found'), findsOneWidget);
    });

    testWidgets('busca de prestadores', (tester) async {
      harness.http.on('GET', listPath, body: [
        visitantJson(id: 'p1', name: 'Pedro', type: 'SERVICE'),
        visitantJson(id: 'p2', name: 'Paulo', type: 'SERVICE'),
      ]);
      await pumpAccess(tester, args: AcessControlPageArgs(isGeneric: false, tabIndex: 1));

      await tester.enterText(find.byType(TextFormField), 'paulo');
      await tester.pumpAndSettle();
      expect(store().bloc.state, isA<SearchingProviderState>());
      expect(find.byType(AccessControlVisitantCard), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), 'zzz');
      await tester.pumpAndSettle();
      expect(find.text('access_control_no_provider_found'), findsOneWidget);
    });

    testWidgets('tocar em um card abre a página de agendamentos',
        (tester) async {
      harness.http.on('GET', listPath, body: [visitantJson()]);
      await pumpAccess(tester);

      await tester.tap(find.byType(AccessControlVisitantCard));
      await tester.pumpAndSettle();

      expect(find.byType(AccessControlAppointmentsPage), findsOneWidget);
      expect(find.text('Carlos Souza'), findsOneWidget);
    });

    testWidgets('agendamentos vencidos ficam na seção de reativar e abrem detalhes',
        (tester) async {
      final yesterday = today.subtract(const Duration(days: 1));
      harness.http.on('GET', listPath, body: [
        visitantJson(authorizations: [
          authJson(type: 'PONTUAL', start: yesterday, end: yesterday),
        ]),
        visitantJson(id: 'p1', name: 'Pedro', type: 'SERVICE', authorizations: [
          authJson(type: 'ACESSO_GRANTED', start: yesterday, end: yesterday, days: [1]),
        ]),
      ]);
      await pumpAccess(tester);

      expect(find.text('access_control_reactive_schedule'), findsOneWidget);
      expect(find.byType(Opacity), findsWidgets);
      await tester.tap(find.byType(AccessControlVisitantCard));
      await tester.pumpAndSettle();
      expect(find.byType(AccessControlAppointmentsPage), findsOneWidget);

      await resetApp(tester);
      await pumpAccess(tester, args: AcessControlPageArgs(isGeneric: false, tabIndex: 1));
      expect(find.text('access_control_reactive_schedule'), findsOneWidget);
      await tester.tap(find.byType(AccessControlVisitantCard));
      await tester.pumpAndSettle();
      expect(find.byType(AccessControlAppointmentsPage), findsOneWidget);
    });

    testWidgets('contexto de notificação abre o visitante automaticamente',
        (tester) async {
      harness.http.on('GET', listPath, body: [
        visitantJson(notificationParameter: 'np1'),
      ]);
      await pumpAccess(
        tester,
        args: AcessControlPageArgs(isGeneric: false, acessControlNotificationContext: 'np1'),
      );
      expect(find.byType(AccessControlAppointmentsPage), findsOneWidget);
    });

    testWidgets('contexto de notificação de prestador abre pela aba de prestadores',
        (tester) async {
      harness.http.on('GET', listPath, body: [
        visitantJson(id: 'p1', name: 'Pedro', type: 'SERVICE'),
      ]);
      await pumpAccess(
        tester,
        args: AcessControlPageArgs(
          isGeneric: false,
          tabIndex: 1,
          acessControlNotificationContext: 'p1',
        ),
      );
      expect(find.byType(AccessControlAppointmentsPage), findsOneWidget);
      expect(find.text('Pedro'), findsOneWidget);
    });

    testWidgets('contexto de notificação de prestador vindo da aba de visitantes e vice-versa',
        (tester) async {
      harness.http.on('GET', listPath, body: [
        visitantJson(),
        visitantJson(id: 'p1', name: 'Pedro', type: 'SERVICE'),
      ]);
      await pumpAccess(
        tester,
        args: AcessControlPageArgs(isGeneric: false, acessControlNotificationContext: 'p1'),
      );
      expect(find.byType(AccessControlAppointmentsPage), findsOneWidget);
      expect(find.text('Pedro'), findsOneWidget);

      await resetApp(tester);
      await pumpAccess(
        tester,
        args: AcessControlPageArgs(isGeneric: false, tabIndex: 1, acessControlNotificationContext: 'g1'),
      );
      expect(find.byType(AccessControlAppointmentsPage), findsOneWidget);
      expect(find.text('Carlos Souza'), findsOneWidget);
    });

    testWidgets('visitante sem agendamentos mostra "nenhum encontrado" nas duas abas',
        (tester) async {
      harness.http.on('GET', listPath, body: [
        visitantJson(authorizations: []),
        visitantJson(id: 'p1', type: 'SERVICE', authorizations: []),
      ]);
      await pumpAccess(tester);
      expect(find.text('access_control_no_visitants_found'), findsOneWidget);
      expect(find.byType(AccessControlVisitantCard), findsNothing);

      await tester.tap(find.text('access_control_providers'));
      await tester.pumpAndSettle();
      expect(find.text('access_control_no_provider_found'), findsOneWidget);
    });

    testWidgets('card ativo de prestador abre os agendamentos', (tester) async {
      harness.http.on('GET', listPath, body: [
        visitantJson(id: 'p1', name: 'Pedro', type: 'SERVICE'),
      ]);
      await pumpAccess(tester, args: AcessControlPageArgs(isGeneric: false, tabIndex: 1));
      await tester.tap(find.byType(AccessControlVisitantCard));
      await tester.pumpAndSettle();
      expect(find.byType(AccessControlAppointmentsPage), findsOneWidget);
    });

    testWidgets('voltar do sistema é permitido (fecha a página)', (tester) async {
      harness.http.on('GET', listPath, body: [visitantJson()]);
      await pumpAccess(tester);
      await systemBack(tester);
      expect(tester.takeException(), isNull);
      expect(find.byType(AccessControlPage), findsNothing);
    });

    testWidgets('contexto de notificação desconhecido não navega', (tester) async {
      harness.http.on('GET', listPath, body: [visitantJson()]);
      await pumpAccess(
        tester,
        args: AcessControlPageArgs(isGeneric: false, acessControlNotificationContext: 'nada'),
      );
      expect(find.byType(AccessControlAppointmentsPage), findsNothing);
      expect(find.byType(AccessControlVisitantCard), findsOneWidget);
    });

    testWidgets('erro da api mostra o widget de erro e permite tentar de novo',
        (tester) async {
      harness.http.failAll();
      await pumpAccess(tester);

      expect(find.byType(ErrorHandlingWidget), findsOneWidget);
      expect(store().bloc.state, isA<AccessControlFailureState>());

      harness.http.on('GET', listPath, body: [visitantJson()]);
      await tester.tap(find.text('error_handling_widget_button_reTry').first);
      await tester.pumpAndSettle();
      expect(find.byType(AccessControlVisitantCard), findsOneWidget);
    });

    testWidgets('erro na aba de prestadores mostra mensagem simples', (tester) async {
      harness.http.failAll();
      await pumpAccess(tester, args: AcessControlPageArgs(isGeneric: false, tabIndex: 1));
      expect(find.text('warning_failed_message'), findsOneWidget);
    });

    testWidgets('botão de voltar do erro fecha a página', (tester) async {
      harness.http.failAll();
      await pumpAccess(tester);
      await tester.tap(find.text('back_to_the_previous_page'));
      await tester.pumpAndSettle();
      expect(observer.popped, isNotEmpty);
    });

    testWidgets('estado de loading mostra o indicador nas duas abas',
        (tester) async {
      harness.http.on('GET', listPath, body: [visitantJson()]);
      await pumpAccess(tester);
      final bloc = store().bloc;

      await emitAndPump(tester, bloc, const AccessControlLoadingState());
      expect(find.byType(LoadingWidget), findsOneWidget);

      setLoadedState(store(), providers: [gest(id: 'p1', type: 'SERVICE')]);
      await tester.pumpAndSettle();
      await tester.tap(find.text('access_control_providers'));
      await tester.pumpAndSettle();
      await emitAndPump(tester, bloc, const AccessControlLoadingState());
      expect(find.byType(LoadingWidget), findsOneWidget);
    });

    testWidgets('excluir agendamento leva para a tela de atenção',
        (tester) async {
      harness.http.on('GET', listPath, body: [visitantJson()]);
      await pumpAccess(tester);

      await emitState(tester, store().bloc, const DeleteVisitState(isVisitant: true));

      expect(observer.pushedNames.last, ApplicationRoute.accessControlAttention);
      expect(findRoute(ApplicationRoute.accessControlAttention), findsOneWidget);
    });

    testWidgets('falha ao excluir agendamento mostra flushbar', (tester) async {
      harness.http.on('GET', listPath, body: [visitantJson()]);
      await pumpAccess(tester);

      await emitState(
        tester,
        store().bloc,
        DeleteFailureVisitState(
          visitants: store().visitants,
          providers: store().providers,
          visitant: gest(),
          model: auth(),
        ),
      );

      expect(find.text('warning_failed_message'), findsOneWidget);
      expect(find.byType(AccessControlVisitantCard), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
    });
  });
}
