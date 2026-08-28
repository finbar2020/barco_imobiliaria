import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_completed_request.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_filter_requests_status.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_requests_filter.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_type.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_request_item_actions/pages/comfort_my_request_item_actions_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/bloc/comfort_my_requests_state.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/controller/comfort_my_request_controller.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/pages/comfort_my_requests_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/widgets/comfort_request_item.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/widgets/comfort_requests_filter.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/bloc/comfort_partners_state.dart';

import '../../../helpers/pump_app.dart';
import 'comfort_requests_test_support.dart';

void main() {
  late ComfortRequestsHarness harness;
  late RecordingNavigatorObserver observer;

  setUp(() async {
    harness = await installComfortHarness();
    observer = RecordingNavigatorObserver();
    harness.mockSubcategories();
    harness.mockAllPartners();
  });

  late ComfortMyRequestsController controller;

  Future<void> pump(WidgetTester tester, {bool settle = true}) async {
    await pumpPage(
      tester,
      ComfortMyRequestsPage(appContainer: harness.container),
      arguments: ComfortMyRequestsPageArgs(harness.partners),
      observer: observer,
      settle: settle,
      surface: const Size(600, 1000),
      locOverrides: sheetLoc,
    );
    controller = harness.myRequests;
  }

  final filterButton = find.ancestor(
      of: svgAsset('assets/ic_filter.svg'), matching: find.byType(IconButton));

  testWidgets('lista as solicitações com status e busca subcategorias',
      (tester) async {
    harness.mockMyRequests([
      requestJson('r1'),
      requestJson('r2', status: 'resent', partnerTitle: 'Lavanderia'),
      requestJson('r3', status: 'canceled', partnerTitle: 'Mercado'),
    ]);

    await pump(tester);

    expect(find.text('comfort_my_requests'), findsOneWidget);
    expect(find.byType(ComfortRequestItem), findsNWidgets(3));
    expect(find.text('Academia Lello'), findsOneWidget);
    expect(find.text('comfort_request_status_sended'), findsOneWidget);
    expect(find.text('comfort_request_status_resent'), findsOneWidget);
    expect(find.text('comfort_request_status_canceled'), findsOneWidget);
    expect(find.byIcon(Icons.keyboard_arrow_down), findsNWidgets(3));
    expect(harness.paths, containsAll([harness.subcategoriesPath, harness.myRequestsPath]));
    expect(harness.queryOf(harness.myRequestsPath), {'page': '1', 'pageSize': '10'});
    expect(controller.subcategories.map((e) => e.comfortType),
        [ComfortType.gym, ComfortType.cleaning]);
    expect(controller.comfortMyRequestsBloc.state, isA<LoadedMyRequestsState>());
    expect(controller.comfortMyRequestsTimer!.userType, 'owner');
    await expectLater(find.byType(ComfortMyRequestsPage),
        matchesGoldenFile('goldens/comfort_my_requests_page.png'));
  });

  testWidgets('sem solicitações mostra o vazio (com e sem filtro)',
      (tester) async {
    harness.mockMyRequests([]);
    await pump(tester);
    expect(find.text('comfort_my_requests_empty'), findsOneWidget);

    controller.filter = ComfortRequestsFilter(status: ComfortFilterRequestStatus.sended);
    controller.updateAll();
    await tester.pumpAndSettle();
    expect(find.text('comfort_request_filter_result_empty'), findsOneWidget);
    expect(harness.queryOf(harness.myRequestsPath)['status'], 'sended');
  });

  testWidgets('mostra o indicador de carregamento antes da resposta',
      (tester) async {
    harness.mockMyRequests([requestJson('r1')]);
    await pump(tester, settle: false);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsWidgets);
    await tester.pumpAndSettle();
    expect(find.byType(ComfortRequestItem), findsOneWidget);
  });

  testWidgets('erro mostra o widget de erro; tentar de novo recarrega',
      (tester) async {
    harness.mockMyRequests([requestJson('r1')]);
    await pump(tester);

    // ignore: invalid_use_of_visible_for_testing_member
    controller.comfortMyRequestsBloc.emit(const ErrorComfortMyRequestsState(
        errorMessageKey: 'comfort_get_my_requests_error',
        errorCode: '500',
        errorDescription: 'x'));
    await tester.pumpAndSettle();
    expect(find.byType(ErrorHandlingWidget), findsOneWidget);
    expect(find.byType(ComfortRequestItem), findsNothing);

    harness.http.requests.clear();
    await tester.tap(find.text('error_handling_widget_button_reTry'));
    await tester.pumpAndSettle();

    /// Corrigido: no estado de erro a lista paginada não está montada, então
    /// o retry reinicia o `PagingController` E dispara a busca da primeira
    /// página; a tela sai do erro e volta a listar.
    expect(harness.paths, contains(harness.myRequestsPath));
    expect(find.byType(ErrorHandlingWidget), findsNothing);
    expect(find.byType(ComfortRequestItem), findsOneWidget);

    // Volta ao erro para exercitar o botão "voltar".
    // ignore: invalid_use_of_visible_for_testing_member
    controller.comfortMyRequestsBloc.emit(const ErrorComfortMyRequestsState(
        errorMessageKey: 'comfort_get_my_requests_error',
        errorCode: '500',
        errorDescription: 'x'));
    await tester.pumpAndSettle();
    expect(find.byType(ErrorHandlingWidget), findsOneWidget);

    await tester.tap(find.text('error_handling_widget_button_back'));
    await tester.pumpAndSettle();
    // Voltar recarrega os parceiros e faz pop da tela.
    expect(harness.paths, contains(harness.allPartnersPath));
    expect(observer.popped, hasLength(1));
  });

  testWidgets('filtro pelo drawer aplica status, mostra o chip e o chip limpa',
      (tester) async {
    harness.mockMyRequests([requestJson('r1')]);
    harness.myRequests.filter = ComfortRequestsFilter(
        status: ComfortFilterRequestStatus.all, subcategories: ComfortType.all);
    await pump(tester);

    await tester.tap(filterButton);
    await tester.pumpAndSettle();
    expect(find.byType(ComfortRequestsFilterWidget), findsOneWidget);
    expect(find.byType(FilterItem), findsNothing);

    await tester.tap(find.byType(DropdownButton<String>).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('comfort_request_filter_status_sent').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('find'));
    await tester.tap(find.text('find'));
    await tester.pumpAndSettle();

    expect(find.byType(ComfortRequestsFilterWidget), findsNothing);
    expect(controller.filter!.status, ComfortFilterRequestStatus.sended);
    expect(harness.queryOf(harness.myRequestsPath)['status'], 'sended');
    final chip = tester.widget<FilterItem>(find.byType(FilterItem));
    expect(chip.title, 'comfort_request_filter_status');
    expect(chip.content, 'comfort_request_filter_status_sent');

    // O toque de remoção fica no ícone do chip.
    await tester.tap(find.descendant(
        of: find.byType(FilterItem), matching: find.byType(InkWell)));
    await tester.pumpAndSettle();
    expect(controller.filter!.status, ComfortFilterRequestStatus.all);
    expect(find.byType(FilterItem), findsNothing);
    expect(harness.queryOf(harness.myRequestsPath).containsKey('status'), isFalse);
  });

  /// Corrigido: o filtro padrão do drawer vive no State da página, então
  /// sobrevive aos rebuilds (a página depende do `ModalRoute` e reconstrói ao
  /// abrir/fechar o menu do dropdown) e a seleção não é mais descartada.
  testWidgets('sem filtro no controller a seleção do drawer sobrevive',
      (tester) async {
    harness.mockMyRequests([requestJson('r1')]);
    await pump(tester);
    await tester.tap(filterButton);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButton<String>).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('comfort_request_filter_status_sent').last);
    await tester.pumpAndSettle();

    final widget = tester.widget<ComfortRequestsFilterWidget>(
        find.byType(ComfortRequestsFilterWidget));
    expect(widget.filter.status, ComfortFilterRequestStatus.sended);
    expect(find.text('comfort_request_filter_status_sent'), findsOneWidget);

    await tester.ensureVisible(find.text('find'));
    await tester.tap(find.text('find'));
    await tester.pumpAndSettle();
    expect(find.byType(ComfortRequestsFilterWidget), findsNothing);
    expect(controller.filter!.status, ComfortFilterRequestStatus.sended);
    expect(harness.queryOf(harness.myRequestsPath)['status'], 'sended');
  });

  testWidgets('drawer reaproveita o filtro atual e as subcategorias',
      (tester) async {
    harness.mockMyRequests([]);
    // O drawer é construído no build da página: o filtro precisa existir antes.
    harness.myRequests.filter = ComfortRequestsFilter(
        status: ComfortFilterRequestStatus.resent, subcategories: ComfortType.gym);
    await pump(tester);
    await tester.tap(filterButton);
    await tester.pumpAndSettle();
    final widget = tester.widget<ComfortRequestsFilterWidget>(
        find.byType(ComfortRequestsFilterWidget));
    expect(widget.filter, same(controller.filter));
    expect(widget.subcategories, hasLength(2));
    expect(find.text('comfort_request_filter_status_resent'), findsOneWidget);
    expect(find.text('comfort_gym'), findsOneWidget);
  });

  testWidgets('toque no item abre as ações e fechar retoma o temporizador',
      (tester) async {
    harness.mockMyRequests([requestJson('r1'), requestJson('r2', status: 'canceled')]);
    await pump(tester);

    await tester.tap(find.byType(ComfortRequestItem).first);
    await tester.pumpAndSettle();
    expect(find.byType(ComfortMyRequestItemActionsBottomSheet), findsOneWidget);
    expect(controller.isBottomSheetOpen, isTrue);
    expect(controller.comfortMyRequestsBottomSheetTimer!.userType, 'owner');

    await tester.tap(find.byIcon(Icons.keyboard_arrow_down_sharp));
    await tester.pumpAndSettle();
    expect(find.byType(ComfortMyRequestItemActionsBottomSheet), findsNothing);
    expect(controller.isBottomSheetOpen, isFalse);

    // Item cancelado não abre o sheet.
    await tester.tap(find.byType(ComfortRequestItem).last, warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(find.byType(ComfortMyRequestItemActionsBottomSheet), findsNothing);
    final opacity = tester.widget<Opacity>(find.descendant(
        of: find.byType(ComfortRequestItem).last, matching: find.byType(Opacity)));
    expect(opacity.opacity, 0.6);
  });

  testWidgets('reenviar pelo sheet atualiza toda a lista', (tester) async {
    harness.mockMyRequests([requestJson('r1')]);
    installFakeToast();
    await pump(tester);

    await tester.tap(find.byType(ComfortRequestItem));
    await tester.pumpAndSettle();
    harness.http.on('PUT', harness.resendPath('r1'),
        body: requestJson('r1', status: 'resent'));
    harness.mockMyRequests([requestJson('r1', status: 'resent')]);
    await tester.tap(find.text('comfort_request_resend_button'));
    await tester.pumpAndSettle();
    expect(find.text('comfort_request_actions_resend_success_title'), findsOneWidget);

    await tester.tap(find.text('ok'));
    await tester.pumpAndSettle();
    expect(find.text('comfort_request_status_resent'), findsOneWidget);
    expect(harness.paths.where((p) => p == harness.myRequestsPath).length, 2);
  });

  testWidgets('avaliar pelo sheet atualiza só o item', (tester) async {
    harness.mockMyRequests([requestJson('r1'), requestJson('r2')]);
    installFakeToast();
    await pump(tester);

    await tester.tap(find.byType(ComfortRequestItem).last);
    await tester.pumpAndSettle();
    harness.http.on('POST', harness.updatePath('r2'), body: requestJson('r2', rating: 5));
    await setRating(tester, 5);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.byType(ComfortMyRequestItemActionsBottomSheet), findsNothing);
    expect(controller.myRequests[1].rating, 5);
    expect(controller.pagingController.value.pages!.first[1].rating, 5);
    expect(harness.paths.where((p) => p == harness.myRequestsPath).length, 1);
    // Consome o timer do toast.
    await tester.pump(const Duration(seconds: 2));
  });

  testWidgets('pagina ao rolar e mostra o erro de nova página com retry',
      (tester) async {
    harness.mockMyRequests(List.generate(10, (i) => requestJson('r$i')));
    await pump(tester);
    // A primeira página cheia já dispara a segunda (mesmo mock: +10).
    expect(controller.myRequests, hasLength(20));
    expect(harness.queryOf(harness.myRequestsPath)['page'], '2');

    harness.mockMyRequests([requestJson('r20')]);
    final list = find.byType(PagedListView<int, ComfortCompletedRequest>);
    await tester.fling(list, const Offset(0, -1500), 3000);
    await tester.pumpAndSettle();
    expect(controller.myRequests, hasLength(21));
    expect(harness.queryOf(harness.myRequestsPath)['page'], '3');
    // A página curta encerra a paginação na tentativa seguinte.
    expect(controller.pagingController.value.hasNextPage, isFalse);

    // Erro em página seguinte: indicador com retry que chama fetchNextPage.
    final state = controller.pagingController.value;
    controller.pagingController.value =
        state.copyWith(error: 'falhou', hasNextPage: true, isLoading: false);
    await tester.pumpAndSettle();
    await tester.fling(list, const Offset(0, -1500), 3000);
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.refresh), findsOneWidget);
    expect(find.text('error_handling_widget_subtitle'), findsOneWidget);
    expect(find.text('error_handling_widget_button_reTry'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.refresh), findsNothing);
    expect(controller.pagingController.value.error, isNull);
    expect(controller.pagingController.value.hasNextPage, isFalse);
  });

  testWidgets('ciclo de vida do app para e retoma os temporizadores',
      (tester) async {
    harness.mockMyRequests([]);
    await pump(tester);
    final binding = tester.binding;

    binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pumpAndSettle();
    binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pumpAndSettle();
    expect(harness.getToken.calls, 2);

    controller.isBottomSheetOpen = true;
    controller.comfortMyRequestsBottomSheetAnalyticsTimerStart();
    await tester.pumpAndSettle();
    binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pumpAndSettle();
    binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    binding.handleAppLifecycleStateChanged(AppLifecycleState.detached);
    await tester.pumpAndSettle();
    controller.isBottomSheetOpen = false;
    binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    binding.handleAppLifecycleStateChanged(AppLifecycleState.detached);
    await tester.pumpAndSettle();
    expect(harness.getToken.calls, 5);
    binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('com o sheet aberto o ciclo de vida é ignorado', (tester) async {
    harness.mockMyRequests([requestJson('r1')]);
    await pump(tester);
    await tester.tap(find.byType(ComfortRequestItem));
    await tester.pumpAndSettle();
    final calls = harness.getToken.calls;
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pumpAndSettle();
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    expect(harness.getToken.calls, calls);
  });

  testWidgets('voltar para o temporizador e recarrega os parceiros',
      (tester) async {
    harness.mockMyRequests([]);
    await pump(tester);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(harness.paths, contains(harness.allPartnersPath));
    expect(harness.partners.comfortPartnersBloc.state,
        isA<LoadedComfortPartnersState>());
    expect(tester.takeException(), isNull);
  });

  testWidgets('desmontar a página reinicia o controller no container',
      (tester) async {
    harness.mockMyRequests([]);
    await pump(tester);
    final before = controller;
    await tester.pumpWidget(const SizedBox());
    expect(harness.myRequests, isNot(same(before)));
  });
}
