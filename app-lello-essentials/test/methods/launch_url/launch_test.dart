import 'package:essentials/methods/launch_url/launch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../helpers/fake_url_launcher.dart';
import '../../helpers/pump_app.dart';

void main() {
  late FakeUrlLauncherPlatform launcher;
  late BuildContext context;

  Future<void> prepara(WidgetTester tester) async {
    launcher = installFakeUrlLauncher();
    await pumpApp(tester, const Text('home'));
    context = tester.element(find.text('home'));
  }

  /// Deixa o Flushbar aparecer e depois some (timer de 3 s).
  Future<void> esperaFlushbar(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
  }

  /// Termina a animação de entrada, dispara o timer de 3 s e espera sumir.
  Future<void> limpa(WidgetTester tester) async {
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  }

  group('urlString', () {
    testWidgets('abre a URL com os headers informados', (tester) async {
      await prepara(tester);
      final ok = await Launch.urlString(context, 'https://lello.com.br',
          headers: {'a': 'b'}, mode: LaunchMode.externalApplication);
      expect(ok, isTrue);
      expect(launcher.launched, ['https://lello.com.br']);
      expect(launcher.headers.single, {'a': 'b'});
    });

    testWidgets('usa a WebViewConfiguration informada', (tester) async {
      await prepara(tester);
      await Launch.urlString(context, 'https://x',
          webViewConfiguration: const WebViewConfiguration(headers: {'h': '1'}));
      expect(launcher.headers.single, {'h': '1'});
    });

    testWidgets('URL nula mostra o Flushbar padrão', (tester) async {
      await prepara(tester);
      final futuro = Launch.urlString(context, null);
      await esperaFlushbar(tester);
      expect(find.text('unable_to_load'), findsOneWidget);
      expect(await futuro, isFalse);
      expect(launcher.launched, isEmpty);
      await limpa(tester);
    });

    testWidgets('mensagem customizada e sem Flushbar', (tester) async {
      await prepara(tester);
      launcher.result = false;
      final futuro = Launch.urlString(context, 'x', cantLaunchMessage: 'nao deu');
      await esperaFlushbar(tester);
      expect(find.text('nao deu'), findsOneWidget);
      expect(await futuro, isFalse);
      await limpa(tester);

      expect(
          await Launch.urlString(context, 'x', showFlushbarOnError: false), isFalse);
      await tester.pump();
      expect(find.text('unable_to_load'), findsNothing);
    });
  });

  group('urlUri', () {
    testWidgets('abre a Uri', (tester) async {
      await prepara(tester);
      expect(await Launch.urlUri(context, Uri.parse('https://lello.com.br/a')),
          isTrue);
      expect(launcher.launched, ['https://lello.com.br/a']);
      expect(launcher.headers.single, isEmpty);
    });

    testWidgets('Uri nula ou não suportada mostra Flushbar', (tester) async {
      await prepara(tester);
      final futuro = Launch.urlUri(context, null, cantLaunchMessage: 'msg');
      await esperaFlushbar(tester);
      expect(find.text('msg'), findsOneWidget);
      expect(await futuro, isFalse);
      await limpa(tester);

      launcher.result = false;
      expect(
          await Launch.urlUri(context, Uri.parse('https://x'),
              showFlushbarOnError: false,
              webViewConfiguration: const WebViewConfiguration()),
          isFalse);
    });
  });

  group('whatsApp', () {
    testWidgets('abre o wa.me em app externo', (tester) async {
      await prepara(tester);
      expect(await Launch.whatsApp(context, '5511999998888', message: 'oi'),
          isTrue);
      expect(launcher.launched.single, startsWith('https://wa.me/5511999998888/'));
      expect(launcher.launched.single, contains('text=oi'));
    });

    testWidgets('sem WhatsApp mostra cant_open_whatsapp', (tester) async {
      await prepara(tester);
      launcher.result = false;
      final futuro = Launch.whatsApp(context, '55');
      await esperaFlushbar(tester);
      expect(find.text('cant_open_whatsapp'), findsOneWidget);
      expect(await futuro, isFalse);
      await limpa(tester);
      expect(
          await Launch.whatsApp(context, '55', showFlushbarOnError: false), isFalse);
    });
  });

  group('sms e tel', () {
    testWidgets('abrem os esquemas certos', (tester) async {
      await prepara(tester);
      expect(await Launch.sms(context, '11999998888'), isTrue);
      expect(await Launch.tel(context, '11999998888'), isTrue);
      expect(launcher.launched, ['sms://11999998888', 'tel://11999998888']);
    });

    testWidgets('falham com Flushbar padrão', (tester) async {
      await prepara(tester);
      launcher.result = false;
      final sms = Launch.sms(context, '1');
      await esperaFlushbar(tester);
      expect(find.text('unable_to_load'), findsOneWidget);
      expect(await sms, isFalse);
      await limpa(tester);
      final tel = Launch.tel(context, '1');
      await esperaFlushbar(tester);
      expect(await tel, isFalse);
      expect(find.text('unable_to_load'), findsOneWidget);
      await limpa(tester);
    });
  });
}
