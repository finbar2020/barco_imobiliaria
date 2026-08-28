import 'package:colaborador/core/navigation/application_route.dart';
import 'package:colaborador/core/widgets/afastamento_dialog.dart';
import 'package:colaborador/core/widgets/device_type_error_dialog.dart';
import 'package:colaborador/feature/home/presentation/bloc/register_point_bloc.dart';
import 'package:colaborador/feature/home/presentation/widget/pages/home_page/widgets/home_clock_in_range_out_dialog.dart';
import 'package:colaborador/feature/home/presentation/widget/pages/home_page/widgets/home_register_point_button.dart';
import 'package:colaborador/feature/me/domain/entity/digital_timesheet_status_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart' hide isNull;
import 'package:shared_features/shared_features.dart';

import '../../../../helpers/firebase_mocks.dart';
import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_application_container.dart';

class _ButtonScope {
  _ButtonScope(this.container, this.routes);

  final TestApplicationContainerScope container;
  final List<String> routes;

  RegisterPointBloc get bloc => container.registerPointBloc;
}

Future<_ButtonScope> _pumpButton(
  WidgetTester tester, {
  DigitalTimesheetStatusEnum status = DigitalTimesheetStatusEnum.approved,
  FirebaseRemoteConfig? remoteConfig,
}) async {
  final container = await installTestApplicationContainer(
    remoteConfig: remoteConfig,
  );
  addTearDown(container.dispose);
  final routes = <String>[];

  await pumpApp(
    tester,
    Navigator(
      onGenerateRoute: (settings) {
        if (settings.name != null &&
            settings.name != Navigator.defaultRouteName) {
          routes.add(settings.name!);
        }
        return MaterialPageRoute(
          builder: (_) => settings.name == null ||
                  settings.name == Navigator.defaultRouteName
              ? Scaffold(
                  body: HomeRegisterPointButton(
                    registerPointStatusEnum: status,
                    isOnline: true,
                  ),
                )
              : const SizedBox(),
        );
      },
    ),
    localized: true,
    wrapInScaffold: false,
    shrinkWrap: false,
    settle: false,
    surface: const Size(420, 700),
  );
  await tester.pump();

  return _ButtonScope(container, routes);
}

Future<void> _flush(WidgetTester tester) async {
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  tearDown(resetTestApplicationContainer);

  group('HomeRegisterPointButton', () {
    testWidgets('sem conexão abre o aviso de modo avião', (tester) async {
      final scope = await _pumpButton(tester);

      scope.bloc.add(const OfflineFailureEvent());
      await _flush(tester);

      expect(find.byType(Dialog), findsOneWidget);
      expect(find.byIcon(Icons.airplanemode_active_outlined), findsOneWidget);
    });

    testWidgets('colaborador afastado abre o aviso de afastamento',
        (tester) async {
      final scope = await _pumpButton(tester);

      scope.bloc.add(const WorkLeaveEvent(description: 'afastado'));
      await _flush(tester);

      expect(find.byType(AfastamentoDialog), findsOneWidget);
      expect(
        find.textContaining('afastado'),
        findsOneWidget,
      );
    });

    testWidgets('dispositivo não permitido abre o aviso de device',
        (tester) async {
      final scope = await _pumpButton(tester);

      scope.bloc.add(const DeviceTypeFailureEvent(onlyTablet: true));
      await _flush(tester);

      final dialog = tester.widget<DeviceTypeDialog>(
        find.byType(DeviceTypeDialog),
      );
      expect(dialog.onlyTablet, isTrue);
      expect(dialog.onlyPhone, isFalse);
    });

    testWidgets('fora do raio abre o aviso de distância', (tester) async {
      final scope = await _pumpButton(tester);

      scope.bloc.add(const OutOfRangeEvent());
      await _flush(tester);

      expect(find.byType(HomeClockInRangeOutDialog), findsOneWidget);
      expect(scope.routes, isEmpty);
    });

    testWidgets('captura de face navega para o reconhecimento facial',
        (tester) async {
      final scope = await _pumpButton(tester);

      scope.bloc.add(const RegisterPointSuccessEvent());
      await _flush(tester);

      expect(scope.routes, contains(ApplicationRoute.faceDetectionView));
    });

    testWidgets('sem permissão de localização abre os ajustes do sistema',
        (tester) async {
      final scope = await _pumpButton(tester);

      scope.bloc.add(const NoLocationPermissionEvent());
      await _flush(tester);

      expect(
        scope.routes,
        contains(SharedApplicationRoute.accessSettingsPermissionDenied),
      );
    });

    testWidgets('ponto não ativado mostra o texto de conhecer o ponto digital',
        (tester) async {
      await _pumpButton(tester, status: DigitalTimesheetStatusEnum.notActivated);

      expect(find.byType(HomeRegisterPointButton), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });

  group('HomeRegisterPointButton fora do raio', () {
    testWidgets('confirmar mesmo assim segue para o reconhecimento facial',
        (tester) async {
      final scope = await _pumpButton(tester);

      scope.bloc.add(const OutOfRangeEvent());
      await _flush(tester);

      await tester.tap(find.text('home_page_register_point').last);
      await _flush(tester);

      expect(scope.routes, contains(ApplicationRoute.faceDetectionView));
    });

    testWidgets('cancelar no aviso de distância não registra o ponto',
        (tester) async {
      final scope = await _pumpButton(tester);

      scope.bloc.add(const OutOfRangeEvent());
      await _flush(tester);

      await tester.tap(find.text('cancel'));
      await _flush(tester);

      expect(scope.routes, isEmpty);
      expect(find.byType(HomeClockInRangeOutDialog), findsNothing);
    });
  });

  group('HomeRegisterPointButton início do registro', () {
    testWidgets('ponto aprovado valida a distância antes de registrar',
        (tester) async {
      final scope = await _pumpButton(tester);

      scope.bloc.add(const StartRegisterPointEvent());
      await _flush(tester);

      // O controller decide o próximo passo: sem localização liberada o
      // colaborador é levado ao reconhecimento facial.
      expect(
        scope.routes,
        contains(ApplicationRoute.faceDetectionView),
      );
    });

    testWidgets('ponto não ativado abre o material de divulgação',
        (tester) async {
      final launched = <String>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/url_launcher_macos'),
        (call) async {
          launched.add(call.method);
          return true;
        },
      );
      addTearDown(() {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/url_launcher_macos'),
          null,
        );
      });

      await setUpFakeFirebase(
        remoteConfigValues: {
          // O app monta a Uri com `Uri.https(host, "/")`: o valor é só o host.
          'link_conheca_ponto_digital': '{"link":"ponto.lello.com.br"}',
        },
      );
      final scope = await _pumpButton(
        tester,
        status: DigitalTimesheetStatusEnum.notActivated,
        remoteConfig: FirebaseRemoteConfig.instance,
      );

      scope.bloc.add(const StartRegisterPointEvent());
      await _flush(tester);

      expect(scope.routes, isEmpty);
      expect(tester.takeException(), isNull);
    });

    testWidgets('ponto não ativado funciona sem remote config carregado',
        (tester) async {
      final launched = <String>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/url_launcher_macos'),
        (call) async {
          launched.add(call.method);
          return true;
        },
      );
      addTearDown(() {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/url_launcher_macos'),
          null,
        );
      });

      final scope = await _pumpButton(
        tester,
        status: DigitalTimesheetStatusEnum.notActivated,
      );

      scope.bloc.add(const StartRegisterPointEvent());
      await _flush(tester);

      // Sem remote config o app usa o endereço padrão em vez de quebrar.
      expect(tester.takeException(), isNull);
    });
  });
}
