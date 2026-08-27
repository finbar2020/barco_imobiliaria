import 'package:another_flushbar/flushbar.dart';
import 'package:essentials/ui/widget/dialogs/redirection_whatsapp_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_url_launcher.dart';
import '../../../helpers/pump_app.dart';

void main() {
  Future<RecordingNavigatorObserver> pumpAbridor(
    WidgetTester tester, {
    required dynamic text,
    dynamic message = 'msg_whats',
    bool isGeneric = false,
    String companyName = '',
    Map<String, String> locOverrides = const {},
  }) async {
    final observer = RecordingNavigatorObserver();
    await pumpApp(
      tester,
      Builder(
        builder: (context) => TextButton(
          onPressed: () => WhatsAppDialog.redirect(
            context: context,
            phoneNumber: '5511999999999',
            title: 'titulo_whats',
            text: text,
            isGeneric: isGeneric,
            companyName: companyName,
            message: message,
          ),
          child: const Text('abrir'),
        ),
      ),
      navigatorObserver: observer,
      // Textos curtos para os botões: com as chaves em maiúsculas a Row
      // estoura a largura do diálogo.
      locOverrides: {
        'later': 'Depois',
        'registration_lello_warning_no_data_btn': 'WhatsApp',
        ...locOverrides,
      },
    );
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
    return observer;
  }

  testWidgets('redirect abre o diálogo com título, texto e ações',
      (tester) async {
    await pumpAbridor(tester, text: 'texto_whats');

    expect(find.byType(RedirectionWhatsappDialog), findsOneWidget);
    expect(find.text('titulo_whats!'), findsOneWidget);
    expect(find.text('texto_whats'), findsOneWidget);
    expect(find.text('DEPOIS'), findsOneWidget, reason: 'em maiúsculas');
    expect(find.text('WHATSAPP'), findsOneWidget);
    expect(find.byType(SvgPicture), findsOneWidget);
  });

  testWidgets('"depois" fecha o diálogo sem abrir o WhatsApp', (tester) async {
    final launcher = installFakeUrlLauncher();
    final observer = await pumpAbridor(tester, text: 'texto_whats');

    await tester.tap(find.text('DEPOIS'));
    await tester.pumpAndSettle();

    expect(find.byType(RedirectionWhatsappDialog), findsNothing);
    expect(observer.popped, hasLength(1));
    expect(launcher.launched, isEmpty);
  });

  testWidgets('botão do WhatsApp abre wa.me com telefone e mensagem e fecha',
      (tester) async {
    final launcher = installFakeUrlLauncher();
    await pumpAbridor(
      tester,
      text: 'texto_whats',
      locOverrides: const {'msg_whats': 'Olá Lello'},
    );

    await tester.tap(find.text('WHATSAPP'));
    await tester.pumpAndSettle();

    expect(launcher.launched, hasLength(1));
    final uri = Uri.parse(launcher.launched.single);
    expect(uri.host, 'wa.me');
    expect(uri.path, '/5511999999999/');
    expect(uri.queryParameters['text'], 'Olá Lello');
    expect(find.byType(RedirectionWhatsappDialog), findsNothing);
  });

  testWidgets('sem WhatsApp disponível fecha o diálogo e mostra o Flushbar de erro',
      (tester) async {
    final launcher = installFakeUrlLauncher()..result = false;
    await pumpAbridor(tester, text: 'texto_whats');

    await tester.tap(find.text('WHATSAPP'));
    // O `canLaunchUrl` resolve antes de a animação de pop terminar, então o
    // context do diálogo ainda está montado quando o Flushbar é exibido.
    await tester.pumpAndSettle();

    expect(launcher.launched, isEmpty);
    expect(find.byType(RedirectionWhatsappDialog), findsNothing);
    expect(find.byType(Flushbar), findsOneWidget);
    expect(find.text('cant_open_whatsapp'), findsOneWidget);
    expect(tester.takeException(), isNull);

    // Consome a duração do Flushbar.
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
    expect(find.byType(Flushbar), findsNothing);
  });

  /// Corrigido: `whatsAppMessage` nulo usa a chave vazia, então o diálogo
  /// monta normalmente e o WhatsApp abre com mensagem vazia.
  testWidgets('sem message o diálogo abre e o WhatsApp abre sem texto',
      (tester) async {
    final launcher = installFakeUrlLauncher();
    await pumpAbridor(tester, text: 'texto_whats', message: null);

    expect(tester.takeException(), isNull);
    expect(find.text('titulo_whats!'), findsOneWidget);

    await tester.tap(find.text('WHATSAPP'));
    await tester.pumpAndSettle();

    expect(launcher.launched, hasLength(1));
    final uri = Uri.parse(launcher.launched.single);
    expect(uri.host, 'wa.me');
    // Corrigido também em `Urls.whatsApp`: sem mensagem a URL não leva `?text`.
    expect(uri.queryParameters.containsKey('text'), isFalse);
    expect(find.byType(RedirectionWhatsappDialog), findsNothing);
  });

  group('changeLelloForCompanyName', () {
    const chave = 'talk_to_lello_text_description';
    const traduzido = 'Fale com a Lello pelo WhatsApp';

    testWidgets('genérico com companyName troca "Lello" pela empresa',
        (tester) async {
      await pumpAbridor(
        tester,
        text: chave,
        isGeneric: true,
        companyName: 'Barco',
        locOverrides: const {chave: traduzido},
      );
      expect(find.text('Fale com a Barco pelo WhatsApp'), findsOneWidget);
      expect(find.text(traduzido), findsNothing);
    });

    testWidgets('genérico sem companyName mantém o texto', (tester) async {
      await pumpAbridor(
        tester,
        text: chave,
        isGeneric: true,
        locOverrides: const {chave: traduzido},
      );
      expect(find.text(traduzido), findsOneWidget);
    });

    testWidgets('genérico com tradução vazia devolve vazio', (tester) async {
      await pumpAbridor(
        tester,
        text: chave,
        isGeneric: true,
        companyName: 'Barco',
        locOverrides: const {chave: ''},
      );
      expect(find.text(''), findsOneWidget);
    });

    testWidgets('não genérico não substitui', (tester) async {
      await pumpAbridor(
        tester,
        text: chave,
        isGeneric: false,
        companyName: 'Barco',
        locOverrides: const {chave: traduzido},
      );
      expect(find.text(traduzido), findsOneWidget);
    });

    testWidgets('genérico com outro texto não substitui', (tester) async {
      await pumpAbridor(
        tester,
        text: 'outro_texto',
        isGeneric: true,
        companyName: 'Barco',
        locOverrides: const {'outro_texto': 'Lello outro'},
      );
      expect(find.text('Lello outro'), findsOneWidget);
    });

    test('método é chamável diretamente pelo widget', () {
      const dialog = RedirectionWhatsappDialog(
        phoneNumber: '1',
        title: 't',
        text: chave,
        isGeneric: true,
        companyName: 'Barco',
      );
      expect(dialog.companyName, 'Barco');
      expect(dialog.whatsAppMessage, isNull);
    });
  });

  testWidgets('golden', (tester) async {
    await pumpApp(
      tester,
      const RedirectionWhatsappDialog(
        phoneNumber: '5511999999999',
        title: 'titulo_whats',
        text: 'texto_whats',
        isGeneric: false,
        whatsAppMessage: 'msg',
      ),
      locOverrides: const {
        'titulo_whats': 'Falar com a Lello',
        'texto_whats': 'Você será redirecionado para o WhatsApp.',
        'later': 'Depois',
        'registration_lello_warning_no_data_btn': 'Abrir WhatsApp',
      },
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('../goldens/redirection_whatsapp_dialog.png'),
    );
  });
}
