import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_completed_request.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_request_message_type.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/widgets/request_bottom_sheet.dart';

import '../../../helpers/pump_app.dart';
import 'comfort_requests_test_support.dart';

void main() {
  late ComfortRequestsHarness harness;
  late RecordingNavigatorObserver observer;

  setUp(() async {
    harness = await installComfortHarness();
    observer = RecordingNavigatorObserver();
  });

  final sheet = find.byType(ComfortCompletedRequestBottomSheet);

  Future<void> open(WidgetTester tester, ComfortCompletedRequest request) async {
    await pumpPage(
      tester,
      PushHost(
        onOpen: (ctx) => Modal.showBottomSheet(
          context: ctx,
          isScrollControlled: true,
          builder: (_) => ComfortCompletedRequestBottomSheet(
            comfortCompletedRequest: request,
            myRequestsController: harness.myRequests,
            appContainer: harness.container,
          ),
        ),
      ),
      observer: observer,
      surface: const Size(600, 1000),
      locOverrides: sheetLoc,
    );
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
    expect(sheet, findsOneWidget);
  }

  testWidgets('mostra condomínio, detalhes, nota e botões', (tester) async {
    await open(tester, buildRequest());

    expect(find.text('condominium:'), findsOneWidget);
    expect(find.text(condoName), findsOneWidget);
    expect(find.text('Academia Lello'), findsOneWidget);
    expect(find.text('comfort_request_status_sended'), findsNothing);
    expect(find.text('comfort_rate_rating'), findsOneWidget);
    expect(find.text('comfort_message_need_help'), findsOneWidget);
    expect(find.text('comfort_request_resend_button'), findsOneWidget);
    expect(find.text('comfort_request_cancel_button'), findsOneWidget);
    expect(tester.widget<RatingBar>(find.byType(RatingBar)).ignoreGestures, isFalse);
    await expectLater(sheet, matchesGoldenFile('goldens/request_bottom_sheet.png'));

    await setRating(tester, 3);
    await tester.pumpAndSettle();
    expect(tester.widget<RatingBar>(find.byType(RatingBar)).initialRating, 3);

    // O botão de cancelar não faz nada.
    await tester.tap(find.text('comfort_request_cancel_button'));
    await tester.pumpAndSettle();
    expect(sheet, findsOneWidget);

    await tester.tap(find.byIcon(Icons.keyboard_arrow_down_sharp));
    await tester.pumpAndSettle();
    expect(sheet, findsNothing);
  });

  testWidgets('nota existente trava a barra', (tester) async {
    await open(tester, buildRequest(rating: 4));
    final bar = tester.widget<RatingBar>(find.byType(RatingBar));
    expect(bar.ignoreGestures, isTrue);
    expect(bar.initialRating, 4);
  });

  testWidgets('reenviar fecha e chama o controller', (tester) async {
    await open(tester, buildRequest());
    await tester.tap(find.text('comfort_request_resend_button'));
    await tester.pumpAndSettle();
    expect(sheet, findsNothing);
    // O controller ignora o reenvio fora do estado Loaded.
    expect(harness.http.requests, isEmpty);
  });

  testWidgets('sem reenvio o botão fica desabilitado com outro texto',
      (tester) async {
    await open(tester, buildRequest(isCanResend: false));
    expect(find.text('comfort_request_resent_button'), findsOneWidget);
    await tester.tap(find.text('comfort_request_resent_button'));
    await tester.pumpAndSettle();
    expect(sheet, findsOneWidget);
  });

  testWidgets('formulário de mensagem: vazio não envia, preenchido fecha',
      (tester) async {
    await open(tester, buildRequest());
    await tester.tap(find.text('comfort_message_need_help'));
    await tester.pumpAndSettle();
    expect(find.text('comfort_message_need_help_subtitle'), findsOneWidget);
    expect(find.text('comfort_rate_rating'), findsNothing);

    await tester.tap(find.text('send'));
    await tester.pumpAndSettle();
    expect(sheet, findsOneWidget);

    await tester.tap(find.text('cancel'));
    await tester.pumpAndSettle();
    expect(find.text('comfort_message_need_help_subtitle'), findsNothing);
    expect(find.text('comfort_rate_rating'), findsOneWidget);

    await tester.tap(find.text('comfort_message_need_help'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownButtonFormField<ComfortRequestMessageType>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('comfort_message_subject_other').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), 'Olá');
    await tester.tap(find.text('send'));
    await tester.pumpAndSettle();
    expect(sheet, findsNothing);
  });

  testWidgets('mensagem já enviada pode ser vista e escondida', (tester) async {
    await open(
      tester,
      buildRequest(
        comment: 'Texto enviado',
        messageType: ComfortRequestMessageType.suggestion,
        messageDate: DateTime(2026, 1, 11, 9, 5),
      ),
    );
    await tester.tap(find.text('comfort_message_view'));
    await tester.pumpAndSettle();
    expect(find.text('comfort_message_subject_suggestion'), findsOneWidget);
    expect(find.text('Texto enviado'), findsOneWidget);
    expect(find.text('comfort_message_sended_at'), findsOneWidget);
    expect(find.text('comfort_request_resend_button'), findsOneWidget);

    await tester.tap(find.text('comfort_message_hide'));
    await tester.pumpAndSettle();
    expect(find.text('Texto enviado'), findsNothing);
    expect(find.text('comfort_message_view'), findsOneWidget);
  });
}
