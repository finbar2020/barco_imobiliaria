import 'dart:io';

import 'package:essentials/stores/store_package_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // O AppInfo é um singleton: a ordem dos testes importa.
  test('getters lançam antes do init', () {
    expect(AppInfo.instance.isInitSuccessfully, isFalse);
    expect(() => AppInfo.instance.device, throwsA(isA<Exception>()));
    expect(() => AppInfo.instance.manufacturer, throwsA(isA<Exception>()));
    expect(() => AppInfo.instance.model, throwsA(isA<Exception>()));
    expect(() => AppInfo.instance.os, throwsA(isA<Exception>()));
    expect(() => AppInfo.instance.packageInfo, throwsA(isA<Exception>()));
  });

  test('init falha quando o PackageInfo não está disponível', () async {
    // Sem mock o canal responde MissingPluginException → Exception própria.
    expect(AppInfo.init(), throwsA(isA<Exception>()));
  });

  test('init carrega o PackageInfo e vira idempotente', () async {
    PackageInfo.setMockInitialValues(
      appName: 'essentials',
      packageName: 'app.lello.essentials',
      version: '1.2.3',
      buildNumber: '4',
      buildSignature: '',
    );
    final info = await AppInfo.init();
    expect(identical(info, AppInfo.instance), isTrue);
    expect(info.isInitSuccessfully, isTrue);
    expect(info.packageInfo.version, '1.2.3');
    expect(info.packageInfo.packageName, 'app.lello.essentials');

    // Segunda chamada devolve a mesma instância sem consultar os plugins.
    expect(identical(await AppInfo.init(), info), isTrue);

    // No host de teste (macOS) os ramos Android/iOS não executam: os dados do
    // dispositivo continuam nulos e os getters seguem lançando.
    if (!Platform.isAndroid && !Platform.isIOS) {
      expect(() => info.device, throwsA(isA<Exception>()));
      expect(() => info.manufacturer, throwsA(isA<Exception>()));
      expect(() => info.model, throwsA(isA<Exception>()));
      expect(() => info.os, throwsA(isA<Exception>()));
    }
  });
}
