import 'package:essentials/enum/app_origin_enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partner_reviews/bloc/comfort_partner_reviews_state.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partner_reviews/controller/comfort_partner_reviews_controller.dart';

import '../../../helpers/firebase_mocks.dart';
import '../comfort_my_requests/comfort_requests_test_support.dart';

void main() {
  late ComfortRequestsHarness harness;

  setUp(() async {
    harness = await installComfortHarness();
  });

  test('sucesso ordena as avaliações por data e emite Loaded', () async {
    final controller = harness.buildPartnerReviewsController();
    harness.http.on('GET', harness.reviewsPath('p1'), body: [
      reviewJson(name: 'Antiga', reviewDate: '2025-01-01T00:00:00'),
      reviewJson(name: 'Nova', reviewDate: '2026-05-01T00:00:00'),
    ]);
    final states = <ComfortPartnerReviewsState>[];
    final sub = controller.comfortPartnerReviewsBloc.stream.listen(states.add);

    await controller.getAllPartnerReviews('p1', 'Academia');
    await flush();
    await sub.cancel();

    expect(states.first, const LoadingComfortPartnerReviewsState());
    final loaded = states.last as LoadedComfortPartnerReviewsState;
    expect(loaded.partnerReviews.map((e) => e.name), ['Nova', 'Antiga']);
    expect(fakeAnalytics.eventNames, ['comodidades_parceiro_avaliacoes_acessar']);
    expect(fakeAnalytics.events.values.first?['nome_parceiro'], 'Academia');
  });

  test('falha emite erro', () async {
    final controller = harness.buildPartnerReviewsController();
    harness.http.failAll();
    await controller.getAllPartnerReviews('p1', 'Academia');
    await flush();
    expect(
        controller.comfortPartnerReviewsBloc.state,
        const ErrorComfortPartnerReviewsState(
            errorMessageKey: 'comfort_partner_reviews_error'));
    expect(fakeAnalytics.eventNames, isEmpty);
  });

  for (final origin in AppOriginEnum.values) {
    test('analytics de acesso para $origin', () async {
      final controller =
          ComfortRequestsHarness(origin: origin).buildPartnerReviewsController();
      final h = ComfortRequestsHarness(origin: origin);
      h.http.on('GET', h.reviewsPath('p1'), body: [reviewJson()]);
      final c = h.buildPartnerReviewsController();
      await c.getAllPartnerReviews('p1', 'Academia');
      await flush();
      expect(fakeAnalytics.eventNames.length, 1);
      expect(fakeAnalytics.events.values.first?['id_partner'], 'p1');
      await controller.comfortPartnerReviewsBloc.close();
    });
  }

  test('close fecha o bloc', () async {
    final controller = harness.buildPartnerReviewsController();

    /// Corrigido: `close()` fecha o bloc em vez de chamar a si mesmo
    /// (StackOverflow).
    await controller.close();
    expect(controller.comfortPartnerReviewsBloc.isClosed, isTrue);
  });
}
