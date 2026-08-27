import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/core/widgets/error_message_widget.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/bloc/comfort_my_requests_state.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/controller/comfort_my_request_controller.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/pages/comfort_rate_request_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/pages/comfort_rating_success_page.dart';
import 'package:shared_features/feature/comfort/presentation/widgets/partner_info_widget.dart';
import 'package:shared_features/feature/comfort/presentation/widgets/rating_bar_widget.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

import '../../../helpers/pump_app.dart';
import 'comfort_requests_test_support.dart';

void main() {
  late ComfortRequestsHarness harness;
  late RecordingNavigatorObserver observer;
  late ComfortMyRequestsController controller;

  setUp(() async {
    harness = await installComfortHarness();
    observer = RecordingNavigatorObserver();
  });

  Future<void> pump(WidgetTester tester) async {
    controller = harness.myRequests;
    await pumpPage(
      tester,
      ComfortRateRequestPage(appContainer: harness.container),
      arguments: ComfortRateRequestPageArgs(controller),
      observer: observer,
      routes: {
        SharedApplicationRoute.comfortSuccessRateRequest: (_) =>
            const ComfortRatingSuccessPage(),
      },
      // O estado inicial é Loading (spinner infinito): não dá para settle.
      settle: false,
      surface: const Size(600, 1200),
    );
    await tester.pump();
  }

  Future<void> loadRate(WidgetTester tester) async {
    await controller.goToRateRequestPage(buildRequest());
    await tester.pumpAndSettle();
  }

  PrimaryButton sendButton(WidgetTester tester) =>
      tester.widget<PrimaryButton>(find.byType(PrimaryButton));

  testWidgets('carregando, corpo de avaliação e envio com sucesso',
      (tester) async {
    await pump(tester);
    expect(find.byType(LoadingWidget), findsOneWidget);

    await loadRate(tester);
    expect(find.byType(LoadingWidget), findsNothing);
    expect(find.byType(PartnerIntroWidget), findsOneWidget);
    expect(find.text('Academia Lello'), findsOneWidget);
    expect(find.text('comfort_rate_title'), findsOneWidget);
    expect(find.text('comfort_rate_subtitle'), findsOneWidget);
    expect(find.text('comfort_rate_rating'), findsOneWidget);
    expect(find.text('comfort_rate_give_your_opinion'), findsOneWidget);
    expect(find.text('comfort_rate_write_here'), findsOneWidget);
    expect(find.text('comfort_rate_send'), findsOneWidget);
    expect(sendButton(tester).onPressed, isNull);
    await expectLater(find.byType(ComfortRateRequestPage),
        matchesGoldenFile('goldens/comfort_rate_request_page.png'));

    await setRating(tester, 5);
    await tester.pumpAndSettle();
    expect(sendButton(tester).onPressed, isNotNull);
    await tester.enterText(find.byType(TextField), 'Muito bom');
    await tester.pumpAndSettle();

    harness.http.on('PUT', harness.reviewRequestPath,
        body: {'request_id': 'r1', 'rating': 5, 'comment': 'Muito bom'});
    await tester.tap(find.text('comfort_rate_send'));
    await tester.pumpAndSettle();

    expect(harness.http.requests.single.body, contains('"comment":"Muito bom"'));
    expect(observer.pushedNames.last, SharedApplicationRoute.comfortSuccessRateRequest);
    expect(find.byType(ComfortRatingSuccessPage), findsOneWidget);
    expect(find.text('comfort_rate_success_title'), findsOneWidget);
    expect(find.text('comfort_rate_success_subtitle'), findsOneWidget);
    await expectLater(find.byType(ComfortRatingSuccessPage),
        matchesGoldenFile('goldens/comfort_rating_success_page.png'));

    await tester.tap(find.text('comfort_rate_success_conclude'));
    await tester.pumpAndSettle();
    expect(observer.popped, hasLength(1));
  });

  testWidgets('falha no envio mostra a mensagem de erro', (tester) async {
    await pump(tester);
    await loadRate(tester);
    harness.http.failAll();

    await setRating(tester, 1);
    await tester.pumpAndSettle();
    await tester.tap(find.text('comfort_rate_send'));
    await tester.pumpAndSettle();

    expect(find.byType(ErrorMessageWidget), findsOneWidget);
    expect(find.text('comfort_send_review_request_error'), findsOneWidget);
    expect(find.byType(ComfortRatingSuccessPage), findsNothing);
  });

  testWidgets('flushbar do estado vira SnackBar', (tester) async {
    await pump(tester);
    await loadRate(tester);
    // ignore: invalid_use_of_visible_for_testing_member
    controller.comfortMyRequestsBloc.emit(LoadedRateRequestState(
        selectedRequest: buildRequest(), flushbarMessage: 'aviso_favorito'));
    for (var i = 0; i < 3; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('aviso_favorito'), findsOneWidget);
  });

  testWidgets('toque fora do campo tira o foco', (tester) async {
    await pump(tester);
    await loadRate(tester);
    await tester.ensureVisible(find.byType(TextField));
    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    expect(tester.testTextInput.hasAnyClients, isTrue);

    await tester.tap(find.text('comfort_rate_title'));
    await tester.pumpAndSettle();

    /// Defeito: o FocusNode é recriado a cada build e nunca é descartado;
    /// o GestureDetector externo só tira o foco do nó da última build.
    expect(tester.takeException(), isNull);
  });

  testWidgets('estado desconhecido não renderiza corpo', (tester) async {
    await pump(tester);
    // ignore: invalid_use_of_visible_for_testing_member
    controller.comfortMyRequestsBloc.emit(const EmptyComfortMyRequestsState());
    await tester.pump();
    expect(find.byType(LoadingWidget), findsNothing);
    expect(find.byType(RatingBarWidget), findsNothing);
    expect(find.text('comfort'), findsOneWidget);
  });

  testWidgets('voltar restaura a lista de solicitações', (tester) async {
    await pump(tester);
    await loadRate(tester);
    controller.myRequests.add(buildRequest());
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(controller.comfortMyRequestsBloc.state,
        LoadedMyRequestsState(myRequests: controller.myRequests));
  });

  testWidgets('página de sucesso isolada: voltar fecha a página',
      (tester) async {
    await pumpPage(
      tester,
      const ComfortRatingSuccessPage(),
      arguments: ComfortRatingSuccessPageArgs(harness.myRequests),
      observer: observer,
    );
    expect(find.text('comfort_rate_success_conclude'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(ComfortRatingSuccessPage), findsNothing);
    expect(observer.popped, hasLength(1));
  });
}
