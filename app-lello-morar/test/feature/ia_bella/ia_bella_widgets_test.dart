import 'dart:async';

import 'package:essentials/essentials.dart' show FlavorConfig;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/feature/ia_bella/presentation/widgets/bella_document_message.dart';
import 'package:morar/feature/ia_bella/presentation/widgets/bella_feedback_success_dialog.dart';
import 'package:morar/feature/ia_bella/presentation/widgets/bella_header_widget.dart';
import 'package:morar/feature/ia_bella/presentation/widgets/bella_info_bottomsheet.dart';
import 'package:morar/feature/ia_bella/presentation/widgets/bella_not_available_widget.dart';
import 'package:morar/feature/ia_bella/presentation/widgets/bella_not_resolved_dialog.dart';
import 'package:morar/feature/ia_bella/presentation/widgets/bella_whatsapp_dialog.dart';
import 'package:morar/feature/ia_bella/presentation/widgets/feedback_row.dart';
import 'package:morar/feature/ia_bella/presentation/widgets/final_evaluation_dialog.dart';
import 'package:morar/feature/ia_bella/presentation/widgets/message_timeout_dialog.dart';
import 'package:morar/feature/ia_bella/presentation/widgets/negative_feedback_dialog.dart';

import '../../helpers/pump_app.dart';
import 'ia_bella_page_helpers.dart';

void main() {
  setUpAll(FlavorConfig.init);

  group('BellaDocumentMessage', () {
    testWidgets('mostra o nome e aciona baixar/visualizar', (tester) async {
      var downloads = 0;
      var views = 0;
      await pumpApp(
        tester,
        BellaDocumentMessage(
          documentName: 'Regimento.pdf',
          onDownloadPressed: () => downloads++,
          onVisualizePressed: () => views++,
        ),
      );

      expect(find.text('Regimento.pdf'), findsOneWidget);
      expect(find.text('10MB'), findsOneWidget);
      await tester.tap(find.text('Baixar'));
      await tester.tap(find.text('Visualizar'));
      expect(downloads, 1);
      expect(views, 1);
      await tester.pumpAndSettle();

      await expectLater(
        findGoldenSurface(),
        matchesGoldenFile('goldens/bella_document_message.png'),
      );
    });

    testWidgets('em download ou renderização mostra progresso e desabilita',
        (tester) async {
      await pumpApp(
        tester,
        BellaDocumentMessage(
          documentName: 'x.pdf',
          isDownloading: true,
          isRendering: true,
          onDownloadPressed: () {},
          onVisualizePressed: () {},
        ),
        settle: false,
      );

      expect(find.byType(CircularProgressIndicator), findsNWidgets(2));
      expect(find.text('Baixar'), findsNothing);
      expect(find.text('Visualizar'), findsNothing);
      for (final button
          in tester.widgetList<ElevatedButton>(find.byType(ElevatedButton))) {
        expect(button.onPressed, isNull);
      }
    });
  });

  testWidgets('BellaFeedbackSuccessDialog mostra a mensagem e fecha',
      (tester) async {
    var closed = 0;
    await pumpApp(
      tester,
      BellaFeedbackSuccessDialog(onClose: () => closed++),
      localized: true,
    );

    expect(find.text('bella_feedback_success_message'), findsOneWidget);
    expect(findSvg('assets/ic_success_green.svg'), findsOneWidget);
    await tester.tap(find.text('Fechar'));
    expect(closed, 1);
  });

  testWidgets('BellaHeaderWidget monta as camadas do balão da IA',
      (tester) async {
    await pumpApp(tester, const BellaHeaderWidget());

    final prefix = FlavorConfig.config.iaName.toLowerCase();
    expect(findSvg('assets/bella_fundo_bege.svg'), findsOneWidget);
    expect(findSvg('assets/bella_fundo_cinza.svg'), findsOneWidget);
    expect(findSvg('assets/bella_balao_principal.svg'), findsOneWidget);
    expect(findSvg('assets/${prefix}_balao_texto.svg'), findsOneWidget);
    final box = tester.widget<SizedBox>(find
        .descendant(
          of: find.byType(BellaHeaderWidget),
          matching: find.byType(SizedBox),
        )
        .first);
    expect(box.width, 225);
    expect(box.height, 130);
  });

  testWidgets('BellaInfoBottomSheet lista as capacidades e fecha',
      (tester) async {
    await pumpApp(
      tester,
      Builder(
        builder: (context) => ElevatedButton(
          onPressed: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => BellaInfoBottomSheet(),
          ),
          child: const Text('abrir'),
        ),
      ),
      localized: true,
    );

    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();

    expect(find.byType(BellaInfoBottomSheet), findsOneWidget);
    expect(find.byType(BellaHeaderWidget), findsOneWidget);
    expect(find.text('bella_info_title'), findsOneWidget);
    expect(find.text('Com ela, você pode:'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsNWidgets(4));
    expect(find.text('Consultar boletos e 2ª via;'), findsOneWidget);
    expect(find.text('Tirar dúvidas frequentes'), findsOneWidget);
    expect(find.text('bella_privacy_notice'), findsOneWidget);
    expect(find.text('bella_error_warning_title'), findsOneWidget);

    await tester.tap(find.text('Fechar'));
    await tester.pumpAndSettle();
    expect(find.byType(BellaInfoBottomSheet), findsNothing);
  });

  testWidgets('BellaNotAvailableWidget mostra o aviso e volta', (tester) async {
    var back = 0;
    await pumpApp(
      tester,
      BellaNotAvailableWidget(onReturnToMainPage: () => back++),
      localized: true,
    );

    expect(find.text('bella_not_available_title'), findsOneWidget);
    expect(find.text('Tente novamente mais tarde'), findsOneWidget);
    expect(findSvg('assets/ic_bella_not_available_error.svg'), findsOneWidget);
    await tester.tap(find.text('Voltar para o início'));
    expect(back, 1);
    await tester.pumpAndSettle();

    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/bella_not_available.png'),
    );
  });

  testWidgets('BellaNotResolvedDialog aciona tentar novamente e encerrar',
      (tester) async {
    var retry = 0;
    var close = 0;
    await pumpApp(
      tester,
      BellaNotResolvedDialog(onRetry: () => retry++, onClose: () => close++),
    );

    expect(find.text('Sua avaliação foi enviada!'), findsOneWidget);
    await tester.tap(find.text('Tentar novamente'));
    await tester.tap(find.text('Encerrar'));
    expect(retry, 1);
    expect(close, 1);
  });

  testWidgets('BellaWhatsappDialog aciona falar conosco e fechar',
      (tester) async {
    var talk = 0;
    var close = 0;
    await pumpApp(
      tester,
      BellaWhatsappDialog(
        onTalkToUsPressed: () => talk++,
        onClosePressed: () => close++,
      ),
    );

    expect(find.text('Agradecemos seu feedback!'), findsOneWidget);
    expect(findSvg('assets/ic_whatsapp_white.svg'), findsOneWidget);
    await tester.tap(find.text('Fale com a gente'));
    await tester.tap(find.text('Fechar'));
    expect(talk, 1);
    expect(close, 1);
  });

  testWidgets('MessageTimeoutDialog mostra o aviso e volta', (tester) async {
    var back = 0;
    await pumpApp(
      tester,
      MessageTimeoutDialog(onReturnToMainPage: () => back++),
      localized: true,
    );

    expect(find.text('bella_timeout_title'), findsOneWidget);
    expect(findSvg('assets/ic_bella_timeout_error.svg'), findsOneWidget);
    await tester.tap(find.text('Voltar para o início'));
    expect(back, 1);
  });

  group('FeedbackRow', () {
    Future<void> pumpRow(
      WidgetTester tester, {
      required bool rateResult,
      required bool sendResult,
      List<bool?>? received,
      List<int>? sends,
    }) =>
        pumpApp(
          tester,
          FeedbackRow(
            onFeedbackSelected: (value) async {
              received?.add(value);
              return rateResult;
            },
            onSendFeedback: () async {
              sends?.add(1);
              return sendResult;
            },
          ),
        );

    testWidgets('seleciona e desfaz o polegar para cima', (tester) async {
      final received = <bool?>[];
      await pumpRow(tester, rateResult: true, sendResult: true, received: received);

      expect(findSvg('assets/ic_thumbs_up.svg'), findsOneWidget);
      expect(findSvg('assets/ic_thumbs_down.svg'), findsOneWidget);
      expect(findSvg('assets/divider.svg'), findsOneWidget);

      await tester.tap(findSvg('assets/ic_thumbs_up.svg'));
      await tester.pumpAndSettle();
      expect(findSvg('assets/ic_thumbs_up_selected.svg'), findsOneWidget);
      expect(findSvg('assets/ic_thumbs_down.svg'), findsNothing);

      await tester.tap(findSvg('assets/ic_thumbs_up_selected.svg'));
      await tester.pumpAndSettle();
      expect(received, [true, null]);
      expect(findSvg('assets/ic_thumbs_up.svg'), findsOneWidget);
    });

    testWidgets('mostra o progresso enquanto a avaliação está em andamento',
        (tester) async {
      final completer = Completer<bool>();
      await pumpApp(
        tester,
        FeedbackRow(
          onFeedbackSelected: (_) => completer.future,
          onSendFeedback: () async => true,
        ),
      );

      await tester.tap(findSvg('assets/ic_thumbs_up.svg'));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(findSvg('assets/ic_thumbs_up.svg'), findsNothing);

      completer.complete(true);
      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(findSvg('assets/ic_thumbs_up_selected.svg'), findsOneWidget);
    });

    testWidgets('falha ao avaliar mantém sem seleção', (tester) async {
      await pumpRow(tester, rateResult: false, sendResult: true);

      await tester.tap(findSvg('assets/ic_thumbs_down.svg'));
      await tester.pumpAndSettle();

      expect(findSvg('assets/ic_thumbs_down.svg'), findsOneWidget);
      expect(findSvg('assets/ic_thumbs_down_selected.svg'), findsNothing);
    });

    testWidgets('polegar para baixo permite enviar justificativa',
        (tester) async {
      final received = <bool?>[];
      final sends = <int>[];
      await pumpRow(tester,
          rateResult: true, sendResult: false, received: received, sends: sends);

      await tester.tap(findSvg('assets/ic_thumbs_down.svg'));
      await tester.pumpAndSettle();
      expect(findSvg('assets/ic_thumbs_down_selected.svg'), findsOneWidget);
      expect(findSvg('assets/send_feedback_button.svg'), findsOneWidget);

      // Envio que falha mantém o botão ativo.
      await tester.tap(findSvg('assets/send_feedback_button.svg'));
      await tester.pumpAndSettle();
      expect(sends, hasLength(1));
      final sendIcon = find.ancestor(
        of: findSvg('assets/send_feedback_button.svg'),
        matching: find.byType(IconButton),
      );
      expect(tester.widget<IconButton>(sendIcon).onPressed, isNotNull);

      // Desfaz o polegar para baixo.
      await tester.tap(findSvg('assets/ic_thumbs_down_selected.svg'));
      await tester.pumpAndSettle();
      expect(received, [false, null]);
      expect(findSvg('assets/ic_thumbs_up.svg'), findsOneWidget);
    });

    testWidgets('justificativa enviada trava os botões', (tester) async {
      await pumpRow(tester, rateResult: true, sendResult: true);

      await tester.tap(findSvg('assets/ic_thumbs_down.svg'));
      await tester.pumpAndSettle();
      await tester.tap(findSvg('assets/send_feedback_button.svg'));
      await tester.pumpAndSettle();

      expect(findSvg('assets/ic_thumbs_down_selected.svg'), findsOneWidget);
      // O envio fica desabilitado e o polegar não faz mais nada.
      final sendIcon = find.ancestor(
        of: findSvg('assets/send_feedback_button.svg'),
        matching: find.byType(IconButton),
      );
      expect(tester.widget<IconButton>(sendIcon).onPressed, isNull);
      await tester.tap(findSvg('assets/ic_thumbs_down_selected.svg'));
      await tester.pumpAndSettle();
      expect(findSvg('assets/ic_thumbs_down_selected.svg'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });

  group('FinalEvaluationDialog', () {
    testWidgets('habilita o envio só com polegar e estrela', (tester) async {
      final controller = TextEditingController();
      final ratings = <int>[];
      final resolved = <bool>[];
      var confirms = 0;
      var cancels = 0;
      await pumpApp(
        tester,
        FinalEvaluationDialog(
          textController: controller,
          onRatingSelected: ratings.add,
          onRequestResolvedSelected: resolved.add,
          onConfirm: () async {
            confirms++;
            await Future<void>.delayed(const Duration(milliseconds: 50));
          },
          onCancel: () => cancels++,
        ),
        surface: const Size(400, 900),
      );

      final sendButton = find.ancestor(
        of: find.text('Enviar avaliação e sair'),
        matching: find.byType(ElevatedButton),
      );
      expect(tester.widget<ElevatedButton>(sendButton).onPressed, isNull);
      expect(find.text('Sua solicitação foi resolvida?'), findsOneWidget);
      expect(find.text('0/200'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.thumb_down_outlined));
      await tester.pump();
      expect(find.byIcon(Icons.thumb_down), findsOneWidget);
      await tester.tap(find.byIcon(Icons.thumb_up_outlined));
      await tester.pump();
      expect(find.byIcon(Icons.thumb_up), findsOneWidget);
      expect(find.byIcon(Icons.thumb_down_outlined), findsOneWidget);
      expect(resolved, [false, true]);
      expect(tester.widget<ElevatedButton>(sendButton).onPressed, isNull);

      await tester.tap(find.byIcon(Icons.star).at(2));
      await tester.pump();
      expect(ratings, [3]);
      final stars = tester.widgetList<Icon>(find.byIcon(Icons.star)).toList();
      expect(stars.take(3).every((i) => i.color == Colors.amber), isTrue);
      expect(stars.skip(3).every((i) => i.color == Colors.grey), isTrue);
      expect(tester.widget<ElevatedButton>(sendButton).onPressed, isNotNull);

      await tester.enterText(find.byType(TextFormField), 'comentário');
      await tester.pump();
      expect(controller.text, 'comentário');
      expect(find.text('10/200'), findsOneWidget);

      await tester.tap(sendButton);
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();
      expect(confirms, 1);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      await expectLater(
        findGoldenSurface(),
        matchesGoldenFile('goldens/final_evaluation_dialog.png'),
      );

      await tester.tap(find.text('Voltar para a conversa'));
      await tester.pump();
      expect(cancels, 1);
      expect(controller.text, '');
      expect(find.byIcon(Icons.thumb_up), findsNothing);
      expect(tester.widget<ElevatedButton>(sendButton).onPressed, isNull);
    });
  });

  testWidgets('NegativeFeedbackDialog habilita o envio com texto',
      (tester) async {
    final controller = TextEditingController();
    var confirms = 0;
    var cancels = 0;
    await pumpApp(
      tester,
      NegativeFeedbackDialog(
        textController: controller,
        onConfirm: () async {
          confirms++;
          await Future<void>.delayed(const Duration(milliseconds: 50));
        },
        onCancel: () => cancels++,
      ),
    );

    expect(find.text('Porque esta resposta foi insatisfatória?'), findsOneWidget);
    expect(find.text('0/200'), findsOneWidget);
    await tester.tap(find.text('Enviar'));
    await tester.pump();
    expect(confirms, 0);

    await tester.enterText(find.byType(TextFormField), 'faltou detalhe');
    await tester.pump();
    expect(find.text('14/200'), findsOneWidget);
    await tester.tap(find.text('Enviar'));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
    expect(confirms, 1);

    await tester.tap(find.text('Voltar'));
    expect(cancels, 1);
  });
}
