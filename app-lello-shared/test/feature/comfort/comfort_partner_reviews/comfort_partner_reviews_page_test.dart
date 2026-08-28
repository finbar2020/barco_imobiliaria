import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/core/widgets/error_message_widget.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partner_reviews/bloc/comfort_partner_reviews_state.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partner_reviews/pages/comfort_partner_reviews_page.dart';
import 'package:shared_features/feature/comfort/presentation/widgets/rating_bar_widget.dart';

import '../../../helpers/pump_app.dart';
import '../comfort_my_requests/comfort_requests_test_support.dart';

void main() {
  late ComfortRequestsHarness harness;

  setUp(() async {
    harness = await installComfortHarness();
  });

  Future<void> pump(WidgetTester tester, {bool settle = true}) => pumpPage(
        tester,
        ComfortPartnerReviewsPage(appContainer: harness.container),
        arguments: ComfortPartnerReviewsPageArgs(
          reference: condoReference,
          unit: 'Ap 101',
          partner: buildPartner(rating: 4.3, ratingsNumber: 7),
        ),
        settle: settle,
      );

  Finder richText(String text) => find.byWidgetPredicate(
      (w) => w is RichText && w.text.toPlainText() == text);

  testWidgets('lista as avaliações do parceiro', (tester) async {
    harness.http.on('GET', harness.reviewsPath('p1'), body: [
      reviewJson(name: 'Maria', review: 5, comment: 'Excelente',
          reviewDate: '2026-02-03T00:00:00'),
      reviewJson(name: null, review: 3, comment: null,
          reviewDate: '2026-01-20T00:00:00'),
      reviewJson(name: 'João', review: 2, comment: 'Ruim', reviewDate: null),
    ]);

    await pump(tester);

    expect(find.text('comfort'), findsOneWidget);
    expect(find.text('Academia Lello'), findsOneWidget);
    expect(find.text('4.3'), findsOneWidget);
    expect(find.text('comfort_ratings_total'), findsOneWidget);
    expect(find.byType(RatingBarWidget), findsNWidgets(4));
    expect(richText('Maria - 03/02/2026'), findsOneWidget);
    expect(richText('20/01/2026'), findsOneWidget);
    expect(richText('João'), findsOneWidget);
    expect(find.text('Excelente'), findsOneWidget);
    expect(find.text('Ruim'), findsOneWidget);
    expect(find.text('5.0'), findsOneWidget);
    expect(find.text('3.0'), findsOneWidget);
    expect(find.byType(Divider), findsNWidgets(2));
    expect(harness.paths, [harness.reviewsPath('p1')]);
    await expectLater(find.byType(ComfortPartnerReviewsPage),
        matchesGoldenFile('goldens/comfort_partner_reviews_page.png'));

    // Voltar: o WillPopScope deixa passar e a página é fechada.
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(ComfortPartnerReviewsPage), findsNothing);
  });

  testWidgets('mostra o carregamento enquanto busca', (tester) async {
    harness.http.on('GET', harness.reviewsPath('p1'), body: []);
    await pump(tester, settle: false);
    expect(find.byType(LoadingWidget), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.byType(LoadingWidget), findsNothing);
    expect(find.byType(RatingBarWidget), findsOneWidget);
  });

  testWidgets('falha mostra a mensagem de erro', (tester) async {
    harness.http.failAll();
    await pump(tester);
    expect(find.byType(ErrorMessageWidget), findsOneWidget);
    expect(find.text('comfort_partner_reviews_error'), findsOneWidget);
  });

  testWidgets('estado vazio não renderiza corpo', (tester) async {
    harness.http.on('GET', harness.reviewsPath('p1'), body: []);
    await pump(tester);
    // ignore: invalid_use_of_visible_for_testing_member
    harness.partnerReviews.comfortPartnerReviewsBloc
        .emit(const EmptyComfortPartnerReviewsState());
    await tester.pumpAndSettle();
    expect(find.byType(RatingBarWidget), findsNothing);
    expect(find.byType(LoadingWidget), findsNothing);
    expect(find.text('comfort'), findsOneWidget);
  });
}
