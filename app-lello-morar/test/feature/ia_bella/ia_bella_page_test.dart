import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/ia_bella/domain/entity/bella_message_entity.dart';
import 'package:morar/feature/ia_bella/domain/use_case/send_message/ia_bella_send_message_use_case.dart';
import 'package:morar/feature/ia_bella/presentation/bloc/ia_bella_state.dart';
import 'package:morar/feature/ia_bella/presentation/controllers/ia_bella_controller.dart';
import 'package:morar/feature/ia_bella/presentation/page/ia_bella_page.dart';
import 'package:morar/feature/ia_bella/presentation/widgets/bella_document_message.dart';
import 'package:morar/feature/ia_bella/presentation/widgets/bella_feedback_success_dialog.dart';
import 'package:morar/feature/ia_bella/presentation/widgets/bella_info_bottomsheet.dart';
import 'package:morar/feature/ia_bella/presentation/widgets/bella_not_available_widget.dart';
import 'package:morar/feature/ia_bella/presentation/widgets/bella_not_resolved_dialog.dart';
import 'package:morar/feature/ia_bella/presentation/widgets/feedback_row.dart';
import 'package:morar/feature/ia_bella/presentation/widgets/final_evaluation_dialog.dart';
import 'package:morar/feature/ia_bella/presentation/widgets/message_timeout_dialog.dart';
import 'package:morar/feature/ia_bella/presentation/widgets/negative_feedback_dialog.dart';

import '../../helpers/fake_url_launcher.dart';
import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';
import 'ia_bella_page_helpers.dart';

void main() {
  late PageHarness harness;
  late RecordingNavigatorObserver observer;
  late FakeUrlLauncherPlatform launcher;

  setUpAll(() => initializeDateFormatting('pt_BR'));

  setUp(() async {
    harness = await installPageHarness();
    observer = RecordingNavigatorObserver();
    launcher = installFakeUrlLauncher();
    harness.http.on('POST', startSessionPath, body: sessionJson());
    harness.http.on('POST', newQuestionPath, body: answerJson());
    harness.http.on('PUT', evaluatePath, body: rateJson('r1'));
    harness.http.on('POST', finalEvaluationPath, body: {
      'uuid_session': 'sess-1',
      'evaluation': 4,
      'comment': 'ok',
      'request_resolved': true,
    });
  });

  IaBellaController controller() => harness.resolve<IaBellaController>();

  List<String> paths() => harness.http.requests.map((r) => r.url.path).toList();

  Map<String, dynamic> lastBody(String path) => jsonDecode(
        harness.http.requests.lastWhere((r) => r.url.path == path).body,
      ) as Map<String, dynamic>;

  Future<void> systemBack(WidgetTester tester) async {
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    await navigator.maybePop();
    await tester.pumpAndSettle();
  }

  Future<void> tapAppBarBack(WidgetTester tester) async {
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
  }

  /// Preenche o diálogo de avaliação final (polegar, estrela e comentário)
  /// e envia.
  Future<void> fillAndSendFinalEvaluation(
    WidgetTester tester, {
    required bool resolved,
    int stars = 4,
  }) async {
    expect(find.byType(FinalEvaluationDialog), findsOneWidget);
    // Sem polegar e estrela o botão de enviar fica desabilitado.
    final sendButton = find.ancestor(
      of: find.text('Enviar avaliação e sair'),
      matching: find.byType(ElevatedButton),
    );
    expect(tester.widget<ElevatedButton>(sendButton).onPressed, isNull);

    await tester.tap(find.byIcon(
        resolved ? Icons.thumb_up_outlined : Icons.thumb_down_outlined));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.star).at(stars - 1));
    await tester.pump();
    await tester.enterText(
      find.descendant(
        of: find.byType(FinalEvaluationDialog),
        matching: find.byType(TextFormField),
      ),
      'Muito bom',
    );
    await tester.pump();
    expect(find.text('9/200'), findsOneWidget);
    expect(tester.widget<ElevatedButton>(sendButton).onPressed, isNotNull);

    await tester.tap(sendButton);
    await tester.pumpAndSettle();
  }

  testWidgets('inicia a sessão e mostra boas-vindas, data e chips',
      (tester) async {
    await pumpBella(tester, observer: observer);

    expect(paths(), [startSessionPath]);
    expect(find.text('Olá! Eu sou a Bella', findRichText: true),
        findsOneWidget);
    expect(find.textContaining('Hoje,'), findsOneWidget);
    expect(find.byType(ActionChip), findsNWidgets(3));
    expect(find.text('second_bill_copy'), findsOneWidget);
    expect(find.text('last_assembly_chip'), findsOneWidget);
    expect(find.text('condominium_rules'), findsOneWidget);
    expect(find.text('ia_bella_title'), findsOneWidget);
    expect(find.text('bella_error_warning_title'), findsOneWidget);
    expect(tester.widget<TextField>(find.byType(TextField)).enabled, isTrue);
    // A mensagem de boas-vindas (índice 0) não recebe avaliação.
    expect(find.byType(FeedbackRow), findsNothing);
    expect(controller().isSessionStarted, isTrue);

    await expectLater(
      find.byType(IABellaPage),
      matchesGoldenFile('goldens/ia_bella_page.png'),
    );
  });

  testWidgets('enquanto a sessão inicia mostra o indicador de progresso',
      (tester) async {
    await pumpBella(tester);
    await emitState(tester, controller().bloc, const IaBellaStartSessionState(),
        settle: false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets('falha ao iniciar a sessão mostra indisponível e volta ao início',
      (tester) async {
    harness.http.failAll();
    await pumpBella(tester, observer: observer);

    expect(find.byType(BellaNotAvailableWidget), findsOneWidget);
    expect(find.text('bella_not_available_title'), findsOneWidget);
    expect(controller().bloc.state, const IaBellaStartSessionErrorState());

    await tester.tap(find.text('Voltar para o início'));
    await tester.pumpAndSettle();

    expect(find.byType(IABellaPage), findsNothing);
    expect(find.byKey(bellaBaseKey), findsOneWidget);
  });

  testWidgets('sessão sem uuid mostra erro desconhecido e bloqueia o envio',
      (tester) async {
    harness.http.on('POST', startSessionPath, body: sessionJson(uuid: null));
    await pumpBella(tester);

    expect(find.text('Erro desconhecido', findRichText: true), findsOneWidget);
    expect(controller().isSessionStarted, isFalse);
    expect(tester.widget<TextField>(find.byType(TextField)).enabled, isFalse);

    // Chip ignorado sem sessão iniciada.
    await tester.tap(find.text('second_bill_copy'));
    await tester.pumpAndSettle();
    expect(paths(), [startSessionPath]);
  });

  testWidgets('enviar mensagem digitada mostra pergunta e resposta',
      (tester) async {
    await pumpBella(tester);

    // Texto vazio não envia nada.
    await tester.tap(findSendButton());
    await tester.pumpAndSettle();
    expect(paths(), [startSessionPath]);

    await sendText(tester, 'Como pago o boleto?');

    expect(paths(), [startSessionPath, newQuestionPath]);
    final body = lastBody(newQuestionPath);
    expect(body['question'], 'Como pago o boleto?');
    expect(body['uuid_session'], 'sess-1');
    expect(find.text('Como pago o boleto?', findRichText: true), findsOneWidget);
    expect(find.text('Aqui está a resposta', findRichText: true), findsOneWidget);
    expect(find.byType(ActionChip), findsNothing);
    expect(find.byType(FeedbackRow), findsOneWidget);
    expect(controller().messageController.text, '');
    expect(controller().checkSendMessage, isTrue);
    expect(controller().bloc.state, isA<IaBellaLoadedState>());
  });

  testWidgets('chip envia o prompt e exibe o texto de exibição',
      (tester) async {
    await pumpBella(tester);

    await tester.tap(find.text('last_assembly_chip'));
    await tester.pumpAndSettle();

    expect(lastBody(newQuestionPath)['question'], 'last_assembly_prompt');
    expect(find.text('last_assembly', findRichText: true), findsOneWidget);
    expect(find.byType(ActionChip), findsNothing);
  });

  testWidgets('chip é ignorado enquanto a Bella responde', (tester) async {
    await pumpBella(tester);
    await emitState(tester, controller().bloc, const IaBellaLoadingState(),
        settle: false);

    await tester.tap(find.text('condominium_rules'));
    await tester.pump();

    expect(paths(), [startSessionPath]);
    expect(find.byType(ActionChip), findsNWidgets(3));
    expect(tester.widget<TextField>(find.byType(TextField)).enabled, isFalse);
  });

  testWidgets('erro ao enviar mostra a mensagem de instabilidade',
      (tester) async {
    harness.http.on('POST', newQuestionPath, status: 500, body: {'m': 'x'});
    await pumpBella(tester);

    await sendText(tester, 'oi');

    expect(find.textContaining('instabilidade', findRichText: true),
        findsOneWidget);
    expect(controller().bloc.state, isA<IaBellaErrorState>());
    // Resposta de erro não tem responseId: sem avaliação.
    expect(find.byType(FeedbackRow), findsNothing);
  });

  testWidgets('mensagem pendente nos argumentos é enviada ao iniciar',
      (tester) async {
    await pumpBella(
      tester,
      arguments: BellaMessageEntity(text: 'boletos', isUser: true),
    );

    expect(paths(), [startSessionPath, newQuestionPath]);
    expect(lastBody(newQuestionPath)['question'], 'boletos');
    expect(find.byType(ActionChip), findsNothing);

    /// Corrigido: o bloco morto do `build` que reenviava a mensagem pendente
    /// em `IaBellaSessionStartedState` foi removido; emitir esse estado não
    /// dispara um segundo envio da mesma mensagem.
    await emitState(
        tester, controller().bloc, const IaBellaSessionStartedState('s'));
    expect(paths(), [startSessionPath, newQuestionPath]);
  });

  testWidgets('argumento sem texto não dispara envio', (tester) async {
    await pumpBella(tester, arguments: BellaMessageEntity(text: ''));

    expect(paths(), [startSessionPath]);
    expect(find.byType(ActionChip), findsNWidgets(3));
  });

  testWidgets('avaliação positiva marca o polegar e pode ser desfeita',
      (tester) async {
    await pumpBella(tester);
    await sendText(tester, 'oi');

    await tester.tap(findSvg('assets/ic_thumbs_up.svg'));
    await tester.pumpAndSettle();

    expect(paths().last, evaluatePath);
    var body = lastBody(evaluatePath);
    expect(body['response_id'], 'r1');
    expect(body['evaluation_type'], 'POSITIVE');
    expect(findSvg('assets/ic_thumbs_up_selected.svg'), findsOneWidget);
    expect(findSvg('assets/ic_thumbs_down.svg'), findsNothing);
    expect(controller().bloc.state, const IaBellaRateMessageSuccessState('r1'));

    // Tocar de novo desfaz a avaliação (sem tipo).
    await tester.tap(findSvg('assets/ic_thumbs_up_selected.svg'));
    await tester.pumpAndSettle();
    body = lastBody(evaluatePath);
    expect(body['evaluation_type'], isNull);
    expect(findSvg('assets/ic_thumbs_up.svg'), findsOneWidget);
    expect(findSvg('assets/ic_thumbs_down.svg'), findsOneWidget);
  });

  testWidgets('falha na avaliação mantém os polegares sem seleção',
      (tester) async {
    await pumpBella(tester);
    await sendText(tester, 'oi');
    harness.http.on('PUT', evaluatePath, status: 500, body: {'m': 'x'});

    await tester.tap(findSvg('assets/ic_thumbs_down.svg'));
    await tester.pumpAndSettle();

    expect(findSvg('assets/ic_thumbs_up.svg'), findsOneWidget);
    expect(findSvg('assets/ic_thumbs_down_selected.svg'), findsNothing);
    expect(controller().bloc.state, isA<IaBellaErrorState>());
  });

  testWidgets('avaliação negativa abre a justificativa e envia', (tester) async {
    await pumpBella(tester);
    await sendText(tester, 'oi');

    await tester.tap(findSvg('assets/ic_thumbs_down.svg'));
    await tester.pumpAndSettle();
    expect(lastBody(evaluatePath)['evaluation_type'], 'NEGATIVE');
    expect(findSvg('assets/ic_thumbs_down_selected.svg'), findsOneWidget);
    expect(findSvg('assets/send_feedback_button.svg'), findsOneWidget);

    /// Corrigido: `FeedbackRow._handleSendFeedback` trata o `null` devolvido
    /// pelo `showDialog` quando o diálogo é fechado em "Voltar" como
    /// cancelamento, sem lançar `type 'Null' is not a subtype of type 'bool'`.
    await tester.tap(findSvg('assets/send_feedback_button.svg'));
    await tester.pumpAndSettle();
    expect(find.byType(NegativeFeedbackDialog), findsOneWidget);

    // "Voltar" fecha sem enviar.
    await tester.tap(find.text('Voltar'));
    await tester.pumpAndSettle();
    expect(find.byType(NegativeFeedbackDialog), findsNothing);
    expect(tester.takeException(), isNull);
    // O polegar negativo continua selecionado e o envio segue disponível.
    expect(findSvg('assets/ic_thumbs_down_selected.svg'), findsOneWidget);

    await tester.tap(findSvg('assets/send_feedback_button.svg'));
    await tester.pumpAndSettle();
    final requestsBefore = harness.http.requests.length;
    // Sem texto o "Enviar" não faz nada.
    await tester.tap(find.text('Enviar'));
    await tester.pumpAndSettle();
    expect(harness.http.requests.length, requestsBefore);
    expect(find.byType(NegativeFeedbackDialog), findsOneWidget);

    await tester.enterText(
      find.descendant(
        of: find.byType(NegativeFeedbackDialog),
        matching: find.byType(TextFormField),
      ),
      'Resposta incompleta',
    );
    await tester.pump();
    expect(find.text('19/200'), findsOneWidget);
    await tester.tap(find.text('Enviar'));
    await tester.pumpAndSettle();

    final body = lastBody(evaluatePath);
    expect(body['justification'], 'Resposta incompleta');
    expect(body['evaluation_type'], 'NEGATIVE');
    expect(find.byType(NegativeFeedbackDialog), findsNothing);
    expect(controller().negativeFeedbackController.text, '');
    // Depois de justificar, os botões ficam desabilitados.
    final sendIcon = find.ancestor(
      of: findSvg('assets/send_feedback_button.svg'),
      matching: find.byType(IconButton),
    );
    expect(tester.widget<IconButton>(sendIcon).onPressed, isNull);
  });

  testWidgets('justificativa negativa com falha mantém o diálogo aberto',
      (tester) async {
    await pumpBella(tester);
    await sendText(tester, 'oi');
    await tester.tap(findSvg('assets/ic_thumbs_down.svg'));
    await tester.pumpAndSettle();
    await tester.tap(findSvg('assets/send_feedback_button.svg'));
    await tester.pumpAndSettle();

    harness.http.on('PUT', evaluatePath, status: 500, body: {'m': 'x'});
    await tester.enterText(
      find.descendant(
        of: find.byType(NegativeFeedbackDialog),
        matching: find.byType(TextFormField),
      ),
      'ruim',
    );
    await tester.pump();
    await tester.tap(find.text('Enviar'));
    await tester.pumpAndSettle();

    expect(find.byType(NegativeFeedbackDialog), findsOneWidget);
  });

  group('documentos da resposta', () {
    setUp(() {
      harness.http.on('POST', newQuestionPath,
          body: answerJson(docs: [docJson('d1')]));
      harness.http.on('GET', '$downloadPdfPath*', body: {
        'file_name': 'ata.pdf',
        'content': base64Encode(utf8.encode('pdf')),
      });
    });

    testWidgets('resposta com documento mostra o card e os estados de carga',
        (tester) async {
      await pumpBella(tester);
      await sendText(tester, 'ata');

      expect(find.byType(BellaDocumentMessage), findsOneWidget);
      expect(find.text('Ata da assembleia.pdf'), findsOneWidget);
      expect(find.text('Baixar'), findsOneWidget);
      expect(find.text('Visualizar'), findsOneWidget);
      expect(controller().messages.last.documents, hasLength(1));

      final progress = find.descendant(
        of: find.byType(BellaDocumentMessage),
        matching: find.byType(CircularProgressIndicator),
      );
      await emitState(
          tester, controller().bloc, const IaBellaDownloadingState('d1'),
          settle: false);
      await tester.pump();
      expect(progress, findsOneWidget);
      expect(find.text('Baixar'), findsNothing);

      await emitState(
          tester, controller().bloc, const IaBellaRenderingPdfState('d1'),
          settle: false);
      await tester.pump();
      expect(progress, findsOneWidget);
      expect(find.text('Visualizar'), findsNothing);

      // Outro documento em carga não afeta este card.
      await emitState(
          tester, controller().bloc, const IaBellaDownloadingState('outro'),
          settle: false);
      await tester.pump();
      expect(progress, findsNothing);
    });

    /// O `PDFScreen` usa um visualizador nativo que não roda no
    /// `flutter test`: gravamos o arquivo com um path_provider falso,
    /// deixamos o `Navigator.push` acontecer e desmontamos a árvore antes
    /// do frame que construiria o visualizador.
    testWidgets('visualizar grava o pdf temporário e abre o visualizador',
        (tester) async {
      final dir = installFakePathProvider();
      await pumpBella(tester, observer: observer);
      await sendText(tester, 'ata');
      final pushes = observer.pushed.length;

      await tester.runAsync(() async {
        await tester.tap(find.text('Visualizar'));
        await tester.pump();
        await Future<void>.delayed(const Duration(milliseconds: 300));
        expect(File('${dir.path}/document.pdf').readAsStringSync(), 'pdf');
        expect(controller().bloc.state, const IaBellaRenderPdfSuccessState('d1'));
        expect(observer.pushed.length, pushes + 1);
        await tester.pumpWidget(const SizedBox());
      });

      final request =
          harness.http.requests.lastWhere((r) => r.url.path.contains('download_pdf'));
      expect(request.url.queryParameters['documentId'], 'd1');
      expect(request.url.queryParameters['serviceType'], 'ATA');
    });

    testWidgets('visualizar com erro da api emite estado de erro',
        (tester) async {
      harness.http.on('GET', '$downloadPdfPath*', status: 500, body: {'m': 'x'});
      await pumpBella(tester);
      await sendText(tester, 'ata');

      await tester.tap(find.text('Visualizar'));
      await tester.pumpAndSettle();

      expect(controller().bloc.state, isA<IaBellaErrorState>());
      expect(find.byType(BellaDocumentMessage), findsOneWidget);
    });

    testWidgets('baixar salva o pdf no caminho escolhido', (tester) async {
      final dir = installFakePathProvider();
      final picker = installFakeFilePicker()..savePath = dir.path;
      await pumpBella(tester);
      await sendText(tester, 'ata');

      await tester.runAsync(() async {
        await tester.tap(find.text('Baixar'));
        await tester.pump();
        await Future<void>.delayed(const Duration(milliseconds: 300));
      });
      await tester.pumpAndSettle();

      expect(picker.saves, 1);
      expect(picker.lastFileName, 'ata.pdf');
      expect(picker.lastBytes, utf8.encode('pdf'));
      expect(File('${dir.path}/ata.pdf').readAsStringSync(), 'pdf');
      expect(controller().bloc.state, const IaBellaDownloadPdfSuccessState());
      expect(find.text('Baixar'), findsOneWidget);
    });

    testWidgets('baixar cancelado ou com falha de escrita emite erro',
        (tester) async {
      final picker = installFakeFilePicker();
      await pumpBella(tester);
      await sendText(tester, 'ata');

      await tester.tap(find.text('Baixar'));
      await tester.pumpAndSettle();
      expect(controller().bloc.state,
          const IaBellaErrorState('Erro: Caminho de salvamento não selecionado!'));

      picker.savePath = '/caminho/que/nao/existe';
      await tester.runAsync(() async {
        await tester.tap(find.text('Baixar'));
        await tester.pump();
        await Future<void>.delayed(const Duration(milliseconds: 300));
      });
      await tester.pumpAndSettle();
      final state = controller().bloc.state;
      expect(state, isA<IaBellaErrorState>());
      expect((state as IaBellaErrorState).message,
          startsWith('Erro ao salvar/abrir o PDF'));
    });

    testWidgets('pdf sem conteúdo emite erro', (tester) async {
      harness.http.on('GET', '$downloadPdfPath*', body: {'file_name': 'a.pdf'});
      installFakeFilePicker().savePath = '/tmp';
      await pumpBella(tester);
      await sendText(tester, 'ata');

      await tester.tap(find.text('Baixar'));
      await tester.pumpAndSettle();
      expect(controller().bloc.state,
          const IaBellaErrorState('Erro: O conteúdo do PDF é nulo!'));

      harness.http.on('GET', '$downloadPdfPath*',
          body: {'file_name': 'a.pdf', 'content': ''});
      await tester.tap(find.text('Visualizar'));
      await tester.pumpAndSettle();
      expect(controller().bloc.state,
          const IaBellaErrorState('Erro: O conteúdo do PDF está vazio!'));
    });
  });

  group('links do markdown', () {
    testWidgets('link de feature navega para a rota resolvida',
        (tester) async {
      harness.http.on('POST', newQuestionPath,
          body: answerJson(response: 'Veja seus [boletos](boletos) aqui'));
      await pumpBella(tester, observer: observer);
      await sendText(tester, 'boletos');

      tapLinkSpan(tester, 'boletos');
      await tester.pumpAndSettle();

      expect(observer.pushedNames.last, ApplicationRoute.billets);
      expect(findRoute(ApplicationRoute.billets), findsOneWidget);
      expect(launcher.launched, isEmpty);
    });

    testWidgets('link externo abre no navegador', (tester) async {
      harness.http.on('POST', newQuestionPath,
          body: answerJson(response: 'Acesse o [site](https://lello.com.br)'));
      await pumpBella(tester, observer: observer);
      await sendText(tester, 'site');

      tapLinkSpan(tester, 'site');
      await tester.pumpAndSettle();

      expect(launcher.launched, ['https://lello.com.br']);
      expect(find.byType(IABellaPage), findsOneWidget);
    });

    testWidgets('link sem esquema e sem feature é ignorado', (tester) async {
      harness.http.on('POST', newQuestionPath,
          body: answerJson(response: 'Nada em [aqui](nada)'));
      await pumpBella(tester, observer: observer);
      await sendText(tester, 'nada');
      final pushes = observer.pushed.length;

      tapLinkSpan(tester, 'aqui');
      await tester.pumpAndSettle();

      expect(launcher.launched, isEmpty);
      expect(observer.pushed.length, pushes);
    });
  });

  group('voltar', () {
    testWidgets('sem conversa a seta do app bar fecha a página',
        (tester) async {
      await pumpBella(tester, observer: observer);

      await tapAppBarBack(tester);

      expect(find.byType(IABellaPage), findsNothing);
      expect(find.byKey(bellaBaseKey), findsOneWidget);
      // Ao desmontar, a página limpa as mensagens do controller.
      expect(controller().messages, isEmpty);
      expect(controller().checkSendMessage, isFalse);
    });

    testWidgets('sem conversa o voltar do sistema fecha a página',
        (tester) async {
      await pumpBella(tester, observer: observer);

      await systemBack(tester);

      expect(find.byType(IABellaPage), findsNothing);
      expect(find.byKey(bellaBaseKey), findsOneWidget);
    });

    testWidgets('após conversar a seta pede a avaliação final (resolvido)',
        (tester) async {
      await pumpBella(tester, observer: observer);
      await sendText(tester, 'oi');

      await tapAppBarBack(tester);
      await fillAndSendFinalEvaluation(tester, resolved: true, stars: 4);

      final body = lastBody(finalEvaluationPath);
      expect(body['uuid_session'], 'sess-1');
      expect(body['evaluation'], 4);
      expect(body['comment'], 'Muito bom');
      expect(body['request_resolved'], isTrue);
      expect(find.byType(FinalEvaluationDialog), findsNothing);
      expect(find.byType(BellaFeedbackSuccessDialog), findsOneWidget);
      expect(find.text('bella_feedback_success_message'), findsOneWidget);
      // Campos limpos após o sucesso.
      expect(controller().selectedFeedbackRating, 0);
      expect(controller().selectedRequestResolved, isNull);
      expect(controller().finalEvaluationController.text, '');

      await tester.tap(find.text('Fechar'));
      await tester.pumpAndSettle();

      expect(find.byType(BellaFeedbackSuccessDialog), findsNothing);
      expect(find.byType(IABellaPage), findsNothing);
      expect(find.byKey(bellaBaseKey), findsOneWidget);
    });

    testWidgets('após conversar o voltar do sistema pede a avaliação (não resolvido: encerrar)',
        (tester) async {
      await pumpBella(tester, observer: observer);
      await sendText(tester, 'oi');

      await systemBack(tester);
      await fillAndSendFinalEvaluation(tester, resolved: false, stars: 2);

      expect(lastBody(finalEvaluationPath)['request_resolved'], isFalse);
      expect(lastBody(finalEvaluationPath)['evaluation'], 2);
      expect(find.byType(BellaNotResolvedDialog), findsOneWidget);

      await tester.tap(find.text('Encerrar'));
      await tester.pumpAndSettle();

      expect(find.byType(BellaNotResolvedDialog), findsNothing);
      expect(find.byType(IABellaPage), findsNothing);
      expect(find.byKey(bellaBaseKey), findsOneWidget);
    });

    testWidgets('não resolvido: "tentar novamente" reinicia a conversa',
        (tester) async {
      await pumpBella(tester, observer: observer);
      await sendText(tester, 'oi');
      expect(find.byType(ActionChip), findsNothing);

      await tapAppBarBack(tester);
      await fillAndSendFinalEvaluation(tester, resolved: false);
      await tester.tap(find.text('Tentar novamente'));
      await tester.pumpAndSettle();

      expect(find.byType(BellaNotResolvedDialog), findsNothing);
      expect(find.byType(IABellaPage), findsOneWidget);
      expect(paths().where((p) => p == startSessionPath), hasLength(2));
      expect(controller().messages, hasLength(1));
      expect(controller().checkSendMessage, isFalse);
      expect(find.byType(ActionChip), findsNWidgets(3));
      expect(find.text('Como pago?', findRichText: true), findsNothing);
    });

    testWidgets('voltar do sistema, não resolvido: "tentar novamente" reinicia',
        (tester) async {
      await pumpBella(tester, observer: observer);
      await sendText(tester, 'oi');

      await systemBack(tester);
      await fillAndSendFinalEvaluation(tester, resolved: false);
      await tester.tap(find.text('Tentar novamente'));
      await tester.pumpAndSettle();

      expect(find.byType(BellaNotResolvedDialog), findsNothing);
      expect(find.byType(IABellaPage), findsOneWidget);
      expect(paths().where((p) => p == startSessionPath), hasLength(2));
      expect(controller().messages, hasLength(1));
      expect(find.byType(ActionChip), findsNWidgets(3));
    });

    testWidgets('voltar do sistema: "voltar para a conversa" fecha o diálogo',
        (tester) async {
      await pumpBella(tester, observer: observer);
      await sendText(tester, 'oi');

      await systemBack(tester);
      expect(find.byType(FinalEvaluationDialog), findsOneWidget);
      await tester.tap(find.text('Voltar para a conversa'));
      await tester.pumpAndSettle();

      expect(find.byType(FinalEvaluationDialog), findsNothing);
      expect(find.byType(IABellaPage), findsOneWidget);
      expect(paths(), isNot(contains(finalEvaluationPath)));
    });

    testWidgets('falha na avaliação final mantém o diálogo aberto',
        (tester) async {
      harness.http.on('POST', finalEvaluationPath, status: 500, body: {'m': 'x'});
      await pumpBella(tester, observer: observer);
      await sendText(tester, 'oi');

      await systemBack(tester);
      await fillAndSendFinalEvaluation(tester, resolved: true);

      expect(find.byType(FinalEvaluationDialog), findsOneWidget);
      expect(find.byType(IABellaPage), findsOneWidget);
      expect(controller().bloc.state, isA<IaBellaErrorState>());
      // O comentário digitado é preservado para nova tentativa.
      expect(controller().finalEvaluationController.text, 'Muito bom');
    });

    testWidgets('"voltar para a conversa" fecha o diálogo e limpa os campos',
        (tester) async {
      await pumpBella(tester, observer: observer);
      await sendText(tester, 'oi');

      await tapAppBarBack(tester);
      await tester.enterText(
        find.descendant(
          of: find.byType(FinalEvaluationDialog),
          matching: find.byType(TextFormField),
        ),
        'rascunho',
      );
      await tester.pump();
      await tester.tap(find.text('Voltar para a conversa'));
      await tester.pumpAndSettle();

      expect(find.byType(FinalEvaluationDialog), findsNothing);
      expect(find.byType(IABellaPage), findsOneWidget);
      expect(controller().finalEvaluationController.text, '');
      expect(paths(), isNot(contains(finalEvaluationPath)));
    });
  });

  testWidgets('botão de informações abre e fecha o bottom sheet',
      (tester) async {
    await pumpBella(tester);

    await tester.tap(find.byIcon(Icons.info_outline));
    await tester.pumpAndSettle();

    expect(find.byType(BellaInfoBottomSheet), findsOneWidget);
    expect(find.text('bella_info_title'), findsOneWidget);

    await tester.tap(find.text('Fechar'));
    await tester.pumpAndSettle();

    expect(find.byType(BellaInfoBottomSheet), findsNothing);
  });

  testWidgets('timeout ao enviar mostra o diálogo e volta ao início',
      (tester) async {
    final hanging = HangingSendMessageUseCase();
    await harness.override<IaBellaSendMessageUseCase>(hanging);
    await pumpBella(tester, observer: observer);

    final context = tester.element(find.byType(IABellaPage));
    Object? error;
    final pending = controller()
        .sendMessage(context, BellaMessageEntity(text: 'oi', isUser: true))
        .catchError((e) => error = e);
    await tester.pump();
    expect(hanging.calls, 1);
    expect(find.byType(MessageTimeoutDialog), findsNothing);

    await tester.pump(const Duration(seconds: 61));
    await tester.pumpAndSettle();
    await pending;

    /// Corrigido: após o timeout o `sendMessage` completa normalmente (sem
    /// `Future.error` solto); apenas o diálogo de timeout é exibido.
    expect(error, isNull);
    expect(find.byType(MessageTimeoutDialog), findsOneWidget);
    expect(find.text('bella_timeout_title'), findsOneWidget);

    await tester.tap(find.text('Voltar para o início'));
    await tester.pumpAndSettle();

    expect(find.byType(MessageTimeoutDialog), findsNothing);
    expect(find.byType(IABellaPage), findsNothing);
    expect(find.byKey(bellaBaseKey), findsOneWidget);
  });
}
