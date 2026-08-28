import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:essentials/app_update/app_update_config.dart';
import 'package:essentials/app_update/needs_update_enum.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FontLoader;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/fake_url_launcher.dart';
import '../helpers/firebase_mocks.dart';
import '../helpers/pump_app.dart';

const _chaveData = 'UPDATE_DATE_CHECK';
const _linkLoja = 'https://apps.apple.com/br/app/lello';

bool _fontesCarregadas = false;

/// O `CupertinoAlertDialog` usa as famílias `CupertinoSystemText`/`Display`
/// (fonte do sistema), que não existem no ambiente de teste e virariam
/// blocos (Ahem) nos goldens. Registramos a Roboto do pacote com esses nomes.
Future<void> _carregarFontesCupertino() async {
  if (_fontesCarregadas) return;
  final regular = File('fonts/Roboto-Regular.ttf');
  final bold = File('fonts/Roboto-Bold.ttf');
  if (!regular.existsSync()) return;
  for (final familia in ['CupertinoSystemText', 'CupertinoSystemDisplay']) {
    final loader = FontLoader(familia)
      ..addFont(Future.value(ByteData.sublistView(regular.readAsBytesSync())));
    if (bold.existsSync()) {
      loader.addFont(Future.value(ByteData.sublistView(bold.readAsBytesSync())));
    }
    await loader.load();
  }
  _fontesCarregadas = true;
}

/// Os testes rodam no host macOS, onde `Platform.isAndroid` é falso: todos os
/// ramos "iOS" (consulta ao iTunes, `CupertinoAlertDialog`, ids da App Store)
/// são exercitados; os ramos Android (`play.google.com`, `AlertDialog`,
/// `TextButton`, ids do Play) são inalcançáveis neste ambiente.
void main() {
  late FakeRemoteConfigPlatform remoteConfig;

  void versaoLocal(String versao) => PackageInfo.setMockInitialValues(
        appName: 'Lello',
        packageName: 'app.lello.morar',
        version: versao,
        buildNumber: '1',
        buildSignature: '',
      );

  void loja({String? storeVersion, String? minVersion, String? bruto}) {
    remoteConfig.values = {
      if (bruto != null) 'store_version': bruto,
      if (storeVersion != null)
        'store_version': jsonEncode({'storeVersion': storeVersion}),
      if (minVersion != null)
        'force_update': jsonEncode({'minVersion': minVersion}),
    };
  }

  setUp(() async {
    remoteConfig = await setUpFakeFirebase();
    SharedPreferences.setMockInitialValues({});
    versaoLocal('1.2.0');
  });

  Future<NeedsUpdate?> checar(
          [AppOriginEnum origem = AppOriginEnum.owner]) async =>
      (await AppUpdateConfig.checkNeedsUpdate(appOriginEnum: origem))
          ?.needsUpdate;

  Future<String?> dataGuardada() async =>
      (await SharedPreferences.getInstance()).getString(_chaveData);

  group('checkNeedsUpdate', () {
    test('configura, busca e ativa o remote config', () async {
      loja(storeVersion: '1.2.0');
      await checar();
      expect(remoteConfig.fetches, 1);
      expect(remoteConfig.configSettings?.fetchTimeout,
          const Duration(seconds: 30));
      expect(remoteConfig.configSettings?.minimumFetchInterval,
          const Duration(minutes: 30));
    });

    test('sem store_version devolve nulo', () async {
      loja();
      expect(await checar(), isNull);
    });

    test('store_version com valor vazio devolve nulo', () async {
      loja(storeVersion: '');
      expect(await checar(), isNull);
    });

    test('store_version sem a chave storeVersion devolve nulo', () async {
      loja(bruto: jsonEncode({'outra': '9.9.9'}));
      expect(await checar(), isNull);
    });

    test('versão local igual à da loja não precisa atualizar', () async {
      loja(storeVersion: '1.2.0', minVersion: '1.0.0');
      expect(await checar(), isNull);
    });

    test('versão local maior que a da loja não precisa atualizar', () async {
      versaoLocal('2.0.0');
      loja(storeVersion: '1.9.9', minVersion: '1.0.0');
      expect(await checar(), isNull);
    });

    test('versão local vazia não precisa atualizar', () async {
      versaoLocal('');
      loja(storeVersion: '1.9.9', minVersion: '1.0.0');
      expect(await checar(), isNull);
    });

    test('versão nova na loja sem force_update devolve nulo', () async {
      loja(storeVersion: '1.3.0');
      expect(await checar(), isNull);
    });

    test('force_update com minVersion vazia devolve nulo', () async {
      loja(storeVersion: '1.3.0', minVersion: '');
      expect(await checar(), isNull);
    });

    test('versão mínima acima da loja obriga a atualizar', () async {
      loja(storeVersion: '1.3.0', minVersion: '1.4.0');
      expect(await checar(AppOriginEnum.manager), NeedsUpdate.mandatory);
    });

    test('primeira checagem grava data de 3 dias atrás e sugere atualizar',
        () async {
      loja(storeVersion: '1.3.0', minVersion: '1.0.0');
      expect(await checar(), NeedsUpdate.minor);

      final data = DateTime.parse((await dataGuardada())!);
      expect(DateTime.now().difference(data).inDays, 3);
    });

    test('checagem repetida no mesmo dia não incomoda de novo', () async {
      SharedPreferences.setMockInitialValues({
        _chaveData: DateTime.now().toIso8601String(),
      });
      loja(storeVersion: '1.3.0', minVersion: '1.0.0');
      expect(await checar(), NeedsUpdate.none);
    });

    test('data com mais de um dia volta a sugerir', () async {
      SharedPreferences.setMockInitialValues({
        _chaveData: DateTime.now()
            .subtract(const Duration(days: 2))
            .toIso8601String(),
      });
      loja(storeVersion: '1.3.0', minVersion: '1.0.0');
      expect(await checar(), NeedsUpdate.minor);
    });

    test('data guardada em tipo errado é descartada e regravada', () async {
      SharedPreferences.setMockInitialValues({_chaveData: 123});
      loja(storeVersion: '1.3.0', minVersion: '1.0.0');
      expect(await checar(), NeedsUpdate.minor);
      expect(await dataGuardada(), isA<String>());
    });

    test('data vazia é regravada', () async {
      SharedPreferences.setMockInitialValues({_chaveData: ''});
      loja(storeVersion: '1.3.0', minVersion: '1.0.0');
      expect(await checar(), NeedsUpdate.minor);
      expect(await dataGuardada(), isNotEmpty);
    });

    test('data ilegível conta como vencida', () async {
      SharedPreferences.setMockInitialValues({_chaveData: 'ontem'});
      loja(storeVersion: '1.3.0', minVersion: '1.0.0');
      expect(await checar(), NeedsUpdate.minor);
    });

    test('compara segmento a segmento (1.2.1 < 1.3)', () async {
      versaoLocal('1.2.1');
      loja(storeVersion: '1.3', minVersion: '1.0.0');
      expect(await checar(), NeedsUpdate.minor);
    });

    /// Corrigido: `_compareVersion` trata segmentos ausentes como 0; quando a
    /// versão da loja tem um segmento a mais (1.2 → 1.2.1) a atualização é
    /// detectada, e 1.2 == 1.2.0 continua sem atualização.
    test('versão com segmento extra na loja é detectada', () async {
      versaoLocal('1.2');
      loja(storeVersion: '1.2.1', minVersion: '1.0.0');
      expect(await checar(), NeedsUpdate.minor);
    });

    test('segmento extra igual a zero não conta como atualização', () async {
      versaoLocal('1.2');
      loja(storeVersion: '1.2.0', minVersion: '1.0.0');
      expect(await checar(), isNull);

      versaoLocal('1.2.0');
      loja(storeVersion: '1.2', minVersion: '1.0.0');
      expect(await checar(), isNull);
    });

    test('versão da loja inválida cai no catch e limpa a data guardada',
        () async {
      SharedPreferences.setMockInitialValues({
        _chaveData: DateTime.now().toIso8601String(),
      });
      loja(storeVersion: '1.x.0', minVersion: '1.0.0');
      expect(await checar(), isNull);
      // A limpeza acontece num `then` não aguardado.
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(await dataGuardada(), isNull);
    });
  });

  group('getAppStoreLink (host macOS = ramo iOS)', () {
    Future<T> comLoja<T>(
      Future<T> Function() corpo, {
      List<Map<String, String>> resultados = const [
        {'trackViewUrl': _linkLoja}
      ],
      List<Uri>? requisicoes,
    }) =>
        http.runWithClient(
          corpo,
          () => MockClient((req) async {
            requisicoes?.add(req.url);
            return http.Response(jsonEncode({'results': resultados}), 200);
          }),
        );

    test('consulta o iTunes com bundleId e país e devolve o link', () async {
      final requisicoes = <Uri>[];
      final link = await comLoja(
        () => AppUpdateConfig.getAppStoreLink('app.lello.lellomorar'),
        requisicoes: requisicoes,
      );
      expect(link, _linkLoja);
      final uri = requisicoes.single;
      expect(uri.host, 'itunes.apple.com');
      expect(uri.path, '/lookup');
      expect(uri.queryParameters,
          {'bundleId': 'app.lello.lellomorar', 'country': 'br'});
    });

    test('sem resultados devolve nulo', () async {
      final link = await comLoja(
        () => AppUpdateConfig.getAppStoreLink('inexistente'),
        resultados: const [],
      );
      expect(link, isNull);
    });

    test('resposta inválida propaga o erro', () async {
      await http.runWithClient(
        () async {
          await expectLater(
            AppUpdateConfig.getAppStoreLink('x'),
            throwsA(isA<FormatException>()),
          );
        },
        () => MockClient((_) async => http.Response('não é json', 500)),
      );
    });
  });

  test('getLocalVersion devolve a versão do PackageInfo', () async {
    versaoLocal('4.5.6');
    expect(await AppUpdateConfig.getLocalVersion(), '4.5.6');
  });

  group('diálogos', () {
    late FakeUrlLauncherPlatform launcher;

    setUp(() {
      launcher = installFakeUrlLauncher();
    });

    Future<BuildContext> host(WidgetTester tester) async {
      late BuildContext contexto;
      await tester.runAsync(_carregarFontesCupertino);
      await pumpApp(
        tester,
        Builder(builder: (c) {
          contexto = c;
          return const Text('host');
        }),
      );
      return contexto;
    }

    Future<void> comLoja(
      Future<void> Function() corpo, {
      List<Map<String, String>> resultados = const [
        {'trackViewUrl': _linkLoja}
      ],
      List<Uri>? requisicoes,
      bool falhar = false,
    }) =>
        http.runWithClient(
          corpo,
          () => MockClient((req) async {
            requisicoes?.add(req.url);
            if (falhar) throw const SocketException('sem rede');
            return http.Response(jsonEncode({'results': resultados}), 200);
          }),
        );

    final dialogo = find.byType(CupertinoAlertDialog);

    group('showDialogUpDate', () {
      testWidgets('atualização opcional: textos, dois botões, data e dispensa',
          (tester) async {
        final contexto = await host(tester);
        var continuou = 0;
        var dispensou = 0;
        final requisicoes = <Uri>[];

        await comLoja(() async {
          unawaited(AppUpdateConfig.showDialogUpDate(
            context: contexto,
            appOriginEnum: AppOriginEnum.owner,
            criticalUpdateRequired: false,
            continueSplashAction: () => continuou++,
            dismissAction: () => dispensou++,
          ));
          await tester.pumpAndSettle();
        }, requisicoes: requisicoes);

        expect(requisicoes.single.queryParameters['bundleId'],
            'app.lello.lellomorar');
        expect(dialogo, findsOneWidget);
        expect(find.text('new_version_app_title'), findsOneWidget);
        expect(find.text('new_version_app_dialog_text'), findsOneWidget);
        expect(find.text('yes_update_app'), findsOneWidget);
        expect(find.text('no_update_app'), findsOneWidget);
        await expectLater(
          dialogo,
          matchesGoldenFile('goldens/update_dialog_opcional.png'),
        );

        // A data da checagem é gravada ao mostrar o diálogo.
        final data = DateTime.parse((await dataGuardada())!);
        expect(DateTime.now().difference(data).inMinutes, 0);

        await tester.tap(find.text('no_update_app'));
        await tester.pumpAndSettle();

        expect(dialogo, findsNothing);
        expect(dispensou, 1);
        expect(continuou, 0);
        expect(fakeAnalytics.eventNames, ['morar_atualizacao_adiada_read']);
        expect(fakeAnalytics.events['morar_atualizacao_adiada_read'],
            {'tipo': 'read'});
      });

      testWidgets('dispensa sem dismissAction só fecha e loga o evento',
          (tester) async {
        final contexto = await host(tester);
        await comLoja(() async {
          unawaited(AppUpdateConfig.showDialogUpDate(
            context: contexto,
            appOriginEnum: AppOriginEnum.manager,
            criticalUpdateRequired: false,
            continueSplashAction: () {},
          ));
          await tester.pumpAndSettle();
        });

        await tester.tap(find.text('no_update_app'));
        await tester.pumpAndSettle();

        expect(dialogo, findsNothing);
        expect(fakeAnalytics.eventNames, ['sindico_atualizacao_adiada_read']);
      });

      testWidgets(
          'atualização obrigatória: sem dispensa, atualizar abre a loja e '
          'voltar não fecha', (tester) async {
        final contexto = await host(tester);
        var continuou = 0;
        final requisicoes = <Uri>[];

        await comLoja(() async {
          unawaited(AppUpdateConfig.showDialogUpDate(
            context: contexto,
            appOriginEnum: AppOriginEnum.manager,
            criticalUpdateRequired: true,
            continueSplashAction: () => continuou++,
          ));
          await tester.pumpAndSettle();
        }, requisicoes: requisicoes);

        expect(
            requisicoes.single.queryParameters['bundleId'], 'app.lello.sindico');
        expect(find.text('new_version_app_critical_dialog_text'),
            findsOneWidget);
        expect(find.text('no_update_app'), findsNothing);
        await expectLater(
          dialogo,
          matchesGoldenFile('goldens/update_dialog_obrigatoria.png'),
        );

        await tester.tap(find.text('yes_update_app'));
        await tester.pumpAndSettle();

        expect(launcher.launched, [_linkLoja]);
        expect(continuou, 1);
        expect(dialogo, findsOneWidget, reason: 'obrigatória não fecha');

        /// Corrigido: o `onWillPop` só chama `continueSplashAction` quando o
        /// diálogo realmente fecha; no obrigatório o botão voltar não faz nada.
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        expect(dialogo, findsOneWidget);
        expect(continuou, 1);
      });

      testWidgets('colaborador não tem id de loja: atualizar só fecha e continua',
          (tester) async {
        final contexto = await host(tester);
        var continuou = 0;
        final requisicoes = <Uri>[];

        await comLoja(() async {
          unawaited(AppUpdateConfig.showDialogUpDate(
            context: contexto,
            appOriginEnum: AppOriginEnum.employee,
            criticalUpdateRequired: true,
            continueSplashAction: () => continuou++,
          ));
          await tester.pumpAndSettle();
        }, resultados: const [], requisicoes: requisicoes);

        expect(requisicoes.single.queryParameters['bundleId'], '');
        expect(dialogo, findsOneWidget);

        await tester.tap(find.text('yes_update_app'));
        await tester.pumpAndSettle();

        expect(dialogo, findsNothing);
        expect(launcher.launched, isEmpty);
        expect(continuou, 1);
      });

      testWidgets('falha na consulta à loja é registrada e não mostra o diálogo',
          (tester) async {
        final contexto = await host(tester);
        await comLoja(() async {
          await AppUpdateConfig.showDialogUpDate(
            context: contexto,
            appOriginEnum: AppOriginEnum.owner,
            criticalUpdateRequired: false,
            continueSplashAction: () {},
          );
          await tester.pumpAndSettle();
        }, falhar: true);

        expect(dialogo, findsNothing);
        expect(tester.takeException(), isNull);
      });
    });

    group('showAlertUpdateDialog', () {
      testWidgets('textos padrão, botão único e barreira bloqueada',
          (tester) async {
        final contexto = await host(tester);
        var continuou = 0;

        unawaited(AppUpdateConfig.showAlertUpdateDialog(
          context: contexto,
          appStoreLink: '',
          continueSplashAction: () => continuou++,
        ));
        await tester.pumpAndSettle();

        expect(find.text('Update Available'), findsOneWidget);
        expect(find.text('You can now update this app'), findsOneWidget);
        expect(find.text('Update'), findsOneWidget);
        expect(find.text('Maybe Later'), findsNothing);

        await tester.tapAt(const Offset(5, 5));
        await tester.pumpAndSettle();
        expect(dialogo, findsOneWidget);
        expect(continuou, 0);

        await tester.tap(find.text('Update'));
        await tester.pumpAndSettle();
        expect(dialogo, findsNothing);
        expect(continuou, 1);
        expect(launcher.launched, isEmpty);
      });

      testWidgets('textos customizados; dispensa padrão fecha e continua',
          (tester) async {
        final contexto = await host(tester);
        var continuou = 0;

        unawaited(AppUpdateConfig.showAlertUpdateDialog(
          context: contexto,
          appStoreLink: _linkLoja,
          continueSplashAction: () => continuou++,
          dialogTitle: 'Nova versão',
          dialogText: 'Atualize agora',
          updateButtonText: 'Atualizar',
          dismissButtonText: 'Depois',
          allowDismissal: true,
        ));
        await tester.pumpAndSettle();

        expect(find.text('Nova versão'), findsOneWidget);
        expect(find.text('Atualize agora'), findsOneWidget);
        expect(find.text('Atualizar'), findsOneWidget);
        expect(find.text('Depois'), findsOneWidget);

        await tester.tap(find.text('Depois'));
        await tester.pumpAndSettle();
        expect(dialogo, findsNothing);
        expect(continuou, 1);
      });

      /// Corrigido: com dispensa permitida e link válido, atualizar fecha o
      /// diálogo e chama `continueSplashAction` uma única vez (via
      /// `launchAppStore`).
      testWidgets('atualizar com dispensa permitida continua uma única vez',
          (tester) async {
        final contexto = await host(tester);
        var continuou = 0;

        unawaited(AppUpdateConfig.showAlertUpdateDialog(
          context: contexto,
          appStoreLink: _linkLoja,
          continueSplashAction: () => continuou++,
          allowDismissal: true,
        ));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Update'));
        await tester.pumpAndSettle();

        expect(launcher.launched, [_linkLoja]);
        expect(dialogo, findsNothing);
        expect(continuou, 1);
      });

      testWidgets('dismissAction customizada substitui a padrão',
          (tester) async {
        final contexto = await host(tester);
        var continuou = 0;
        var custom = 0;

        unawaited(AppUpdateConfig.showAlertUpdateDialog(
          context: contexto,
          appStoreLink: _linkLoja,
          continueSplashAction: () => continuou++,
          allowDismissal: true,
          dismissAction: () => custom++,
        ));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Maybe Later'));
        await tester.pumpAndSettle();

        expect(custom, 1);
        expect(continuou, 0);
        expect(dialogo, findsOneWidget, reason: 'a ação customizada não fecha');
      });

      testWidgets('loja que não pode ser aberta fecha o diálogo e continua',
          (tester) async {
        final contexto = await host(tester);
        var continuou = 0;
        launcher.result = false;

        unawaited(AppUpdateConfig.showAlertUpdateDialog(
          context: contexto,
          appStoreLink: _linkLoja,
          continueSplashAction: () => continuou++,
        ));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Update'));
        await tester.pumpAndSettle();

        expect(launcher.launched, isEmpty);
        expect(dialogo, findsNothing);
        expect(continuou, 1);
      });

      testWidgets('tocar fora e voltar fecham quando a dispensa é permitida',
          (tester) async {
        final contexto = await host(tester);
        var continuou = 0;

        unawaited(AppUpdateConfig.showAlertUpdateDialog(
          context: contexto,
          appStoreLink: _linkLoja,
          continueSplashAction: () => continuou++,
          allowDismissal: true,
        ));
        await tester.pumpAndSettle();

        await tester.tapAt(const Offset(5, 5));
        await tester.pumpAndSettle();
        expect(dialogo, findsNothing);
        expect(continuou, 1);

        unawaited(AppUpdateConfig.showAlertUpdateDialog(
          context: contexto,
          appStoreLink: _linkLoja,
          continueSplashAction: () => continuou++,
          allowDismissal: true,
        ));
        await tester.pumpAndSettle();

        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        expect(dialogo, findsNothing);
        expect(continuou, 2);
      });
    });

    group('launchAppStore', () {
      testWidgets('abre o link e continua', (tester) async {
        final contexto = await host(tester);
        var continuou = 0;

        await AppUpdateConfig.launchAppStore(
            _linkLoja, contexto, () => continuou++);

        expect(launcher.launched, [_linkLoja]);
        expect(continuou, 1);
      });

      testWidgets('sem poder abrir fecha a rota atual e continua',
          (tester) async {
        final contexto = await host(tester);
        var continuou = 0;
        launcher.result = false;

        late BuildContext segunda;
        unawaited(Navigator.of(contexto).push(MaterialPageRoute<void>(
          builder: (c) {
            segunda = c;
            return const Scaffold(body: Text('segunda'));
          },
        )));
        await tester.pumpAndSettle();
        expect(find.text('segunda'), findsOneWidget);

        await AppUpdateConfig.launchAppStore(
            _linkLoja, segunda, () => continuou++);
        await tester.pumpAndSettle();

        expect(launcher.launched, isEmpty);
        expect(find.text('segunda'), findsNothing);
        expect(find.text('host'), findsOneWidget);
        expect(continuou, 1);
      });
    });
  });
}
