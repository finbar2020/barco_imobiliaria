import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/bloc/comfort_partners_state.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_my_favorites/comfort_disfavor_success_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_review_sent_success_page.dart';

import '../../../helpers/pump_app.dart';
import 'comfort_partners_test_support.dart';

void main() {
  late ComfortHarness harness;
  late RecordingNavigatorObserver observer;

  setUp(() async {
    harness = await installComfortHarness();
    observer = RecordingNavigatorObserver();
  });

  group('ComfortReviewSentSuccessPage', () {
    testWidgets('mostra os textos de sucesso', (tester) async {
      harness.mockPartners([partnerJson('P1')]);
      final controller = harness.controller();

      await pumpPage(
        tester,
        // ignore: prefer_const_constructors
        ComfortReviewSentSuccessPage(),
        arguments: ComfortReviewSentSuccessPageArgs(controller),
        observer: observer,
      );

      expect(find.text('comfort_rate_success_title'), findsOneWidget);
      expect(find.text('comfort_rate_success_subtitle'), findsOneWidget);
      expect(find.text('comfort_rate_success_conclude'), findsOneWidget);
      expect(harness.http.requests, isEmpty);

      await expectLater(
        find.byType(ComfortReviewSentSuccessPage),
        matchesGoldenFile('goldens/comfort_review_sent_success_page.png'),
      );
    });

    testWidgets('concluir recarrega os parceiros e fecha a página',
        (tester) async {
      harness.mockPartners([partnerJson('P1')]);
      final controller = harness.controller();

      await pumpPage(
        tester,
        const ComfortReviewSentSuccessPage(),
        arguments: ComfortReviewSentSuccessPageArgs(controller),
        observer: observer,
      );
      await tester.tap(find.text('comfort_rate_success_conclude'));
      await tester.pumpAndSettle();

      expect(find.byType(ComfortReviewSentSuccessPage), findsNothing);
      expect(harness.requestedPaths, ['/condominiums/C1/comfort/v2']);
      expect(controller.comfortPartnersBloc.state,
          isA<LoadedComfortPartnersState>());
    });

    testWidgets('voltar pelo sistema também recarrega os parceiros',
        (tester) async {
      harness.mockPartners([partnerJson('P1')]);
      final controller = harness.controller();

      await pumpPage(
        tester,
        const ComfortReviewSentSuccessPage(),
        arguments: ComfortReviewSentSuccessPageArgs(controller),
        observer: observer,
      );
      await tester.state<NavigatorState>(find.byType(Navigator)).maybePop();
      await tester.pumpAndSettle();

      expect(find.byType(ComfortReviewSentSuccessPage), findsNothing);
      expect(harness.requestedPaths, ['/condominiums/C1/comfort/v2']);
    });
  });

  group('ComfortDisfavorSuccessPage', () {
    testWidgets('mostra o nome do parceiro e conclui', (tester) async {
      final partner = buildPartner('P1', title: 'Alfa');
      final controller = harness.buildController(allPartnersList: [partner]);

      await pumpPage(
        tester,
        const ComfortDisfavorSuccessPage(),
        arguments: ComfortDisfavorSuccessPageArgs(controller, partner),
        observer: observer,
        locOverrides: {'comfort_disfavor_complete': 'Você deixou de seguir ###'},
      );

      expect(find.text('Você deixou de seguir Alfa'), findsOneWidget);
      expect(find.text('comfort_disfavor_conclude'), findsOneWidget);

      await expectLater(
        find.byType(ComfortDisfavorSuccessPage),
        matchesGoldenFile('goldens/comfort_disfavor_success_page.png'),
      );

      await tester.tap(find.text('comfort_disfavor_conclude'));
      await tester.pumpAndSettle();

      expect(find.byType(ComfortDisfavorSuccessPage), findsNothing);
      expect(controller.comfortPartnersBloc.state,
          isA<LoadedComfortPartnersState>());
      expect(harness.http.requests, isEmpty);
    });
  });
}
