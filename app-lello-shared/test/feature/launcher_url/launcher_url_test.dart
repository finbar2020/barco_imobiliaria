import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/launcher_url/launcher_url.dart';

import '../../helpers/fake_url_launcher.dart';

void main() {
  late FakeUrlLauncherPlatform launcher;
  late List<MethodCall> nativeCalls;
  late bool nativeFails;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() {
    launcher = installFakeUrlLauncher();
    nativeCalls = [];
    nativeFails = false;
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(UrlLauncherNative.platform, (call) async {
      nativeCalls.add(call);
      if (nativeFails) throw PlatformException(code: 'sem-plugin');
      return null;
    });
    addTearDown(() =>
        messenger.setMockMethodCallHandler(UrlLauncherNative.platform, null));
  });

  /// Sem o `PackageInfo` mockado o `AppInfo.init()` falha e o erro é só
  /// registrado; a abertura segue normalmente. Precisa rodar antes do mock.
  test('falha ao ler o pacote não impede abrir a URL', () async {
    final opened = await UrlLauncherNative.openUrl('https://lello.com.br');

    expect(opened, isTrue);
    expect(launcher.launched, ['https://lello.com.br']);
  });

  group('com o pacote conhecido', () {
    setUp(() {
      PackageInfo.setMockInitialValues(
        appName: 'Lello',
        packageName: 'br.com.lello.morar',
        version: '1.20.3',
        buildNumber: '1',
        buildSignature: '',
      );
    });

    test('abre no navegador externo pelo url_launcher', () async {
      final opened = await UrlLauncherNative.openUrl('https://lello.com.br/a');

      expect(opened, isTrue);
      expect(launcher.launched, ['https://lello.com.br/a']);
      expect(launcher.headers.single, isEmpty);
      expect(nativeCalls, isEmpty);
    });

    test('com cabeçalhos envia a configuração da webview', () async {
      final opened = await UrlLauncherNative.openUrl('https://lello.com.br/b',
          headers: {'Authorization': 'Bearer x'});

      expect(opened, isTrue);
      expect(launcher.headers.single, {'Authorization': 'Bearer x'});
    });

    test('cabeçalhos vazios usam a abertura simples', () async {
      await UrlLauncherNative.openUrl('https://lello.com.br/c', headers: {});
      expect(launcher.headers.single, isEmpty);
    });

    test('quando o url_launcher falha usa o canal nativo', () async {
      launcher.result = false;

      final opened = await UrlLauncherNative.openUrl('https://lello.com.br/d');

      expect(opened, isTrue);
      expect(nativeCalls.single.method, 'openUrl');
      expect(nativeCalls.single.arguments, {'url': 'https://lello.com.br/d'});
    });

    test('falha com cabeçalhos também cai no nativo', () async {
      launcher.result = false;

      final opened = await UrlLauncherNative.openUrl('https://lello.com.br/e',
          headers: {'a': 'b'});

      expect(opened, isTrue);
      expect(nativeCalls, hasLength(1));
    });

    test('canal nativo indisponível devolve falso', () async {
      launcher.result = false;
      nativeFails = true;

      expect(await UrlLauncherNative.openUrl('https://lello.com.br/f'), isFalse);
    });

    test('sem fallback nativo devolve falso direto', () async {
      launcher.result = false;

      final opened = await UrlLauncherNative.openUrl('https://lello.com.br/g',
          useNativeFallback: false);

      expect(opened, isFalse);
      expect(nativeCalls, isEmpty);
    });
  });
}
