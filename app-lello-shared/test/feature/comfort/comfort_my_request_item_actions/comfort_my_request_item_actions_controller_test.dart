import 'package:essentials/enum/app_origin_enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_request_message_type.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_request_item_actions/bloc/comfort_my_request_item_actions_bloc.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_request_item_actions/controller/comfort_my_request_item_actions_controller.dart';

import '../comfort_my_requests/comfort_requests_test_support.dart';

void main() {
  late ComfortRequestsHarness harness;
  late ComfortMyRequestItemActionsController controller;
  final request = buildRequest();

  setUp(() async {
    harness = await installComfortHarness();
    controller = harness.buildItemActionsController();
  });
  tearDown(() => controller.bloc.close());

  Future<void> load() async {
    controller.setRequest(request: request);
    await flush();
  }

  test('setRequest emite Loaded', () async {
    await load();
    expect(controller.bloc.state, ComfortMyRequestItemActionsLoadedState(request));
  });

  test('ações são ignoradas fora do estado Loaded', () async {
    await controller.sendMessage(
        request: request, subject: ComfortRequestMessageType.doubt, message: 'x');
    await controller.resendRequest(requestId: 'r1');
    await controller.cancelRequest('r1');
    await controller.rateRequest(request: request, rating: 3);
    expect(harness.http.requests, isEmpty);
    expect(controller.bloc.state, const ComfortMyRequestItemActionsInitialState());
  });

  group('sendMessage', () {
    test('sucesso atualiza a solicitação, monta o link da imagem e emite Success',
        () async {
      await load();
      harness.http.on('POST', harness.updatePath('r1'),
          body: requestJson('r1', comment: 'ajuda', messageType: 'doubt'));
      final states = <ComfortMyRequestItemActionsState>[];
      final sub = controller.bloc.stream.listen(states.add);

      await controller.sendMessage(
          request: request,
          subject: ComfortRequestMessageType.doubt,
          message: 'ajuda');
      await flush();
      await sub.cancel();

      expect(request.messageType, ComfortRequestMessageType.doubt);
      expect(request.comment, 'ajuda');
      expect(states.first,
          ComfortMyRequestItemActionsLoadingState(ComfortMyRequestItemActions.message, request));
      final success = states.last as ComfortMyRequestItemActionsSuccessState;
      expect(success.action, ComfortMyRequestItemActions.message);
      expect(success.request.partner.partnerIntro.partnerImageLink,
          '/condominiums/$condoId/comfort/p1/image/hash-r');
      final body = harness.http.requests.last.body;
      expect(body, contains('"comment":"ajuda"'));
      expect(body, contains('"message_type":"doubt"'));
    });

    test('falha emite Error com a ação', () async {
      await load();
      harness.http.failAll();
      await controller.sendMessage(
          request: request, subject: ComfortRequestMessageType.other, message: 'x');
      await flush();
      final state = controller.bloc.state as ComfortMyRequestItemActionsErrorState;
      expect(state.action, ComfortMyRequestItemActions.message);
      expect(state.errorMessageKey, 'comfort_get_my_requests_error');
      expect(state.errorCode, 'UNKNOWN');
    });
  });

  group('resendRequest', () {
    test('sucesso emite Success(resend)', () async {
      await load();
      harness.http.on('PUT', harness.resendPath('r1'),
          body: requestJson('r1', status: 'resent'));
      await controller.resendRequest(requestId: 'r1');
      await flush();
      final state = controller.bloc.state as ComfortMyRequestItemActionsSuccessState;
      expect(state.action, ComfortMyRequestItemActions.resend);
      expect(state.request.partner.partnerIntro.partnerImageLink, isNotNull);
    });

    test('falha emite Error(resend)', () async {
      await load();
      harness.http.failAll();
      await controller.resendRequest(requestId: 'r1');
      await flush();
      final state = controller.bloc.state as ComfortMyRequestItemActionsErrorState;
      expect(state.action, ComfortMyRequestItemActions.resend);
    });
  });

  group('cancelRequest', () {
    test('sucesso emite Success(cancel)', () async {
      await load();
      harness.http.on('DELETE', harness.cancelPath('r1'),
          body: requestJson('r1', status: 'canceled'));
      await controller.cancelRequest('r1');
      await flush();
      final state = controller.bloc.state as ComfortMyRequestItemActionsSuccessState;
      expect(state.action, ComfortMyRequestItemActions.cancel);
      expect(harness.http.requests.last.method, 'DELETE');
    });

    test('falha emite Error(cancel)', () async {
      await load();
      harness.http.failAll();
      await controller.cancelRequest('r1');
      await flush();
      final state = controller.bloc.state as ComfortMyRequestItemActionsErrorState;
      expect(state.action, ComfortMyRequestItemActions.cancel);
    });
  });

  group('rateRequest', () {
    test('sucesso mantém a nota e emite Success(rate)', () async {
      final req = buildRequest();
      controller.setRequest(request: req);
      await flush();
      harness.http.on('POST', harness.updatePath('r1'),
          body: requestJson('r1', rating: 4));
      await controller.rateRequest(request: req, rating: 4);
      await flush();
      expect(req.rating, 4);
      final state = controller.bloc.state as ComfortMyRequestItemActionsSuccessState;
      expect(state.action, ComfortMyRequestItemActions.rate);
      expect(state.request.rating, 4);
      expect(harness.http.requests.last.body, contains('"rating":4'));
    });

    test('falha restaura a nota anterior e emite Error(rate)', () async {
      final req = buildRequest(rating: 2);
      controller.setRequest(request: req);
      await flush();
      harness.http.failAll();
      await controller.rateRequest(request: req, rating: 5);
      await flush();
      expect(req.rating, 2);
      final state = controller.bloc.state as ComfortMyRequestItemActionsErrorState;
      expect(state.action, ComfortMyRequestItemActions.rate);
    });
  });

  group('sessão por origem', () {
    for (final origin in AppOriginEnum.values) {
      test('getCondoName/getCondoReference para $origin', () {
        final c = ComfortRequestsHarness(origin: origin).buildItemActionsController();
        expect(c.getCondoName, condoName);
        expect(c.getCondoReference, condoReference);
        final empty = ComfortRequestsHarness(origin: origin, session: emptySession())
            .buildItemActionsController();
        expect(empty.getCondoName, '');
        expect(empty.getCondoReference, '');
      });
    }
  });
}
