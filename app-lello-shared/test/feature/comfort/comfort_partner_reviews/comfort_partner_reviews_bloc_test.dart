import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_review.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partner_reviews/bloc/comfort_partner_reviews_bloc.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partner_reviews/bloc/comfort_partner_reviews_event.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partner_reviews/bloc/comfort_partner_reviews_state.dart';

import '../comfort_my_requests/comfort_requests_test_support.dart';

void main() {
  late ComfortPartnerReviewsBloc bloc;

  setUp(() => bloc = ComfortPartnerReviewsBloc());
  tearDown(() => bloc.close());

  test('estado inicial é carregando', () {
    expect(bloc.state, const LoadingComfortPartnerReviewsState());
  });

  test('eventos emitem os estados correspondentes', () async {
    final reviews = [ComfortPartnerReview(review: 4, name: 'Ana')];
    final states = <ComfortPartnerReviewsState>[];
    final sub = bloc.stream.listen(states.add);

    bloc
      ..add(const EmptyComfortPartnerReviewsEvent())
      ..add(const LoadingComfortPartnerReviewsEvent())
      ..add(const ErrorComfortPartnerReviewsEvent(errorMessageKey: 'erro'))
      ..add(LoadedComfortPartnerReviewsEvent(
          partnerReviews: reviews, flushbarMessage: 'f'));
    await flush();
    await sub.cancel();

    expect(states, [
      const EmptyComfortPartnerReviewsState(),
      const LoadingComfortPartnerReviewsState(),
      const ErrorComfortPartnerReviewsState(errorMessageKey: 'erro'),
      LoadedComfortPartnerReviewsState(
          partnerReviews: reviews, flushbarMessage: 'f'),
    ]);

    /// Corrigido: o handler de Loaded repassa `flushbarMessage` ao estado.
    expect((states.last as LoadedComfortPartnerReviewsState).flushbarMessage,
        'f');
  });

  test('props', () {
    expect(const EmptyComfortPartnerReviewsEvent().props, isEmpty);
    expect(const ErrorComfortPartnerReviewsEvent(errorMessageKey: 'e').props, ['e']);
    expect(const LoadedComfortPartnerReviewsEvent(partnerReviews: []).props,
        [[], null]);
    expect(const EmptyComfortPartnerReviewsState().props, isEmpty);
    expect(const ErrorComfortPartnerReviewsState(errorMessageKey: 'e').props, ['e']);
    expect(
        const LoadedComfortPartnerReviewsState(
            partnerReviews: [], flushbarMessage: 'f').props,
        [[], 'f']);
  });
}
