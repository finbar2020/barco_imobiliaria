import 'dart:convert';

import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_rbac.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:morar/feature/reservation/domain/entity/space_available_hours.dart';
import 'package:morar/feature/reservation/presentation/bloc/reservation_bloc.dart';
import 'package:morar/feature/reservation/presentation/bloc/reservation_state.dart';
import 'package:morar/feature/reservation/presentation/controller/reservation_controller.dart';
import 'package:morar/feature/reservation/presentation/page/reservation_deleted_page.dart';
import 'package:morar/feature/reservation/presentation/page/reservation_new_reserve_page.dart';
import 'package:morar/feature/reservation/presentation/page/reservation_page.dart';
import 'package:morar/feature/reservation/presentation/page/reservation_schedules_page.dart';
import 'package:morar/feature/reservation/presentation/widget/reservation_bottom_sheet_widget.dart';
import 'package:morar/feature/reservation/presentation/widget/reservation_card_widget.dart';
import 'package:morar/feature/reservation/presentation/widget/reservation_dialog.dart';
import 'package:morar/feature/reservation/presentation/widget/reservation_moves_dialog.dart';
import 'package:morar/feature/reservation/presentation/widget/reservation_reserve_dialog.dart';
import 'package:morar/feature/reservation/presentation/widget/reservation_schedule_card_widget.dart';
import 'package:morar/feature/reservation/presentation/widget/reservation_success_dialog.dart';
import 'package:morar/feature/reservation/presentation/widget/reservation_term_responsability_dialog.dart';
import 'package:morar/feature/session/presentation/bloc/session_state.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';
import 'reservation_page_helpers.dart';

void main() {
  late PageHarness harness;
  late RecordingNavigatorObserver observer;
  late List<String> reviewCalls;

  setUp(() async {
    harness = await installPageHarness();
    observer = RecordingNavigatorObserver();
    reviewCalls = installFakeInAppReview();
  });

  List<Map<String, dynamic>> threeSpaces() => [
        spaceJson(id: 'free', name: 'SALAO DE FESTAS'),
        spaceJson(
          id: 'paid',
          name: 'CHURRASQUEIRA',
          typeId: 'B',
          chargeable: true,
          price: 150,
          paymentMethod: 'billet',
        ),
        spaceJson(id: 'mov', name: 'Mudanca', typeId: 'M', typeDescription: 'Mudanca'),
      ];

  /// `TableCalendar` é genérico: `find.byType` não casa com `TableCalendar<dynamic>`.
  final calendarFinder = find.byWidgetPredicate((w) => w is TableCalendar);

  /// Emite [state] sem `pumpAndSettle` (para estados com animação infinita).
  /// O listener do BlocConsumer roda em microtask: são precisos dois pumps
  /// para o frame com o novo estado ser desenhado.
  Future<void> emitAndPump(WidgetTester tester, ReservationBloc bloc, ReservationState state) async {
    await emitState(tester, bloc, state, settle: false);
    await tester.pump();
  }

  /// Corrigido: ao fechar o diálogo de sucesso, `_showCalendar` chama
  /// `AppReview.call` com o contexto do Navigator (que continua vivo) em vez
  /// do contexto da aba "nova reserva", já descartada pelo `animateToTab(1)`.
  /// Fecha o diálogo por [button] e confere que a página já está na aba de
  /// agendamentos, que a avaliação do app foi consultada e que nenhum erro
  /// ("Looking up a deactivated widget's ancestor") foi lançado.
  Future<void> closeSuccessDialog(WidgetTester tester, String button) async {
    expect(find.byType(ReservationSuccessDialog), findsOneWidget);
    expect(find.byType(ReservationNewReservePage), findsNothing);
    expect(find.byType(ReservationSchedulesPage), findsOneWidget);

    await tester.tap(find.text(button));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(ReservationSuccessDialog), findsNothing);
    expect(find.byType(ReservationSchedulesPage), findsOneWidget);
    expect(reviewCalls, contains('isAvailable'));
  }

  /// Abre a bottom sheet do calendário do espaço [name] e espera carregar.
  Future<void> openCalendar(WidgetTester tester, String name) async {
    await tester.tap(find.text(name));
    await tester.pumpAndSettle();
    expect(find.byType(ReservationBottomSheetWidget), findsOneWidget);
  }

  /// Escolhe o primeiro horário do dropdown da bottom sheet.
  Future<void> pickFirstHour(WidgetTester tester) async {
    await tester.tap(find.byType(DropdownButton<SpaceAvailableHours>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('das 10:00h às 14:00h').last);
    await tester.pumpAndSettle();
  }

  group('ReservationPage', () {
    testWidgets('mostra as abas, lista os espaços e filtra por categoria', (tester) async {
      stubReservationApi(harness.http, spaces: threeSpaces());
      await installReservationBloc(harness);

      await pumpReservationPage(tester, observer: observer);

      expect(find.text('reserves'), findsOneWidget);
      expect(find.text('reserve_new'), findsOneWidget);
      expect(find.text('reserve_schedule'), findsOneWidget);
      expect(find.byType(ReservationCardWidget), findsNWidgets(3));
      // O bloc normaliza os nomes (capitaliza e traduz "Mudanca").
      expect(find.text('Salao de festas'), findsOneWidget);
      expect(find.text('Churrasqueira'), findsOneWidget);
      /// Corrigido: `ReservationBloc.wordAdjust` devolve "Mudança" (o literal
      /// no fonte tinha o encoding quebrado: "MudanÃ§a").
      expect(find.text('Mudança'), findsOneWidget);
      expect(find.text('MudanÃ§a'), findsNothing);
      expect(find.text('space_filter_free'), findsOneWidget);
      expect(find.text('space_filter_paid'), findsOneWidget);
      expect(find.text('space_filter_moving'), findsOneWidget);

      await expectLater(
        find.byType(ReservationPage),
        matchesGoldenFile('goldens/reservation_page.png'),
      );

      final controller = harness.resolve<ReservationController>();
      await tester.tap(find.text('space_filter_free'));
      await tester.pumpAndSettle();
      expect(controller.isFreeAreaSelected, isTrue);
      expect(find.byType(ReservationCardWidget), findsOneWidget);
      expect(find.text('Salao de festas'), findsOneWidget);

      await tester.tap(find.text('space_filter_paid'));
      await tester.pumpAndSettle();
      expect(find.byType(ReservationCardWidget), findsNWidgets(2));

      await tester.tap(find.text('space_filter_free'));
      await tester.pumpAndSettle();
      expect(controller.isFreeAreaSelected, isFalse);
      expect(find.byType(ReservationCardWidget), findsOneWidget);
      expect(find.text('Churrasqueira'), findsOneWidget);

      await tester.tap(find.text('space_filter_moving'));
      await tester.pumpAndSettle();
      expect(find.byType(ReservationCardWidget), findsNWidgets(2));

      await tester.tap(find.text('space_filter_paid'));
      await tester.tap(find.text('space_filter_moving'));
      await tester.pumpAndSettle();
      expect(find.byType(ReservationCardWidget), findsNWidgets(3));

      final requests = harness.http.requests.map((r) => r.url.path).toList();
      expect(requests, contains(spacesPath));
      expect(requests, contains(reservationsPath));
      expect(harness.http.requests.firstWhere((r) => r.url.path == reservationsPath).url.queryParameters['unitId'], unitId);
    });

    testWidgets('em 400px de largura os filtros e a legenda não estouram', (tester) async {
      /// Corrigido: os três chips de filtro ficam num `Wrap`
      /// (`reservation_new_reserve_page.dart`) e quebram de linha em telas
      /// estreitas; a legenda do calendário (`reservation_bottom_sheet_widget`)
      /// usa `Flexible` e encolhe com reticências em vez de estourar.
      stubReservationApi(harness.http, spaces: threeSpaces());
      await installReservationBloc(harness);

      await pumpReservationPage(tester, surface: const Size(400, 800));

      expect(tester.takeException(), isNull);
      expect(find.byType(ChoiceChip), findsOneWidget);
      expect(find.byType(FilterChip), findsNWidgets(2));
      expect(find.byType(ReservationCardWidget), findsNWidgets(3));

      await openCalendar(tester, 'Salao de festas');
      expect(tester.takeException(), isNull);
      expect(find.text('blockade'), findsOneWidget);
      expect(find.text('space_reserved_a'), findsOneWidget);
      expect(find.text('space_reservation_vacancy'), findsOneWidget);
    });

    testWidgets('com uma única categoria não mostra os filtros', (tester) async {
      stubReservationApi(harness.http, spaces: [spaceJson()]);
      await installReservationBloc(harness);

      await pumpReservationPage(tester);

      expect(find.byType(ReservationCardWidget), findsOneWidget);
      expect(find.byType(ChoiceChip), findsNothing);
      expect(find.byType(FilterChip), findsNothing);
    });

    testWidgets('sem rbac nenhum espaço é exibido', (tester) async {
      harness.sessionBloc.allowedRbacs = {};
      stubReservationApi(harness.http, spaces: threeSpaces());
      await installReservationBloc(harness);

      await pumpReservationPage(tester);

      expect(find.byType(ReservationCardWidget), findsNothing);
      expect(find.text('reserves_condominium_error'), findsOneWidget);
      expect(harness.sessionBloc.rbacChecked, contains(ApplicationRbac.morarReservasAreasNovasReservasGratuitas));
    });

    testWidgets('rbac de novas reservas oculta o card via CircuitBreakerWidget', (tester) async {
      // O bloc só filtra pelos rbacs de "novas reservas"; aqui liberamos tudo
      // no bloc e negamos só no widget para cobrir o ramo `rbacEnabled == false`.
      stubReservationApi(harness.http, spaces: threeSpaces());
      await installReservationBloc(harness);
      await pumpReservationPage(tester);
      expect(find.byType(ReservationCardWidget), findsNWidgets(3));

      harness.sessionBloc.allowedRbacs = {ApplicationRbac.morarReservasAreasNovasReservasPagas};
      await tester.tap(find.text('space_filter_free'));
      await tester.pumpAndSettle();
      expect(find.byType(ReservationCardWidget), findsNothing);
    });

    testWidgets('estados inicial e loading mostram indicadores', (tester) async {
      stubReservationApi(harness.http);
      final bloc = await installReservationBloc(harness);
      await pumpReservationPage(tester);

      await emitAndPump(tester, bloc, ReservationEmptyState());
      expect(find.byType(CircularProgressIndicator), findsWidgets);
      expect(find.byType(LoadingWidget), findsNothing);

      await emitAndPump(tester, bloc, LoadingSpaceState());
      expect(find.byType(LoadingWidget), findsOneWidget);

      // Estado não tratado pela aba: cai no `Container()`.
      await emitAndPump(tester, bloc, ReservationDeletedState(session: testSession(), reservations: []));
      expect(find.byType(ReservationCardWidget), findsNothing);
      expect(find.byType(LoadingWidget), findsNothing);
      // O listener da aba de agendamentos navega para a página de cancelado.
      await tester.pump();
    });

    testWidgets('erro na API mostra ErrorHandlingWidget e tentar de novo recarrega', (tester) async {
      harness.http.failAll();
      await installReservationBloc(harness);

      await pumpReservationPage(tester, observer: observer);
      expect(find.byType(ErrorHandlingWidget), findsWidgets);

      stubReservationApi(harness.http);
      await tester.tap(find.text('error_handling_widget_button_reTry').first);
      await tester.pumpAndSettle();

      expect(find.byType(ReservationCardWidget), findsOneWidget);
    });

    testWidgets('botão voltar do erro fecha a página', (tester) async {
      harness.http.failAll();
      await installReservationBloc(harness);
      await pumpReservationPage(tester, observer: observer);

      await tester.tap(find.text('error_handling_widget_button_back').first);
      await tester.pumpAndSettle();

      expect(find.byType(ReservationPage), findsNothing);
      expect(find.byKey(const Key('launcher')), findsOneWidget);
    });

    testWidgets('selectedTab nos argumentos abre a aba de agendamentos', (tester) async {
      stubReservationApi(harness.http, reservations: [reservationJson()]);
      await installReservationBloc(harness);

      await pumpReservationPage(tester, args: ReservationPageArgs(selectedTab: 1));

      expect(find.byType(ReservationSchudeleCardWidget), findsOneWidget);
    });

    testWidgets('contexto de notificação abre agendamentos e destaca a reserva', (tester) async {
      stubReservationApi(harness.http, reservations: [reservationJson(id: 7), reservationJson(id: 8)]);
      final bloc = await installReservationBloc(harness);
      final args = ReservationPageArgs(reserveNotificationContext: '8');

      await pumpReservationPage(tester, args: args);

      expect(find.byType(ReservationSchudeleCardWidget), findsNWidgets(2));
      final highlighted = bloc.state.reservations!.where((r) => r.highlight).toList();
      expect(highlighted.single.id, 8);
      // O contexto é consumido uma única vez.
      expect(args.reserveNotificationContext, isNull);
    });

    testWidgets('contexto de notificação sem reserva correspondente não destaca nada', (tester) async {
      stubReservationApi(harness.http, reservations: [reservationJson(id: 7)]);
      final bloc = await installReservationBloc(harness);

      await pumpReservationPage(tester, args: ReservationPageArgs(reserveNotificationContext: 'nope'));

      expect(bloc.state.reservations!.any((r) => r.highlight), isFalse);
    });

    testWidgets('trocar de aba pelo TabBar e voltar pela AppBar', (tester) async {
      stubReservationApi(harness.http, reservations: [reservationJson()]);
      await installReservationBloc(harness);
      await pumpReservationPage(tester, observer: observer);

      await tester.tap(find.text('reserve_schedule'));
      await tester.pumpAndSettle();
      expect(find.byType(ReservationSchudeleCardWidget), findsOneWidget);

      await tester.tap(find.text('reserve_new'));
      await tester.pumpAndSettle();
      expect(find.byType(ReservationCardWidget), findsOneWidget);

      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.byType(ReservationPage), findsNothing);
      expect(observer.popped, isNotEmpty);
    });
  });

  group('Fluxo de nova reserva', () {
    testWidgets('reserva gratuita: calendário, horário, termos, confirmação e sucesso', (tester) async {
      stubReservationApi(harness.http, spaces: threeSpaces());
      harness.http.on('POST', postPath('free'), body: postedReservationJson(areaId: 'free'));
      final bloc = await installReservationBloc(harness);
      await pumpReservationPage(tester, observer: observer);

      await openCalendar(tester, 'Salao de festas');
      expect(find.text('reserve_choose_date'), findsOneWidget);
      expect(calendarFinder, findsOneWidget);
      expect(find.text('blockade'), findsOneWidget);
      expect(find.text('space_reserved_a'), findsOneWidget);
      expect(find.text('space_reservation_vacancy'), findsOneWidget);
      expect(find.text('available_hours'), findsOneWidget);
      expect(bloc.state, isA<LoadedCalendarState>());

      // Sem horário escolhido o botão não faz nada.
      await tester.tap(find.text('reserve_button_title'));
      await tester.pumpAndSettle();
      expect(find.byType(ReservationDialog), findsNothing);

      await pickFirstHour(tester);
      await tester.tap(find.text('reserve_button_title'));
      await tester.pumpAndSettle();

      expect(bloc.state, isA<LoadedDialogState>());
      expect(find.byType(ReservationReserveDialog), findsOneWidget);
      expect(find.descendant(of: find.byType(ReservationReserveDialog), matching: find.text('free')), findsOneWidget);
      expect(find.text('space_registration_terms_use'), findsOneWidget);
      expect(find.text('Edifício Lello - 101'), findsOneWidget);

      // Termo de uso abre o diálogo com o texto do termo.
      await tester.tap(find.text('space_registration_usage_term'));
      await tester.pumpAndSettle();
      expect(find.byType(ReservationTermResponsabilityDialog), findsOneWidget);
      expect(find.text('Termo de uso do espaço'), findsOneWidget);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(find.byType(ReservationTermResponsabilityDialog), findsNothing);

      // Sem aceitar os termos, confirmar é ignorado.
      await tester.tap(find.text('CONFIRM'));
      await tester.pumpAndSettle();
      expect(bloc.state, isA<LoadedDialogState>());

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      await tester.tap(find.text('CONFIRM'));
      await tester.pumpAndSettle();

      // Sucesso: fecha diálogo e bottom sheet, mostra o diálogo de sucesso e
      // recarrega os espaços.
      expect(find.byType(ReservationBottomSheetWidget), findsNothing);
      expect(find.byType(ReservationSuccessDialog), findsOneWidget);
      expect(find.text('space_reservation_reservation_success'), findsOneWidget);
      final post = harness.http.requests.singleWhere((r) => r.method == 'POST');
      final body = jsonDecode(post.body) as Map<String, dynamic>;
      expect(body['space_id'], 'free');
      expect(body['unit_id'], unitId);
      expect(body['flag_utility_term'], isTrue);
      expect(body['reservation_start_date'], contains('T10:00'));
      expect(body['reservation_end_date'], contains('T14:00'));

      // Depois do sucesso a página muda para a aba de agendamentos; fechar o
      // diálogo pede a avaliação do app.
      await closeSuccessDialog(tester, 'ok');
    });

    testWidgets('reserva de mudança usa o diálogo de mudança', (tester) async {
      stubReservationApi(harness.http, spaces: threeSpaces());
      harness.http.on('POST', postPath('mov'), body: postedReservationJson(areaId: 'mov', reservationType: 'M'));
      final bloc = await installReservationBloc(harness);
      await pumpReservationPage(tester);

      await openCalendar(tester, 'Mudança');
      await pickFirstHour(tester);
      await tester.tap(find.text('reserve_button_title'));
      await tester.pumpAndSettle();

      expect(find.byType(ReservationMovesDialog), findsOneWidget);
      expect(find.text('Edifício Lello - 101'), findsOneWidget);

      await tester.tap(find.text('CONFIRM'));
      await tester.pumpAndSettle();

      expect(bloc.state, isA<LoadedSpaceState>());
      expect(find.byType(ReservationSuccessDialog), findsOneWidget);
      final post = harness.http.requests.singleWhere((r) => r.method == 'POST');
      expect(post.url.path, postPath('mov'));
    });

    testWidgets('cancelar no diálogo de mudança fecha só o diálogo', (tester) async {
      stubReservationApi(harness.http, spaces: threeSpaces());
      await installReservationBloc(harness);
      await pumpReservationPage(tester);

      await openCalendar(tester, 'Mudança');
      await pickFirstHour(tester);
      await tester.tap(find.text('reserve_button_title'));
      await tester.pumpAndSettle();
      expect(find.byType(ReservationMovesDialog), findsOneWidget);

      await tester.tap(find.text('CANCEL'));
      await tester.pumpAndSettle();
      expect(find.byType(ReservationMovesDialog), findsNothing);
      expect(find.byType(ReservationBottomSheetWidget), findsOneWidget);
    });

    testWidgets('reserva paga mostra preço, forma de cobrança e prazo de cancelamento', (tester) async {
      stubReservationApi(harness.http, spaces: threeSpaces());
      harness.http.on(
        'POST',
        postPath('paid'),
        body: postedReservationJson(
          areaId: 'paid',
          receipt: 'nr1',
          billetCode: '12345',
          billetPeriod: daysFromNow(5),
        ),
      );
      await installReservationBloc(harness);
      await pumpReservationPage(tester);

      await openCalendar(tester, 'Churrasqueira');
      await pickFirstHour(tester);
      await tester.tap(find.text('reserve_button_title'));
      await tester.pumpAndSettle();

      expect(find.byType(ReservationReserveDialog), findsOneWidget);
      expect(
        find.descendant(of: find.byType(ReservationReserveDialog), matching: find.textContaining('150,00')),
        findsOneWidget,
      );
      expect(find.byType(RichText), findsWidgets);
      expect(find.textContaining('space_registration_usage_term_message'), findsOneWidget);

      // Cancelar fecha o diálogo de confirmação.
      await tester.tap(find.text('CANCEL'));
      await tester.pumpAndSettle();
      expect(find.byType(ReservationReserveDialog), findsNothing);
      expect(find.byType(ReservationBottomSheetWidget), findsOneWidget);

      // Depois de cancelar a sheet fica sem `stateCreatedAt`: reservar fecha a sheet.
      await tester.tap(find.text('reserve_button_title'));
      await tester.pumpAndSettle();
      expect(find.byType(ReservationBottomSheetWidget), findsNothing);

      // Abre de novo e confirma: sucesso pago com boleto.
      await openCalendar(tester, 'Churrasqueira');
      await pickFirstHour(tester);
      await tester.tap(find.text('reserve_button_title'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('space_registration_agree_with_terms'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('CONFIRM'));
      await tester.pumpAndSettle();

      expect(find.byType(ReservationSuccessDialog), findsOneWidget);
      expect(find.textContaining('income_billet_detail_expiration'), findsOneWidget);
      expect(find.text('income_billet_detail_open'), findsOneWidget);
      expect(find.text('billet_copy_barcode'), findsOneWidget);
      expect(find.text('pay_later'), findsOneWidget);
      await closeSuccessDialog(tester, 'pay_later');
    });

    testWidgets('reserva paga por taxa mostra percentual da cota', (tester) async {
      stubReservationApi(harness.http, spaces: [
        spaceJson(id: 'quota', name: 'QUADRA', chargeable: true, percentageTax: 12.5, paymentMethod: 'quota'),
      ]);
      harness.http.on('POST', postPath('quota'), body: postedReservationJson(areaId: 'quota'));
      await installReservationBloc(harness);
      await pumpReservationPage(tester);

      await openCalendar(tester, 'Quadra');
      await pickFirstHour(tester);
      await tester.tap(find.text('reserve_button_title'));
      await tester.pumpAndSettle();

      expect(
        find.descendant(of: find.byType(ReservationReserveDialog), matching: find.text('12.5% of_condominium_quota')),
        findsOneWidget,
      );

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      await tester.tap(find.text('CONFIRM'));
      await tester.pumpAndSettle();

      // Pago sem boleto na resposta: mostra a forma de pagamento e "ok".
      expect(find.byType(ReservationSuccessDialog), findsOneWidget);
      expect(find.text('space_registration_fee_billet'), findsOneWidget);
      await closeSuccessDialog(tester, 'ok');
    });

    testWidgets('erro 406 no POST mostra a mensagem do servidor', (tester) async {
      stubReservationApi(harness.http);
      harness.http.on('POST', postPath('sp1'), status: 406, body: {'status': 406, 'detail': 'reserve_limit_date'});
      final bloc = await installReservationBloc(harness);
      await pumpReservationPage(tester);

      await openCalendar(tester, 'Salao de festas');
      await pickFirstHour(tester);
      await tester.tap(find.text('reserve_button_title'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      await tester.tap(find.text('CONFIRM'));
      await tester.pumpAndSettle();

      expect(bloc.state, isA<FailureDialogState>());
      expect(find.text('chat_error_title!'), findsOneWidget);
      expect(find.text('reserve_limit_date'), findsOneWidget);

      await tester.tap(find.text('ok'));
      await tester.pumpAndSettle();
      expect(find.byType(ReservationDialog), findsNothing);
      expect(find.byType(ReservationBottomSheetWidget), findsOneWidget);

      // Depois da falha a sheet perde o `stateCreatedAt`: reservar fecha a sheet.
      await tester.tap(find.text('reserve_button_title'));
      await tester.pumpAndSettle();
      expect(find.byType(ReservationBottomSheetWidget), findsNothing);
    });

    testWidgets('erro desconhecido no POST usa a mensagem padrão', (tester) async {
      stubReservationApi(harness.http);
      harness.http.on('POST', postPath('sp1'), status: 500, body: {'message': 'x'});
      await installReservationBloc(harness);
      await pumpReservationPage(tester);

      await openCalendar(tester, 'Salao de festas');
      await pickFirstHour(tester);
      await tester.tap(find.text('reserve_button_title'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      await tester.tap(find.text('CONFIRM'));
      await tester.pumpAndSettle();

      expect(find.text('reserves_reserve_not_possible'), findsOneWidget);
    });

    testWidgets('espaço bloqueado para inadimplentes mostra o diálogo de contato', (tester) async {
      final launcher = installFakeUrlLauncher();
      final platformCalls = mockPlatformChannel();
      final session = testSession(
        me: testMe(condominiums: [
          testCondominium(blocks: [
            testBlock(units: [testUnity(compliant: false)])
          ])
        ]),
      );
      harness.sessionBloc.session = session;
      harness.sessionBloc.currentState = SessionLoadedState(session);
      // Corrigido: a linha "later / whatsapp" do `_buildErrorDialog` cabe em
      // 400px (itens em Flexible com reticências).
      stubReservationApi(harness.http, spaces: [spaceJson(blockedForDefaulters: true)]);
      await installReservationBloc(harness);
      await pumpReservationPage(tester);

      await tester.tap(find.text('Salao de festas'));
      await tester.pumpAndSettle();

      expect(find.text('reserves_not_possible_make'), findsOneWidget);
      expect(find.byType(ReservationBottomSheetWidget), findsNothing);

      // Copiar e-mail de suporte.
      await tester.tap(find.text(FlavorConfig.config.supportEmail));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(platformCalls.map((c) => c.method), contains('Clipboard.setData'));
      expect(find.text('email_copied'), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));

      // WhatsApp.
      await tester.tap(find.text('REGISTRATION_LELLO_WARNING_NO_DATA_BTN'));
      await tester.pumpAndSettle();
      expect(launcher.launched.single, contains('wa.me'));

      await tester.tap(find.text('LATER'));
      await tester.pumpAndSettle();
      expect(find.text('reserves_not_possible_make'), findsNothing);
    });

    testWidgets('espaço bloqueado para acordo com unidade em acordo mostra o diálogo', (tester) async {
      final session = testSession(
        me: testMe(condominiums: [
          testCondominium(blocks: [
            testBlock(units: [testUnity(agreement: true)])
          ])
        ]),
      );
      harness.sessionBloc.session = session;
      harness.sessionBloc.currentState = SessionLoadedState(session);
      // Corrigido: a linha "later / whatsapp" do `_buildErrorDialog` cabe em
      // 400px (itens em Flexible com reticências).
      stubReservationApi(harness.http, spaces: [spaceJson(blockedForSettlers: true)]);
      await installReservationBloc(harness);
      await pumpReservationPage(tester);

      await tester.tap(find.text('Salao de festas'));
      await tester.pumpAndSettle();

      expect(find.text('reserves_not_possible_make'), findsOneWidget);
    });

    testWidgets('espaço sem regras de bloqueio abre o calendário', (tester) async {
      /// Corrigido: `_checkCanReserveSpace` trata `blockedForDefaulters` e
      /// `blockedForSettlers` nulos como `false`; se a API omitir os campos o
      /// toque no card abre o calendário em vez de lançar null-check.
      stubReservationApi(harness.http, spaces: [spaceJson(blockedForDefaulters: null, blockedForSettlers: null)]);
      await installReservationBloc(harness);
      await pumpReservationPage(tester);

      await openCalendar(tester, 'Salao de festas');
      expect(tester.takeException(), isNull);
    });

    testWidgets('card com foto usa CachedNetworkImage', (tester) async {
      stubReservationApi(harness.http, spaces: [spaceJson(pictureUrl: 'http://img/space.png')]);
      await installReservationBloc(harness);

      await pumpReservationPage(tester, settle: false);
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });
  });

  group('Calendário da bottom sheet', () {
    TableCalendar calendar(WidgetTester tester) => tester.widget<TableCalendar>(calendarFinder);

    testWidgets('dias bloqueados, reservados ou antes do mínimo limpam os horários', (tester) async {
      stubReservationApi(harness.http, spaces: [spaceJson(minRange: 3)]);
      final bloc = await installReservationBloc(harness);
      await pumpReservationPage(tester);
      await openCalendar(tester, 'Salao de festas');

      // Com mínimo de 3 dias, hoje está antes do mínimo: sem horários.
      expect(find.byType(DropdownButton<SpaceAvailableHours>), findsNothing);
      final loaded = bloc.state as LoadedCalendarState;
      expect(loaded.hours, isEmpty);

      final hoursBefore = harness.http.requests.where((r) => r.url.path == hoursPath('sp1')).length;

      // Dia bloqueado.
      calendar(tester).onDaySelected!(daysFromNow(1), daysFromNow(1));
      await tester.pumpAndSettle();
      expect((bloc.state as LoadedCalendarState).hours, isEmpty);
      // Dia já reservado.
      calendar(tester).onDaySelected!(daysFromNow(2), daysFromNow(2));
      await tester.pumpAndSettle();
      // Antes do mínimo.
      calendar(tester).onDaySelected!(today, today);
      await tester.pumpAndSettle();
      expect(harness.http.requests.where((r) => r.url.path == hoursPath('sp1')).length, hoursBefore);

      // Dia livre depois do mínimo: busca horários.
      calendar(tester).onDaySelected!(daysFromNow(5), daysFromNow(5));
      await tester.pumpAndSettle();
      expect(harness.http.requests.where((r) => r.url.path == hoursPath('sp1')).length, hoursBefore + 1);
      expect(find.byType(DropdownButton<SpaceAvailableHours>), findsOneWidget);
      expect(find.text('choose_an_option'), findsOneWidget);

      calendar(tester).onPageChanged!(daysFromNow(40));
      await tester.pumpAndSettle();
    });

    testWidgets('erro 406 ao buscar horários mostra o alerta e limpa o erro', (tester) async {
      stubReservationApi(harness.http);
      final bloc = await installReservationBloc(harness);
      await pumpReservationPage(tester);
      await openCalendar(tester, 'Salao de festas');

      harness.http.on(
        'GET',
        '/condominiums/$condominiumId/spaces/reservation/calendar/hours/*',
        status: 406,
        body: {'status': 406, 'detail': 'reserve_limit_date'},
      );
      calendar(tester).onDaySelected!(daysFromNow(5), daysFromNow(5));
      await tester.pumpAndSettle();

      expect(find.text('chat_error_title!'), findsOneWidget);
      expect(find.text('reserve_limit_date'), findsOneWidget);
      final state = bloc.state as LoadedCalendarState;
      expect(state.error, isNull);

      await tester.tap(find.text('ok'));
      await tester.pumpAndSettle();
      expect(find.text('chat_error_title!'), findsNothing);
      expect(find.byType(ReservationBottomSheetWidget), findsOneWidget);
    });

    testWidgets('erro 406 sem detalhe usa "not_acceptable" como chave', (tester) async {
      stubReservationApi(harness.http);
      await installReservationBloc(harness);
      await pumpReservationPage(tester);
      await openCalendar(tester, 'Salao de festas');

      harness.http.on(
        'GET',
        '/condominiums/$condominiumId/spaces/reservation/calendar/hours/*',
        status: 406,
        body: {'status': 406},
      );
      calendar(tester).onDaySelected!(daysFromNow(5), daysFromNow(5));
      await tester.pumpAndSettle();

      expect(find.text('not_acceptable'), findsOneWidget);
    });

    testWidgets('erro genérico ao buscar horários só zera a lista', (tester) async {
      stubReservationApi(harness.http);
      final bloc = await installReservationBloc(harness);
      await pumpReservationPage(tester);
      await openCalendar(tester, 'Salao de festas');

      harness.http.on('GET', '/condominiums/$condominiumId/spaces/reservation/calendar/hours/*', status: 500);
      calendar(tester).onDaySelected!(daysFromNow(5), daysFromNow(5));
      await tester.pumpAndSettle();

      expect(find.text('chat_error_title!'), findsNothing);
      expect((bloc.state as LoadedCalendarState).hours, isEmpty);
    });

    testWidgets('cabeçalho abre o seletor de mês', (tester) async {
      stubReservationApi(harness.http);
      await installReservationBloc(harness);
      await pumpReservationPage(tester);
      await openCalendar(tester, 'Salao de festas');

      // Cancelar: nada muda.
      calendar(tester).onHeaderTapped!(today);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      // OK no mês atual: o dia 1 é anterior a hoje → volta para o primeiro dia.
      calendar(tester).onHeaderTapped!(today);
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(calendarFinder, findsOneWidget);

      // Escolhe o mês seguinte.
      final next = DateTime(today.year, today.month + 1, 1);
      calendar(tester).onHeaderTapped!(today);
      await tester.pumpAndSettle();
      await tester.tap(find.text(DateFormat.MMM('pt_BR').format(next)).last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(calendar(tester).focusedDay.month, next.month);
    });

    testWidgets('erro ao carregar o calendário mostra a mensagem de erro', (tester) async {
      stubReservationApi(harness.http);
      harness.http.on('GET', '/condominiums/$condominiumId/spaces/reservation/calendar/day/*', status: 500);
      final bloc = await installReservationBloc(harness);
      await pumpReservationPage(tester);

      await openCalendar(tester, 'Salao de festas');

      expect(bloc.state, isA<FailureCalendarState>());
      expect(find.text('error_unknown'), findsOneWidget);
    });

    testWidgets('estado de loading do calendário e seta para fechar', (tester) async {
      stubReservationApi(harness.http);
      final bloc = await installReservationBloc(harness);
      await pumpReservationPage(tester);
      await openCalendar(tester, 'Salao de festas');

      await emitAndPump(
        tester,
        bloc,
        LoadingCalendarState(spaces: bloc.state.spaces, reservations: bloc.state.reservations!, session: testSession()),
      );
      expect(find.byType(LoadingWidget), findsOneWidget);

      // Estado não tratado pela sheet cai no Container vazio.
      await emitAndPump(tester, bloc, ReservationEmptyState());
      expect(calendarFinder, findsNothing);

      // Horários carregando: indicador no lugar do dropdown; mês carregando:
      // calendário ignora toques.
      await emitAndPump(
        tester,
        bloc,
        LoadedCalendarState(
          calendarResponse: bloc.calendarResponse!,
          hours: bloc.hoursResponse!,
          spaces: bloc.listSpaces,
          reservations: bloc.listReservations,
          session: testSession(),
          selectedDate: today,
          loadedHours: false,
          loadedMonth: false,
        ),
      );
      expect(find.byType(DropdownButton<SpaceAvailableHours>), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsWidgets);
      expect(
        tester.widget<IgnorePointer>(find.ancestor(of: calendarFinder, matching: find.byType(IgnorePointer)).first).ignoring,
        isTrue,
      );

      // Volta ao calendário e fecha pela seta.
      await emitState(
        tester,
        bloc,
        LoadedCalendarState(
          calendarResponse: bloc.calendarResponse!,
          hours: bloc.hoursResponse!,
          spaces: bloc.listSpaces,
          reservations: bloc.listReservations,
          session: testSession(),
          selectedDate: today,
        ),
      );
      await tester.tap(find.byIcon(Icons.keyboard_arrow_down).first);
      await tester.pumpAndSettle();
      expect(find.byType(ReservationBottomSheetWidget), findsNothing);
    });

    testWidgets('dia selecionado sem horários mantém o dropdown escondido', (tester) async {
      stubReservationApi(harness.http, hours: []);
      await installReservationBloc(harness);
      await pumpReservationPage(tester);
      await openCalendar(tester, 'Salao de festas');

      expect(find.byType(DropdownButton<SpaceAvailableHours>), findsNothing);
      expect(find.text('reserve_button_title'), findsNothing);
    });
  });

  group('Aba de agendamentos', () {
    testWidgets('sem reservas mostra a mensagem de vazio', (tester) async {
      stubReservationApi(harness.http, reservations: []);
      await installReservationBloc(harness);

      await pumpReservationPage(tester, args: ReservationPageArgs(selectedTab: 1));

      expect(find.text('reserves_dont_booked'), findsOneWidget);
      expect(find.byType(SubtitleWidget), findsNothing);
    });

    testWidgets('sem espaços nem reservas mostra o erro de condomínio', (tester) async {
      stubReservationApi(harness.http, spaces: [], reservations: []);
      await installReservationBloc(harness);

      await pumpReservationPage(tester, args: ReservationPageArgs(selectedTab: 1));

      expect(find.text('reserves_condominium_error'), findsWidgets);
    });

    testWidgets('lista as reservas com legenda, valor e forma de pagamento', (tester) async {
      stubReservationApi(
        harness.http,
        spaces: [spaceJson(id: 'paid', chargeable: true, price: 100, paymentMethod: 'billet')],
        reservations: [
          reservationJson(
            id: 1,
            areaId: 'paid',
            reservationValue: 100,
            flagChargingForm: 'BILLET',
            charginFormDescription: 'BILLET',
            billetPeriod: daysFromNow(5),
          ),
          reservationJson(id: 2, areaId: 'paid', idStatus: 90),
          reservationJson(id: 3, areaId: 'outro', idStatus: 7620, reservationValue: 50, flagChargingForm: 'QUOTA', charginFormDescription: 'QUOTA', billetPeriod: daysFromNow(5)),
        ],
      );
      await installReservationBloc(harness);

      await pumpReservationPage(tester, args: ReservationPageArgs(selectedTab: 1), surface: const Size(600, 1400));

      expect(find.byType(SubtitleWidget), findsOneWidget);
      expect(find.text('Legenda:'), findsOneWidget);
      expect(find.byType(ReservationSchudeleCardWidget), findsNWidgets(3));
      expect(find.textContaining('refund_value'), findsOneWidget);
      expect(find.text('space_reservation_payment_billet'), findsOneWidget);
      // Reserva cancelada não tem botão de cancelar.
      expect(find.text('cancel'), findsNWidgets(2));
      expect(find.textContaining('Vence em'), findsWidgets);
    });

    testWidgets('cancelar uma reserva chama a API e abre a página de cancelado', (tester) async {
      final start = daysFromNow(3);
      stubReservationApi(harness.http, reservations: [reservationJson(id: 5, start: start, canCancelUntil: daysFromNow(1))]);
      harness.http.on('DELETE', deletePath('5', 'A'));
      final bloc = await installReservationBloc(harness);
      await pumpReservationPage(tester, args: ReservationPageArgs(selectedTab: 1), observer: observer);

      await tester.tap(find.text('cancel'));
      await tester.pumpAndSettle();

      expect(harness.http.requests.any((r) => r.method == 'DELETE' && r.url.path == deletePath('5', 'A')), isTrue);
      expect(find.byType(ReservationDeletedPage), findsOneWidget);
      expect(find.text('reserves_cancelled'), findsOneWidget);
      expect(find.text('Edifício Lello - 101'), findsOneWidget);
      // Recarrega a lista depois de cancelar.
      expect(bloc.state, isA<LoadedSpaceState>());

      await tester.tap(find.text('ok'));
      await tester.pumpAndSettle();
      expect(find.byType(ReservationDeletedPage), findsNothing);
      expect(find.byType(ReservationPage), findsOneWidget);
    });

    testWidgets('erro ao cancelar mostra o widget de erro', (tester) async {
      stubReservationApi(harness.http, reservations: [reservationJson(id: 5)]);
      harness.http.on('DELETE', deletePath('5', 'A'), status: 500);
      await installReservationBloc(harness);
      await pumpReservationPage(tester, args: ReservationPageArgs(selectedTab: 1));

      await tester.tap(find.text('cancel'));
      await tester.pumpAndSettle();

      expect(find.byType(ErrorHandlingWidget), findsWidgets);
    });

    testWidgets('reserva com prazo de cancelamento vencido não pode ser cancelada', (tester) async {
      stubReservationApi(harness.http, reservations: [reservationJson(id: 5, canCancelUntil: daysFromNow(-1))]);
      await installReservationBloc(harness);
      await pumpReservationPage(tester, args: ReservationPageArgs(selectedTab: 1));

      expect(find.text('cancel'), findsNothing);
    });

    testWidgets('botão pagar baixa o boleto; sem boleto não navega', (tester) async {
      stubReservationApi(
        harness.http,
        reservations: [
          reservationJson(id: 5, flagChargingStatus: 'OPEN', billetCode: '123', receipt: 'nr5', flagChargingForm: 'BILLET', reservationValue: 10, billetPeriod: daysFromNow(4)),
        ],
      );
      harness.http.on('GET', '/billet/nr5', status: 500);
      await installReservationBloc(harness);
      await pumpReservationPage(tester, args: ReservationPageArgs(selectedTab: 1));

      expect(find.text('pay'), findsOneWidget);
      await tester.tap(find.text('pay'));
      await tester.pumpAndSettle();

      expect(harness.http.requests.any((r) => r.url.path == '/billet/nr5'), isTrue);
      expect(find.byType(ReservationPage), findsOneWidget);
    });

    testWidgets('rbac de cancelar/pagar esconde os botões', (tester) async {
      harness.sessionBloc.allowedRbacs = {
        ApplicationRbac.morarReservasAreasNovasReservasGratuitas,
        ApplicationRbac.morarReservasAreasAgendamentosGratuitas,
        ApplicationRbac.morarReservasAreasAgendamentosPagas,
      };
      stubReservationApi(
        harness.http,
        reservations: [reservationJson(id: 5, flagChargingStatus: 'OPEN', billetCode: '123', receipt: 'nr5')],
      );
      await installReservationBloc(harness);
      await pumpReservationPage(tester, args: ReservationPageArgs(selectedTab: 1));

      expect(find.byType(ReservationSchudeleCardWidget), findsOneWidget);
      expect(find.text('cancel'), findsNothing);
      expect(find.text('pay'), findsNothing);
    });

    testWidgets('estado de loading na aba de agendamentos', (tester) async {
      stubReservationApi(harness.http, reservations: [reservationJson()]);
      final bloc = await installReservationBloc(harness);
      await pumpReservationPage(tester, args: ReservationPageArgs(selectedTab: 1));

      await emitAndPump(tester, bloc, LoadingSpaceState());
      expect(find.byType(LoadingWidget), findsOneWidget);

      await emitAndPump(tester, bloc, ReservationEmptyState());
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });
  });

  group('ReservationNewReservePage isolada', () {
    testWidgets('estado desconhecido renderiza vazio', (tester) async {
      stubReservationApi(harness.http);
      final bloc = await installReservationBloc(harness);
      await pumpPage(
        tester,
        BlocProvider<ReservationBloc>.value(value: bloc, child: const Scaffold(body: ReservationNewReservePage())),
      );
      expect(find.byType(ReservationCardWidget), findsOneWidget);

      await emitState(tester, bloc, ReservationDeletedState(session: testSession(), reservations: []));
      expect(find.byType(ReservationCardWidget), findsNothing);
    });

    testWidgets('ReservationSchedulesPage com estado desconhecido renderiza vazio', (tester) async {
      stubReservationApi(harness.http, reservations: [reservationJson()]);
      final bloc = await installReservationBloc(harness);
      await pumpPage(
        tester,
        BlocProvider<ReservationBloc>.value(
          value: bloc,
          child: const Scaffold(body: ReservationSchedulesPage(arguments: null)),
        ),
      );
      expect(find.byType(ReservationSchudeleCardWidget), findsOneWidget);

      await emitState(tester, bloc, ReservationSendSuccessState(bloc.state.reservations!.first, null));
      expect(find.byType(ReservationSchudeleCardWidget), findsNothing);
    });
  });
}
