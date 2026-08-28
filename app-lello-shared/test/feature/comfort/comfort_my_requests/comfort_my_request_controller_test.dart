import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_filter_requests_status.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_request_message_type.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_requests_filter.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_type.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/bloc/comfort_my_requests_state.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/controller/comfort_my_request_controller.dart';

import '../../../helpers/firebase_mocks.dart';
import '../../../helpers/pump_app.dart';
import 'comfort_requests_test_support.dart';

void main() {
  late ComfortRequestsHarness harness;
  late ComfortMyRequestsController controller;

  setUp(() async {
    harness = await installComfortHarness();
    controller = harness.buildMyRequestsController();
  });
  tearDown(() => controller.comfortMyRequestsBloc.close());

  group('filtro', () {
    test('isFilterActive considera datas, status e subcategorias', () {
      expect(controller.isFilterActive(), isFalse);
      controller.filter = ComfortRequestsFilter(
          status: ComfortFilterRequestStatus.all, subcategories: ComfortType.all);
      expect(controller.isFilterActive(), isFalse);
      controller.filter!.startDate = DateTime(2026, 1, 1);
      expect(controller.isFilterActive(), isTrue);
      controller.filter = ComfortRequestsFilter(status: ComfortFilterRequestStatus.sended);
      expect(controller.isFilterActive(), isTrue);
      controller.filter = ComfortRequestsFilter(subcategories: ComfortType.gym);
      expect(controller.isFilterActive(), isTrue);
      controller.filter = ComfortRequestsFilter(endDate: DateTime(2026, 1, 1));
      expect(controller.isFilterActive(), isTrue);
    });

    testWidgets('generateFilters monta os chips e cada remoção recarrega',
        (tester) async {
      harness.mockMyRequests([]);
      late BuildContext ctx;
      await pumpApp(tester, Builder(builder: (c) {
        ctx = c;
        return const SizedBox();
      }));

      expect(controller.generateFilters(ctx), isEmpty);

      controller.filter = ComfortRequestsFilter(
        startDate: DateTime(2026, 1, 1),
        endDate: DateTime(2026, 1, 31),
        status: ComfortFilterRequestStatus.canceled,
        subcategories: ComfortType.gym,
      );
      final filters = controller.generateFilters(ctx);
      expect(filters.keys, [
        'filter_item_datarange_title',
        'comfort_request_filter_status',
        'comfort_request_filter_subcategories',
      ]);
      expect(filters['filter_item_datarange_title']!.keys.first,
          'from: 1/1/2026 to: 1/31/2026');
      expect(filters['comfort_request_filter_status']!.keys.first,
          'comfort_request_filter_status_canceled');
      expect(filters['comfort_request_filter_subcategories']!.keys.first,
          'comfort_gym');

      // Cada callback limpa o seu filtro e chama getMyRequests (refresh).
      await filters['filter_item_datarange_title']!.values.first();
      expect(controller.filter!.startDate, isNull);
      expect(controller.filter!.endDate, isNull);
      await filters['comfort_request_filter_status']!.values.first();
      expect(controller.filter!.status, ComfortFilterRequestStatus.all);
      await filters['comfort_request_filter_subcategories']!.values.first();
      expect(controller.filter!.subcategories, ComfortType.all);
      expect(controller.generateFilters(ctx), isEmpty);

      // Só um dos lados do período não gera chip.
      controller.filter = ComfortRequestsFilter(startDate: DateTime(2026, 1, 1));
      expect(controller.generateFilters(ctx), isEmpty);
    });
  });

  group('getSubcategories', () {
    test('sucesso acumula as subcategorias e emite Loaded', () async {
      harness.mockSubcategories(['gym', 'cleaning']);
      await controller.getSubcategories();
      await flush();
      expect(controller.comfortMyRequestsBloc.state,
          isA<LoadedSubcategoriesMyRequestState>());
      expect(controller.subcategories.map((e) => e.comfortType),
          [ComfortType.gym, ComfortType.cleaning]);

      /// Corrigido: a lista é reescrita a cada chamada, sem duplicar as
      /// subcategorias já carregadas.
      await controller.getSubcategories();
      await flush();
      expect(controller.subcategories.length, 2);
      expect(controller.subcategories.map((e) => e.comfortType),
          [ComfortType.gym, ComfortType.cleaning]);
    });

    test('falha emite erro com chave genérica', () async {
      harness.http.failAll();
      await controller.getSubcategories();
      await flush();
      final state =
          controller.comfortMyRequestsBloc.state as ErrorComfortMyRequestsState;

      /// Corrigido: a chave de erro é uma chave de tradução real.
      expect(state.errorMessageKey, 'comfort_get_subcategories_error');
    });
  });

  group('paginação (getMyRequests / _fetchPage)', () {
    test('primeira página limpa a lista, emite Loading e Loaded', () async {
      harness.mockMyRequests([requestJson('r1'), requestJson('r2')]);
      final states = <ComfortMyRequestsState>[];
      final sub = controller.comfortMyRequestsBloc.stream.listen(states.add);

      await fetchPageGuarded(controller.pagingController);
      await sub.cancel();

      expect(controller.myRequests.map((e) => e.idRequest), ['r1', 'r2']);
      expect(states.first, const LoadingComfortMyRequestsState());
      expect(states.last, isA<LoadedMyRequestsState>());
      expect(harness.queryOf(harness.myRequestsPath),
          {'page': '1', 'pageSize': '10'});
      expect(controller.pagingController.value.pages!.single.length, 2);
    });

    test('filtro ativo vai na query e "all" é omitido', () async {
      harness.mockMyRequests([]);
      controller.filter = ComfortRequestsFilter(
        startDate: DateTime(2026, 1, 1),
        endDate: DateTime(2026, 1, 31),
        status: ComfortFilterRequestStatus.sended,
        subcategories: ComfortType.gym,
      );
      await fetchPageGuarded(controller.pagingController);
      final query = harness.queryOf(harness.myRequestsPath);
      expect(query['status'], 'sended');
      expect(query['requestType'], 'gym');
      expect(query['startDate'], startsWith('2026-01-01'));
      expect(query['endDate'], startsWith('2026-01-31'));

      controller.filter = ComfortRequestsFilter(
          status: ComfortFilterRequestStatus.all, subcategories: ComfortType.all);
      await controller.getMyRequests();
      await fetchPageGuarded(controller.pagingController);
      final query2 = harness.queryOf(harness.myRequestsPath);
      expect(query2.containsKey('status'), isFalse);
      expect(query2.containsKey('requestType'), isFalse);
    });

    test('página vazia mantém a lista vazia e emite Loaded', () async {
      harness.mockMyRequests([]);
      await fetchPageGuarded(controller.pagingController);
      await flush();
      expect(controller.myRequests, isEmpty);
      expect(controller.comfortMyRequestsBloc.state,
          const LoadedMyRequestsState(myRequests: []));
      // Só a próxima busca descobre que não há mais páginas (e não faz HTTP).
      expect(controller.pagingController.value.hasNextPage, isTrue);
      harness.http.requests.clear();
      await fetchPageGuarded(controller.pagingController);
      expect(controller.pagingController.value.hasNextPage, isFalse);
      expect(harness.http.requests, isEmpty);
    });

    test('segunda página acrescenta os itens sem limpar', () async {
      final page1 = List.generate(10, (i) => requestJson('r$i'));
      harness.mockMyRequests(page1);
      await fetchPageGuarded(controller.pagingController);
      expect(controller.myRequests.length, 10);

      harness.mockMyRequests([requestJson('r10')]);
      await controller.getMyRequests(page: 2);
      await flush();
      expect(controller.myRequests.length, 11);
      expect(harness.queryOf(harness.myRequestsPath)['page'], '2');
      expect(controller.pagingController.value.pages!.length, 2);
    });

    test('falha na primeira página emite erro e registra no PagingController',
        () async {
      harness.http.failAll();
      final states = <ComfortMyRequestsState>[];
      final sub = controller.comfortMyRequestsBloc.stream.listen(states.add);

      /// Corrigido: o `Failure` (que não é `Exception`) não é mais relançado;
      /// ele é registrado no `PagingController`, que passa a exibir o
      /// indicador de erro em vez de estourar uma exceção não tratada.
      final error = await fetchPageGuarded(controller.pagingController);
      expect(error, isNull);
      await sub.cancel();

      // Corrigido: `errorCode`/`errorDescription` do evento chegam ao estado.
      expect(states, [
        const LoadingComfortMyRequestsState(),
        const ErrorComfortMyRequestsState(
            errorMessageKey: 'comfort_get_my_requests_error',
            errorCode: 'UNKNOWN',
            errorDescription: ''),
      ]);
      expect(controller.pagingController.value.error, isA<Failure>());
    });

    test('falha em página seguinte não emite erro no bloc', () async {
      harness.mockMyRequests(List.generate(10, (i) => requestJson('r$i')));
      await fetchPageGuarded(controller.pagingController);
      harness.http.failAll();
      final error = await fetchPageGuarded(controller.pagingController);
      expect(error, isNull);
      expect(controller.pagingController.value.error, isA<Failure>());
      expect(controller.comfortMyRequestsBloc.state, isA<LoadedMyRequestsState>());
      expect(controller.myRequests.length, 10);
    });

    test('getMyRequests(page: 1) apenas reinicia o PagingController', () async {
      harness.mockMyRequests([requestJson('r1')]);
      await fetchPageGuarded(controller.pagingController);
      harness.http.requests.clear();
      await controller.getMyRequests();
      expect(controller.pagingController.value.pages, isNull);
      expect(harness.http.requests, isEmpty);
    });
  });

  group('favorito', () {
    test('sem solicitação selecionada emite erro', () async {
      harness.http.on('PUT', harness.favoritePath('p1'),
          body: {'comfort_owner_id': 'o', 'is_favorite': true});
      await controller.changePartnerFavoriteStatus('p1', 'Academia', true);
      await flush();
      expect(
          controller.comfortMyRequestsBloc.state,
          const ErrorComfortMyRequestsState(
              errorMessageKey: 'comfort_rate_page_error'));
    });

    test('sucesso atualiza o favorito do parceiro e loga analytics', () async {
      harness.http.on('PUT', harness.favoritePath('p1'),
          body: {'comfort_owner_id': 'o', 'is_favorite': true});
      final request = buildRequest();
      await controller.goToRateRequestPage(request);
      await controller.changePartnerFavoriteStatus('p1', 'Academia', true);
      await flush();

      expect(request.partner.partnerIntro.favorite, isTrue);
      expect(controller.comfortMyRequestsBloc.state,
          LoadedRateRequestState(selectedRequest: request));
      expect(harness.queryOf(harness.favoritePath('p1')), {'is_favorite': 'true'});
      expect(fakeAnalytics.eventNames, isNotEmpty);
      expect(fakeAnalytics.events.values.last?['id_parceiro'], 'p1');
    });

    test('falha mantém a tela de avaliação com mensagem de flushbar', () async {
      harness.http.failAll();
      final request = buildRequest();
      await controller.goToRateRequestPage(request);
      final events = <ComfortMyRequestsState>[];
      final sub = controller.comfortMyRequestsBloc.stream.listen(events.add);
      await controller.changePartnerFavoriteStatus('p1', 'Academia', true);
      await flush();
      await sub.cancel();

      /// Corrigido: o `flushbarMessage`
      /// 'comfort_change_partner_favorite_status_error' enviado pelo
      /// controller chega ao estado e a tela mostra o aviso.
      expect(events, [
        const LoadingComfortMyRequestsState(),
        LoadedRateRequestState(
            selectedRequest: request,
            flushbarMessage: 'comfort_change_partner_favorite_status_error'),
      ]);
      expect(request.partner.partnerIntro.favorite, isFalse);
    });
  });

  group('reviewRequest', () {
    test('sucesso emite Success e loga analytics', () async {
      harness.http.on('PUT', harness.reviewRequestPath,
          body: {'request_id': 'r1', 'rating': 5, 'comment': 'ok'});
      await controller.reviewRequest(requestId: 'r1', rate: 5, comment: 'ok');
      await flush();
      expect(controller.comfortMyRequestsBloc.state,
          const SuccessComfortMyRequestsState());
      final body = harness.http.requests.last.body;
      expect(body, contains('"request_id":"r1"'));
      expect(body, contains('"rating":5'));
      expect(fakeAnalytics.eventNames, isNotEmpty);
    });

    test('falha emite erro', () async {
      harness.http.failAll();
      await controller.reviewRequest(requestId: 'r1', rate: 3);
      await flush();
      expect(
          controller.comfortMyRequestsBloc.state,
          const ErrorComfortMyRequestsState(
              errorMessageKey: 'comfort_send_review_request_error'));
    });

    test('nota inválida é rejeitada pelo use case', () async {
      await controller.reviewRequest(requestId: 'r1', rate: 7);
      await flush();
      expect(controller.comfortMyRequestsBloc.state,
          isA<ErrorComfortMyRequestsState>());
      expect(harness.http.requests, isEmpty);
    });
  });

  group('navegação de estados', () {
    test('goToRateRequestPage guarda a selecionada e emite LoadedRate', () async {
      final request = buildRequest();
      await controller.goToRateRequestPage(request);
      await flush();
      expect(controller.partnerSelectedRequest, same(request));
      expect(controller.comfortMyRequestsBloc.state,
          LoadedRateRequestState(selectedRequest: request));
    });

    test('backToLoadedMyRequestsState com lista vazia recarrega', () async {
      harness.mockMyRequests([requestJson('r1')]);
      await fetchPageGuarded(controller.pagingController);
      expect(controller.pagingController.value.pages, isNotNull);
      controller.myRequests.clear();
      await controller.backToLoadedMyRequestsState();
      expect(controller.pagingController.value.pages, isNull);

      controller.myRequests.add(buildRequest());
      await controller.backToLoadedMyRequestsState();
      await flush();
      expect(controller.comfortMyRequestsBloc.state,
          LoadedMyRequestsState(myRequests: controller.myRequests));
    });

    test('close fecha o bloc e o PagingController', () async {
      /// Corrigido: `close()` fecha os recursos internos em vez de chamar a
      /// si mesmo (StackOverflow).
      final c = harness.buildMyRequestsController();
      await c.close();
      expect(c.comfortMyRequestsBloc.isClosed, isTrue);
      expect(() => c.pagingController.addListener(() {}), throwsFlutterError);
    });

    test('sendMessage é um no-op', () {
      controller.sendMessage('r1', ComfortRequestMessageType.doubt, 'x');
      expect(controller.comfortMyRequestsBloc.state,
          const LoadingComfortMyRequestsState());
    });
  });

  group('resendRequest', () {
    test('ignora id nulo ou estado diferente de Loaded', () async {
      await controller.resendRequest(null);
      await controller.resendRequest('r1');
      expect(harness.http.requests, isEmpty);
    });

    test('sucesso recarrega e emite Loaded com a solicitação reenviada',
        () async {
      harness.mockMyRequests([requestJson('r1')]);
      await fetchPageGuarded(controller.pagingController);
      await flush();
      harness.http.on('PUT', harness.resendPath('r1'),
          body: requestJson('r1', status: 'resent', isCanResend: false));

      await controller.resendRequest('r1');
      await flush();

      final state = controller.comfortMyRequestsBloc.state as LoadedMyRequestsState;
      expect(state.selectedRequest!.idRequest, 'r1');
      expect(state.selectedRequest!.isCanResend, isFalse);
      expect(harness.paths, contains(harness.resendPath('r1')));
      expect(controller.pagingController.value.pages, isNull);
    });

    test('falha emite erro com o código', () async {
      harness.mockMyRequests([requestJson('r1')]);
      await fetchPageGuarded(controller.pagingController);
      await flush();
      harness.http.on('PUT', harness.resendPath('r1'), status: 500);

      await controller.resendRequest('r1');
      await flush();
      final state = controller.comfortMyRequestsBloc.state as ErrorComfortMyRequestsState;
      expect(state.errorMessageKey, 'comfort_get_my_requests_error');
    });
  });

  group('itens', () {
    test('updateItem substitui na lista e no PagingController', () async {
      harness.mockMyRequests([requestJson('r1'), requestJson('r2')]);
      await fetchPageGuarded(controller.pagingController);
      final updated = buildRequest(id: 'r2', rating: 4);
      controller.updateItem(updated, 1);
      await flush();
      expect(controller.myRequests[1], same(updated));
      expect(controller.pagingController.value.pages!.last.last.rating, 4);
      expect(controller.comfortMyRequestsBloc.state,
          LoadedMyRequestsState(myRequests: controller.myRequests));
    });

    test('updateAll reinicia a paginação', () async {
      harness.mockMyRequests([requestJson('r1')]);
      await fetchPageGuarded(controller.pagingController);
      controller.updateAll();
      expect(controller.pagingController.value.pages, isNull);
    });
  });

  group('sessão por origem', () {
    for (final origin in AppOriginEnum.values) {
      test('getCondoName/getCondoReference para $origin', () {
        final c = ComfortRequestsHarness(origin: origin).buildMyRequestsController();
        expect(c.getCondoName, condoName);
        expect(c.getCondoReference, condoReference);
        final empty = ComfortRequestsHarness(origin: origin, session: emptySession())
            .buildMyRequestsController();
        expect(empty.getCondoName, '');
        expect(empty.getCondoReference, '');
      });

      test('analytics para $origin não lança', () async {
        final c = ComfortRequestsHarness(origin: origin).buildMyRequestsController();
        c.analyticsComodidadesSolicitacoesAcessar();
        c.analyticsComodidadesMudarFavorito('p1', 'Academia');
        c.analyticsComodidadesAvaliar();
        await flush();
        if (origin == AppOriginEnum.manager) {
          // Só o evento de favorito existe para o síndico.
          expect(fakeAnalytics.eventNames.length, 1);
        } else {
          expect(fakeAnalytics.eventNames.length, 3);
        }
      });
    }
  });

  group('temporizadores de analytics', () {
    test('start/stop dos dois temporizadores usam o papel do token', () async {
      controller.comfortMyRequestsAnalyticsTimerStart();
      controller.comfortMyRequestsBottomSheetAnalyticsTimerStart();
      await flush();
      expect(harness.getToken.calls, 2);
      expect(controller.comfortMyRequestsTimer!.userType, 'owner');
      expect(controller.comfortMyRequestsBottomSheetTimer!.userType, 'owner');
      expect(controller.comfortMyRequestsTimer!.referenceValue, condoReference);
      controller.comfortMyRequestsAnalyticsTimerStop();
      controller.comfortMyRequestsBottomSheetAnalyticsTimerStop();
    });

    test('sem token o papel fica vazio', () async {
      final c = ComfortRequestsHarness(getToken: FakeGetToken(fail: true))
          .buildMyRequestsController();
      c.comfortMyRequestsAnalyticsTimerStart();
      await flush();
      expect(c.comfortMyRequestsTimer!.userType, '');
    });

    test('stop antes do start não faz nada', () {
      /// Corrigido: os temporizadores são nulos até serem criados (depois do
      /// `await` do token); parar antes disso é um no-op.
      expect(controller.comfortMyRequestsTimer, isNull);
      expect(controller.comfortMyRequestsBottomSheetTimer, isNull);
      controller.comfortMyRequestsAnalyticsTimerStop();
      controller.comfortMyRequestsBottomSheetAnalyticsTimerStop();
    });
  });
}
