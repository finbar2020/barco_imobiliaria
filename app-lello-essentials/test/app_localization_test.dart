import 'dart:convert';

import 'package:essentials/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

const _ptBr = {
  'hello': 'Olá',
  'greet': 'Olá, {0}! Você tem {1} itens.',
  'n': 1
};
const _enUs = {'hello': 'Hello', 'greet': 'Hi, {0}! You have {1} items.'};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final requested = <String>[];

  /// Simula o `rootBundle` respondendo `lang/pt_BR.json` e `lang/en_US.json`.
  setUp(() {
    requested.clear();
    rootBundle.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', (ByteData? message) async {
      final key = utf8.decode(message!.buffer.asUint8List());
      requested.add(key);
      final content = switch (key) {
        'lang/pt_BR.json' => json.encode(_ptBr),
        'lang/en_US.json' => json.encode(_enUs),
        _ => null,
      };
      if (content == null) return null;
      return ByteData.sublistView(Uint8List.fromList(utf8.encode(content)));
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', null);
    rootBundle.clear();
  });

  group('AppLocalization.load', () {
    test('carrega lang/pt_BR.json e traduz chaves', () async {
      final loc = AppLocalization(const Locale('pt', 'BR'));
      await loc.load();
      expect(requested, ['lang/pt_BR.json']);
      expect(loc.locale, const Locale('pt', 'BR'));
      expect(loc.translate('hello'), 'Olá');
      expect(loc.translate('inexistente'), isNull);
      // Valores não-string viram string.
      expect(loc.translate('n'), '1');
    });

    test('carrega lang/en_US.json', () async {
      final loc = AppLocalization(const Locale('en', 'US'));
      await loc.load();
      expect(requested, ['lang/en_US.json']);
      expect(loc.translate('hello'), 'Hello');
    });

    test('en_BR cai para en_US', () async {
      final loc = AppLocalization(const Locale('en', 'BR'));
      await loc.load();
      expect(requested, ['lang/en_US.json']);
      expect(loc.translate('hello'), 'Hello');
    });

    test('arquivo ausente lança erro', () async {
      final loc = AppLocalization(const Locale('es', 'ES'));
      await expectLater(loc.load(), throwsA(isA<FlutterError>()));
      expect(requested, ['lang/es_ES.json']);
    });

    test('translate antes de load devolve null', () {
      /// Corrigido: `_localizedStrings` começa vazio (não é mais `late`), então
      /// `translate` antes de `load()` devolve null em vez de lançar
      /// LateInitializationError.
      final loc = AppLocalization(const Locale('pt', 'BR'));
      expect(loc.translate('hello'), isNull);
    });
  });

  group('delegate', () {
    test('suporta pt e en e não recarrega', () {
      const delegate = AppLocalization.delegate;
      expect(delegate.isSupported(const Locale('pt', 'BR')), isTrue);
      expect(delegate.isSupported(const Locale('en', 'US')), isTrue);
      expect(delegate.isSupported(const Locale('en')), isTrue);
      expect(delegate.isSupported(const Locale('es', 'ES')), isFalse);
      expect(delegate.shouldReload(delegate), isFalse);
      expect(delegate.type, AppLocalization);
    });

    test('load devolve a localização carregada', () async {
      final loc = await AppLocalization.delegate.load(const Locale('pt', 'BR'));
      expect(loc.translate('hello'), 'Olá');
    });
  });

  group('getString / getStringWithParams', () {
    Future<BuildContext> pumpComDelegate(WidgetTester tester,
        {Locale locale = const Locale('pt', 'BR')}) async {
      late BuildContext ctx;
      await tester.pumpWidget(MaterialApp(
        locale: locale,
        supportedLocales: const [Locale('pt', 'BR'), Locale('en', 'US')],
        localizationsDelegates: const [
          AppLocalization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Builder(builder: (context) {
          ctx = context;
          return const SizedBox();
        }),
      ));
      await tester.pumpAndSettle();
      return ctx;
    }

    testWidgets('getString traduz pela localização em contexto',
        (tester) async {
      final ctx = await pumpComDelegate(tester);
      expect(AppLocalization.of(ctx).locale, const Locale('pt', 'BR'));
      expect(getString(ctx, 'hello'), 'Olá');
      expect(getString(ctx, 'nao_existe'), '');
      expect(getString(ctx, 'nao_existe', defaultText: 'padrão'), 'padrão');
    });

    testWidgets('getString em inglês', (tester) async {
      final ctx =
          await pumpComDelegate(tester, locale: const Locale('en', 'US'));
      expect(getString(ctx, 'hello'), 'Hello');
      expect(requested, contains('lang/en_US.json'));
    });

    test('getString sem contexto devolve o texto padrão', () {
      expect(getString(null, 'hello'), '');
      expect(getString(null, 'hello', defaultText: 'x'), 'x');
    });

    testWidgets('getStringWithParams substitui {i} na ordem', (tester) async {
      final ctx = await pumpComDelegate(tester);
      expect(getStringWithParams(ctx, 'greet', ['Ana', '3']),
          'Olá, Ana! Você tem 3 itens.');
      expect(getStringWithParams(ctx, 'greet', ['Ana']),
          'Olá, Ana! Você tem {1} itens.');
      expect(getStringWithParams(ctx, 'greet', []), _ptBr['greet']);
      expect(getStringWithParams(ctx, 'hello', ['ignorado']), 'Olá');
    });

    test('getStringWithParams sem contexto devolve vazio', () {
      expect(getStringWithParams(null, 'greet', ['a', 'b']), '');
    });

    testWidgets('sem delegate getString devolve o texto padrão',
        (tester) async {
      /// Corrigido: `getString` usa `AppLocalization.maybeOf` (nulo quando o
      /// delegate não está registrado) e devolve `defaultText`. A assinatura
      /// não-nula de `of` foi mantida por compatibilidade (continua a
      /// estourar TypeError sem delegate).
      late BuildContext ctx;
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (context) {
          ctx = context;
          return const SizedBox();
        }),
      ));
      expect(AppLocalization.maybeOf(ctx), isNull);
      expect(getString(ctx, 'hello'), '');
      expect(getString(ctx, 'hello', defaultText: 'padrão'), 'padrão');
      expect(getStringWithParams(ctx, 'greet', ['a']), '');
      expect(() => AppLocalization.of(ctx), throwsA(isA<TypeError>()));
    });

    testWidgets('maybeOf devolve a localização quando há delegate',
        (tester) async {
      final ctx = await pumpComDelegate(tester);
      expect(AppLocalization.maybeOf(ctx)?.locale, const Locale('pt', 'BR'));
    });
  });
}
