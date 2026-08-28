import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/core/widgets/loading_message_widget.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_completed_request.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_request_message_type.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_request_item_actions/bloc/comfort_my_request_item_actions_bloc.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_request_item_actions/controller/comfort_my_request_item_actions_controller.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_request_item_actions/pages/comfort_my_request_item_actions_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_request_item_actions/pages/comfort_my_request_item_actions_success_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/comfort_partner_details/coupon_request_result_page.dart';

import '../../../helpers/pump_app.dart';
import '../comfort_my_requests/comfort_requests_test_support.dart';

void main() {
  late ComfortRequestsHarness harness;
  late RecordingNavigatorObserver observer;
  late List<ComfortCompletedRequest> updated;
  late int updateAllCalls;
  late List<String> toasts;

  setUp(() async {
    harness = await installComfortHarness();
    observer = RecordingNavigatorObserver();
    updated = [];
    updateAllCalls = 0;
  });

  final sheet = find.byType(ComfortMyRequestItemActionsBottomSheet);

  /// Abre o bottom sheet a partir de uma página hospedeira e devolve o
  /// controller (registrado como instância para permitir `emit`).
  Future<ComfortMyRequestItemActionsController> open(
      WidgetTester tester, ComfortCompletedRequest request) async {
    toasts = installFakeToast();
    final controller = harness.buildItemActionsController();
    harness.container.register<ComfortMyRequestItemActionsController>(controller);
    await pumpPage(
      tester,
      PushHost(
        onOpen: (ctx) => Modal.showBottomSheet(
          context: ctx,
          isScrollControlled: true,
          builder: (_) => ComfortMyRequestItemActionsBottomSheet(
            appContainer: harness.container,
            request: request,
            updatedItemResponse: updated.add,
            updateAllItems: () => updateAllCalls++,
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
    return controller;
  }

  testWidgets('exibe a solicitação carregada com condomínio, nota e ações',
      (tester) async {
    final controller = await open(tester, buildRequest());

    expect(controller.bloc.state, isA<ComfortMyRequestItemActionsLoadedState>());
    expect(find.text('condominium:'), findsOneWidget);
    expect(find.text('$condoName - $condoReference'), findsOneWidget);
    expect(find.text('Academia Lello'), findsOneWidget);
    expect(find.text('comfort_gym'), findsOneWidget);
    expect(find.text('10/01/2026 time_to 10:30h'), findsOneWidget);
    // hideStatus: sem o texto de status.
    expect(find.text('comfort_request_status_sended'), findsNothing);
    expect(find.text('comfort_rate_rating'), findsOneWidget);
    expect(find.text('comfort_message_need_help'), findsOneWidget);
    expect(find.text('comfort_request_resend_button'), findsOneWidget);
    expect(find.text('comfort_request_cancel_button'), findsOneWidget);
    await expectLater(
        sheet, matchesGoldenFile('goldens/item_actions_bottom_sheet.png'));

    // Seta fecha o sheet.
    await tester.tap(find.byIcon(Icons.keyboard_arrow_down_sharp));
    await tester.pumpAndSettle();
    expect(sheet, findsNothing);
    expect(observer.popped, hasLength(1));
  });

  testWidgets('estados inicial e de carregamento mostram os indicadores',
      (tester) async {
    final controller = await open(tester, buildRequest());

    // ignore: invalid_use_of_visible_for_testing_member
    controller.bloc.emit(const ComfortMyRequestItemActionsInitialState());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(LoadingWidget), findsOneWidget);

    const messages = {
      ComfortMyRequestItemActions.resend: 'comfort_request_resend_loading',
      ComfortMyRequestItemActions.cancel: 'comfort_request_cancel_loading',
      ComfortMyRequestItemActions.rate: 'comfort_request_rate_loading',
      ComfortMyRequestItemActions.message: 'comfort_request_message_loading',
    };
    for (final entry in messages.entries) {
      // ignore: invalid_use_of_visible_for_testing_member
      controller.bloc.emit(
          ComfortMyRequestItemActionsLoadingState(entry.key, buildRequest()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.byType(LoadingMessageWidget), findsOneWidget);
      expect(find.text(entry.value), findsOneWidget);
    }
  });

  group('avaliar', () {
    testWidgets('voltar com nota nova envia a avaliação, avisa e fecha',
        (tester) async {
      final request = buildRequest();
      await open(tester, request);
      harness.http.on('POST', harness.updatePath('r1'),
          body: requestJson('r1', rating: 4));

      await setRating(tester, 4);
      await tester.pump();
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(request.rating, 4);
      expect(updated.single.rating, 4);
      expect(updated.single.partner.partnerIntro.partnerImageLink,
          '/condominiums/$condoId/comfort/p1/image/hash-r');
      expect(toasts, ['comfort_rate_success_title']);
      expect(sheet, findsNothing);
      expect(updateAllCalls, 0);
      // Consome o timer do toast.
      await tester.pump(const Duration(seconds: 2));
    });

    testWidgets('falha ao avaliar abre a página de erro; tentar de novo só fecha',
        (tester) async {
      final request = buildRequest();
      await open(tester, request);
      harness.http.failAll();

      await setRating(tester, 5);
      await tester.pump();
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(request.rating, isNull);
      expect(find.byType(ComfortCupomRequesResultPage), findsOneWidget);
      expect(find.text('comfort_request_error_title'), findsOneWidget);
      expect(find.text('comfort_request_error_subtitle'), findsOneWidget);

      harness.http.requests.clear();
      await tester.tap(find.text('try_again'));
      await tester.pumpAndSettle();
      expect(find.byType(ComfortCupomRequesResultPage), findsNothing);
      expect(sheet, findsOneWidget);
      expect(harness.http.requests, isEmpty);
      expect(updated, isEmpty);
    });

    testWidgets('com nota já existente a barra fica travada e voltar fecha',
        (tester) async {
      await open(tester, buildRequest(rating: 3));

      final bar = tester.widget<RatingBar>(find.byType(RatingBar));
      expect(bar.ignoreGestures, isTrue);
      expect(bar.initialRating, 3);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(sheet, findsNothing);
      expect(find.byKey(const Key('push-host')), findsOneWidget);
      expect(harness.http.requests, isEmpty);
    });
  });

  group('reenviar', () {
    testWidgets('sucesso abre a página de sucesso e atualiza a lista',
        (tester) async {
      await open(tester, buildRequest());
      harness.http.on('PUT', harness.resendPath('r1'),
          body: requestJson('r1', status: 'resent'));

      await tester.tap(find.text('comfort_request_resend_button'));
      await tester.pumpAndSettle();

      expect(updateAllCalls, 1);
      expect(updated, isEmpty);
      expect(find.byType(ComfortMyRequestItemActionsSuccessPage), findsOneWidget);
      expect(find.text('comfort_request_actions_resend_success_title'),
          findsOneWidget);
      expect(find.text('comfort_request_actions_resend_success_subtitle'),
          findsOneWidget);
      expect(find.text(condoName), findsOneWidget);
      expect(sheet, findsNothing);
      await expectLater(find.byType(ComfortMyRequestItemActionsSuccessPage),
          matchesGoldenFile('goldens/item_actions_success_page.png'));

      await tester.tap(find.text('ok'));
      await tester.pumpAndSettle();
      expect(find.byType(ComfortMyRequestItemActionsSuccessPage), findsNothing);
      expect(find.byKey(const Key('push-host')), findsOneWidget);
    });

    testWidgets('falha abre o erro; tentar de novo reenvia', (tester) async {
      await open(tester, buildRequest());
      harness.http.failAll();

      await tester.tap(find.text('comfort_request_resend_button'));
      await tester.pumpAndSettle();
      expect(find.byType(ComfortCupomRequesResultPage), findsOneWidget);

      // Cancelar volta ao sheet, que continua exibindo a solicitação.
      await tester.tap(find.text('cancel'));
      await tester.pumpAndSettle();
      expect(sheet, findsOneWidget);
      expect(find.text('comfort_request_resend_button'), findsOneWidget);

      await tester.tap(find.text('comfort_request_resend_button'));
      await tester.pumpAndSettle();
      harness.http.reset();
      harness.http.on('PUT', harness.resendPath('r1'),
          body: requestJson('r1', status: 'resent'));
      await tester.tap(find.text('try_again'));
      await tester.pumpAndSettle();

      expect(harness.paths, [harness.resendPath('r1')]);
      expect(find.byType(ComfortMyRequestItemActionsSuccessPage), findsOneWidget);
      expect(updateAllCalls, 1);
    });

    testWidgets('sem permissão de reenvio o botão fica desabilitado',
        (tester) async {
      await open(tester,
          buildRequest(isCanResend: false, resendDate: DateTime(2026, 1, 12)));

      expect(find.text('comfort_request_resent_button'), findsOneWidget);
      expect(find.text('comfort_request_resend_button'), findsNothing);
      await tester.tap(find.text('comfort_request_resent_button'));
      await tester.pumpAndSettle();
      expect(harness.http.requests, isEmpty);
      expect(sheet, findsOneWidget);
    });

    testWidgets('sem permissão de cancelamento esconde os botões',
        (tester) async {
      await open(tester, buildRequest(isCanCancel: false));
      expect(find.text('comfort_request_cancel_button'), findsNothing);
      expect(find.text('comfort_request_resend_button'), findsNothing);
    });
  });

  group('cancelar', () {
    testWidgets('diálogo de confirmação: voltar fecha, confirmar cancela',
        (tester) async {
      await open(tester, buildRequest());
      harness.http.on('DELETE', harness.cancelPath('r1'),
          body: requestJson('r1', status: 'canceled', isCanCancel: false));

      await tester.tap(find.text('comfort_request_cancel_button'));
      await tester.pumpAndSettle();
      expect(find.text('attention!'), findsOneWidget);
      expect(find.text('comfort_request_actions_cancel_warning_1'), findsOneWidget);
      expect(find.text('comfort_request_actions_cancel_warning_2'), findsOneWidget);

      await tester.tap(find.text('back'));
      await tester.pumpAndSettle();
      expect(find.text('attention!'), findsNothing);
      expect(harness.http.requests, isEmpty);

      await tester.tap(find.text('comfort_request_cancel_button'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Confirmar'));
      await tester.pumpAndSettle();

      expect(harness.http.requests.single.method, 'DELETE');
      expect(updated.single.isCanCancel, isFalse);
      expect(find.text('comfort_request_actions_cancel_success_title'),
          findsOneWidget);
      expect(find.text('comfort_request_actions_cancel_success_subtitle'),
          findsOneWidget);
      expect(sheet, findsNothing);
    });

    testWidgets('falha abre o erro; tentar de novo cancela', (tester) async {
      await open(tester, buildRequest());
      harness.http.failAll();

      await tester.tap(find.text('comfort_request_cancel_button'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Confirmar'));
      await tester.pumpAndSettle();
      expect(find.byType(ComfortCupomRequesResultPage), findsOneWidget);

      harness.http.reset();
      harness.http.on('DELETE', harness.cancelPath('r1'),
          body: requestJson('r1', status: 'canceled'));
      await tester.tap(find.text('try_again'));
      await tester.pumpAndSettle();

      expect(harness.paths, [harness.cancelPath('r1')]);
      expect(find.text('comfort_request_actions_cancel_success_title'),
          findsOneWidget);
    });
  });

  group('mensagem', () {
    testWidgets('formulário valida, envia e abre a página de sucesso',
        (tester) async {
      final request = buildRequest();
      await open(tester, request);
      harness.http.on('POST', harness.updatePath('r1'),
          body: requestJson('r1', comment: 'Preciso de ajuda', messageType: 'complaint'));

      await tester.tap(find.text('comfort_message_need_help'));
      await tester.pumpAndSettle();
      expect(find.text('comfort_message_need_help_subtitle'), findsOneWidget);
      expect(find.text('comfort_rate_rating'), findsNothing);
      expect(find.text('comfort_request_resend_button'), findsNothing);

      // Sem preencher: validação obrigatória nos dois campos.
      await tester.tap(find.text('send'));
      await tester.pumpAndSettle();
      expect(find.text('validation_required'), findsNWidgets(2));
      expect(harness.http.requests, isEmpty);

      await tester.tap(find.byType(DropdownButtonFormField<ComfortRequestMessageType>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('comfort_message_subject_complaint').last);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), 'Preciso de ajuda');
      await tester.pumpAndSettle();
      await expectLater(
          sheet, matchesGoldenFile('goldens/item_actions_message_form.png'));

      await tester.tap(find.text('send'));
      await tester.pumpAndSettle();

      expect(request.messageType, ComfortRequestMessageType.complaint);
      expect(request.comment, 'Preciso de ajuda');
      expect(harness.http.requests.single.body, contains('"message_type":"complaint"'));
      expect(updated.single.comment, 'Preciso de ajuda');
      expect(find.text('comfort_request_actions_message_success_title'),
          findsOneWidget);
      expect(find.text('comfort_request_actions_message_success_subtitle'),
          findsOneWidget);

      // A página de sucesso foi empilhada: ok volta para o sheet.
      await tester.tap(find.text('ok'));
      await tester.pumpAndSettle();
      expect(sheet, findsOneWidget);
    });

    testWidgets('cancelar volta para os botões', (tester) async {
      await open(tester, buildRequest());
      await tester.tap(find.text('comfort_message_need_help'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('cancel'));
      await tester.pumpAndSettle();
      expect(find.text('comfort_message_need_help_subtitle'), findsNothing);
      expect(find.text('comfort_request_resend_button'), findsOneWidget);
      expect(find.text('comfort_rate_rating'), findsOneWidget);
    });

    testWidgets('falha ao enviar abre o erro; tentar de novo reenvia a mensagem',
        (tester) async {
      await open(tester, buildRequest());
      harness.http.failAll();

      await tester.tap(find.text('comfort_message_need_help'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(DropdownButtonFormField<ComfortRequestMessageType>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('comfort_message_subject_suggestion').last);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), 'Sugestão');
      await tester.tap(find.text('send'));
      await tester.pumpAndSettle();
      expect(find.byType(ComfortCupomRequesResultPage), findsOneWidget);

      harness.http.reset();
      harness.http.on('POST', harness.updatePath('r1'),
          body: requestJson('r1', comment: 'Sugestão', messageType: 'suggestion'));
      await tester.tap(find.text('try_again'));
      await tester.pumpAndSettle();

      expect(harness.paths, [harness.updatePath('r1')]);
      expect(find.text('comfort_request_actions_message_success_title'),
          findsOneWidget);
    });

    testWidgets('solicitação com mensagem enviada permite ver e esconder',
        (tester) async {
      await open(
        tester,
        buildRequest(
          comment: 'Já mandei',
          messageType: ComfortRequestMessageType.did_not_receive_return,
          messageDate: DateTime(2026, 1, 11, 9, 5),
        ),
      );

      expect(find.text('comfort_message_view'), findsOneWidget);
      await tester.tap(find.text('comfort_message_view'));
      await tester.pumpAndSettle();

      expect(find.text('comfort_message_hide'), findsOneWidget);
      expect(find.text('comfort_message_subject'), findsOneWidget);
      // Chave longa traduzida por `sheetLoc`.
      expect(find.text('Sem retorno'), findsOneWidget);
      expect(find.text('comfort_message_text'), findsOneWidget);
      expect(find.text('Já mandei'), findsOneWidget);
      expect(find.text('comfort_message_sended_at'), findsOneWidget);
      // Os botões continuam disponíveis abaixo da mensagem.
      expect(find.text('comfort_request_resend_button'), findsOneWidget);

      await tester.tap(find.text('comfort_message_hide'));
      await tester.pumpAndSettle();
      expect(find.text('comfort_message_view'), findsOneWidget);
      expect(find.text('Já mandei'), findsNothing);
    });
  });
}
