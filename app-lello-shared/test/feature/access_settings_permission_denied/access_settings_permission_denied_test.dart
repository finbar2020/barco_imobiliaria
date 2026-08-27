import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:shared_features/feature/access_settings_permission_denied/entity/access_settings_permissions_denied_item.dart';
import 'package:shared_features/feature/access_settings_permission_denied/presentation/page/access_settings_permission_denied_page.dart';

import '../../helpers/fake_permission_handler.dart';
import '../../helpers/pump_app.dart';
import '../../core/core_test_support.dart';

const _route = '/denied';

/// Empurra a página com os argumentos e guarda o resultado do pop.
class _Host extends StatefulWidget {
  const _Host({required this.item});
  final AcessSettingsPermissionsDeniedItem item;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  final results = <Object?>[];

  @override
  Widget build(BuildContext context) => TextButton(
        key: const Key('abrir'),
        onPressed: () async {
          results.add(await Navigator.of(context).pushNamed(
            _route,
            arguments: AcessSettingsPermissionDeniedPageArgs(
                acessSettingsPermissionsDeniedItem: widget.item),
          ));
        },
        child: const Text('abrir'),
      );
}

void main() {
  late FakePermissionHandler permissions;
  late FakeGeolocatorPlatform geolocator;
  late FakeSvgAssetBundle bundle;

  setUp(() {
    permissions = FakePermissionHandler(status: PermissionStatus.denied);
    setFakePermissionHandler(permissions);
    geolocator = installFakeGeolocator();
    bundle = FakeSvgAssetBundle();
  });

  Future<_HostState> open(WidgetTester tester,
      AcessSettingsPermissionsDeniedItemEnum item,
      {bool colaborador = false}) async {
    await pumpApp(
      tester,
      _Host(
          item: AcessSettingsPermissionsDeniedItem(
              item: item, isColaboradorApp: colaborador)),
      routes: {
        _route: (_) => withFakeAssets(
            const AcessSettingsPermissionDeniedPage(),
            bundle: bundle),
      },
    );
    await tester.tap(find.byKey(const Key('abrir')));
    await tester.pumpAndSettle();
    return tester.state<_HostState>(find.byType(_Host, skipOffstage: false));
  }

  group('AcessSettingsPermissionsDeniedItem', () {
    test('chaves e ícones do app morador', () {
      final cam = AcessSettingsPermissionsDeniedItem(
          item: AcessSettingsPermissionsDeniedItemEnum.cam);
      expect(cam.isColaboradorApp, isFalse);
      expect(cam.titleKey, 'access_settings_permission_denied_title_cam');
      expect(cam.subTitleKey, 'access_settings_permission_denied_subtitle_cam');
      expect(cam.icon, 'assets/ic_cam.svg');
      expect(cam.goToSettingsButtonKey, 'access_settings_permission_denied_go_config');
      expect(cam.backButtonKey, 'back');

      final files = AcessSettingsPermissionsDeniedItem(
          item: AcessSettingsPermissionsDeniedItemEnum.files);
      expect(files.titleKey, 'access_settings_permission_denied_title_files');
      expect(files.subTitleKey, 'access_settings_permission_denied_subtitle_files');
      expect(files.icon, 'assets/ic_files.svg');

      final location = AcessSettingsPermissionsDeniedItem(
          item: AcessSettingsPermissionsDeniedItemEnum.location);
      expect(location.titleKey, 'access_settings_permission_denied_title_location');
      expect(location.subTitleKey,
          'access_settings_permission_denied_subtitle_location');
      expect(location.icon, 'assets/ic_location.svg');
    });

    test('chaves e ícones do app colaborador', () {
      final cam = AcessSettingsPermissionsDeniedItem(
          item: AcessSettingsPermissionsDeniedItemEnum.cam, isColaboradorApp: true);
      expect(cam.titleKey, 'access_settings_permission_denied_title_cam_colaborador');
      expect(cam.subTitleKey,
          'access_settings_permission_denied_subtitle_cam_colaborador');
      expect(cam.icon, 'assets/ic_cam_colaborador.svg');
      expect(cam.goToSettingsButtonKey,
          'access_settings_permission_denied_go_config_colaborador');
      expect(cam.backButtonKey, 'back_colaborador');

      final files = AcessSettingsPermissionsDeniedItem(
          item: AcessSettingsPermissionsDeniedItemEnum.files,
          isColaboradorApp: true);
      expect(files.titleKey, 'access_settings_permission_denied_title_files_colaborador');
      expect(files.subTitleKey,
          'access_settings_permission_denied_subtitle_files_colaborador');
      expect(files.icon, 'assets/ic_files_colaborador.svg');

      final location = AcessSettingsPermissionsDeniedItem(
          item: AcessSettingsPermissionsDeniedItemEnum.location,
          isColaboradorApp: true);
      expect(location.titleKey,
          'access_settings_permission_denied_title_location_colaborador');
      expect(location.subTitleKey,
          'access_settings_permission_denied_subtitle_location_colaborador');
      expect(location.icon, 'assets/ic_location_colaborador.svg');
    });
  });

  group('AcessSettingsPermissionDeniedPage', () {
    testWidgets('mostra ícone, título, subtítulo e botões do item', (tester) async {
      await open(tester, AcessSettingsPermissionsDeniedItemEnum.cam);
      expect(bundle.loaded, ['assets/ic_cam.svg']);
      expect(find.text('access_settings_permission_denied_title_cam'), findsOneWidget);
      expect(find.text('access_settings_permission_denied_subtitle_cam'),
          findsOneWidget);
      expect(find.text('access_settings_permission_denied_go_config'), findsOneWidget);
      expect(find.text('back'), findsOneWidget);
      final theme = tester.widget<Theme>(find
          .ancestor(of: find.byType(Scaffold), matching: find.byType(Theme))
          .first);
      expect(theme.data.primaryColor, LelloTheme.light.primaryColor);
      await expectLater(find.byType(AcessSettingsPermissionDeniedPage),
          matchesGoldenFile('goldens/access_settings_permission_denied_cam.png'));
    });

    testWidgets('no app colaborador usa o tema carimbeira e os textos próprios',
        (tester) async {
      await open(tester, AcessSettingsPermissionsDeniedItemEnum.files,
          colaborador: true);
      expect(bundle.loaded, ['assets/ic_files_colaborador.svg']);
      expect(find.text('access_settings_permission_denied_title_files_colaborador'),
          findsOneWidget);
      expect(find.text('access_settings_permission_denied_go_config_colaborador'),
          findsOneWidget);
      expect(find.text('back_colaborador'), findsOneWidget);
      final theme = tester.widget<Theme>(find
          .ancestor(of: find.byType(Scaffold), matching: find.byType(Theme))
          .first);
      expect(theme.data.primaryColor, LelloTheme.carimbeira.primaryColor);
      await expectLater(
          find.byType(AcessSettingsPermissionDeniedPage),
          matchesGoldenFile(
              'goldens/access_settings_permission_denied_files_colaborador.png'));
    });

    testWidgets('voltar fecha com false', (tester) async {
      final host = await open(tester, AcessSettingsPermissionsDeniedItemEnum.location);
      await tester.tap(find.text('back'));
      await tester.pumpAndSettle();
      expect(find.byType(AcessSettingsPermissionDeniedPage), findsNothing);
      expect(host.results.single, isFalse);
      expect(geolocator.settingsOpened, 0);
    });

    testWidgets('ir para configurações abre as configurações do app',
        (tester) async {
      final host = await open(tester, AcessSettingsPermissionsDeniedItemEnum.location);
      await tester.tap(find.text('access_settings_permission_denied_go_config'));
      await tester.pumpAndSettle();
      expect(geolocator.settingsOpened, 1);
      expect(find.byType(AcessSettingsPermissionDeniedPage), findsOneWidget);
      expect(host.results, isEmpty);
    });

    testWidgets('voltar ao app sem ter ido às configurações não verifica nada',
        (tester) async {
      final host = await open(tester, AcessSettingsPermissionsDeniedItemEnum.cam);
      permissions.status = PermissionStatus.granted;
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();
      expect(find.byType(AcessSettingsPermissionDeniedPage), findsOneWidget);
      expect(host.results, isEmpty);
    });

    Future<_HostState> goToSettingsAndResume(
        WidgetTester tester, AcessSettingsPermissionsDeniedItemEnum item) async {
      final host = await open(tester, item);
      await tester.tap(find.text('access_settings_permission_denied_go_config'));
      await tester.pumpAndSettle();
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();
      return host;
    }

    testWidgets('localização concedida ao voltar fecha com true', (tester) async {
      permissions.status = PermissionStatus.granted;
      final host = await goToSettingsAndResume(
          tester, AcessSettingsPermissionsDeniedItemEnum.location);
      expect(find.byType(AcessSettingsPermissionDeniedPage), findsNothing);
      expect(host.results.single, isTrue);
    });

    testWidgets('localização ainda negada mantém a página', (tester) async {
      final host = await goToSettingsAndResume(
          tester, AcessSettingsPermissionsDeniedItemEnum.location);
      expect(find.byType(AcessSettingsPermissionDeniedPage), findsOneWidget);
      expect(host.results, isEmpty);
      // um segundo resume não verifica de novo
      permissions.status = PermissionStatus.granted;
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();
      expect(host.results, isEmpty);
    });

    testWidgets('câmera concedida ao voltar fecha com true', (tester) async {
      permissions.status = PermissionStatus.granted;
      final host = await goToSettingsAndResume(
          tester, AcessSettingsPermissionsDeniedItemEnum.cam);
      expect(host.results.single, isTrue);
    });

    testWidgets('câmera ainda negada mantém a página', (tester) async {
      final host = await goToSettingsAndResume(
          tester, AcessSettingsPermissionsDeniedItemEnum.cam);
      expect(host.results, isEmpty);
    });

    testWidgets('arquivos: storage concedido (após pedir) fecha com true',
        (tester) async {
      final host = await goToSettingsAndResume(
          tester, AcessSettingsPermissionsDeniedItemEnum.files);
      expect(permissions.requestCount, 1);
      expect(host.results.single, isTrue);
    });

    testWidgets('arquivos: storage recusado mantém a página', (tester) async {
      setFakePermissionHandler(
          StubbornPermissionHandler(status: PermissionStatus.denied));
      final host = await goToSettingsAndResume(
          tester, AcessSettingsPermissionsDeniedItemEnum.files);
      expect(host.results, isEmpty);
      expect(find.byType(AcessSettingsPermissionDeniedPage), findsOneWidget);
    });
  });
}
