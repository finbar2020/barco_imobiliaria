import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/authentication_tablet/presentation/bloc/authentication_tablet_state.dart';
import 'package:colaborador/feature/authentication_tablet/presentation/widget/login_tablet_condominium_step_widget.dart';
import 'package:colaborador/feature/authentication_tablet/presentation/widget/login_tablet_loaded_widget.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:essentials/essentials.dart' hide Image;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_application_container.dart';

class _ProductionEnvironment extends Environment {
  _ProductionEnvironment()
      : super(name: 'prod', isProduction: true, apiUrl: 'http://localhost');
}

class _FakeSessionBloc extends Fake implements SessionBloc {
  _FakeSessionBloc({this.showSyncList = false});

  final bool showSyncList;

  @override
  bool showButtonNoAuthPointList(String reference) => showSyncList;
}

late TestTabletAuthScope _scope;

Future<void> _installContainer({
  bool production = false,
  bool showSyncList = false,
}) async {
  _scope = await installTestTabletAuth();
  final locator = ApplicationContainer.instance().locator;
  if (locator.isRegistered<Environment>()) {
    await locator.unregister<Environment>();
  }
  locator.registerSingleton<Environment>(
    production ? _ProductionEnvironment() : TestEnvironment(),
  );
  locator.registerSingleton<SessionBloc>(
    _FakeSessionBloc(showSyncList: showSyncList),
  );
}

Future<List<LoginTabletSteps>> _pumpStep(WidgetTester tester) async {
  final steps = <LoginTabletSteps>[];
  await pumpApp(
    tester,
    LoginTabletCondominiumStepWidget(
      condominiumName: 'torre lello',
      condoRef: 'R1',
      changeStep: steps.add,
    ),
    localized: true,
    shrinkWrap: false,
    settle: false,
    surface: const Size(600, 1000),
  );
  await tester.pump();
  return steps;
}

void main() {
  tearDown(() async {
    _scope.dispose();
    await resetTestApplicationContainer();
  });

  group('LoginTabletCondominiumStepWidget', () {
    testWidgets('exibe condomínio, data e ações do tablet', (tester) async {
      await _installContainer();
      await _pumpStep(tester);

      expect(find.text('TORRE LELLO'), findsOneWidget);
      expect(
        find.text(DateFormat('dd/MM/yyyy').format(DateTime.now())),
        findsOneWidget,
      );
      expect(find.text('login_tablet_condo_start'), findsOneWidget);
      expect(find.text('login_tablet_condo_sync'), findsOneWidget);
    });

    testWidgets('iniciar leva para a lista de colaboradores', (tester) async {
      await _installContainer();
      final steps = await _pumpStep(tester);

      await tester.tap(find.text('login_tablet_condo_start'));
      await tester.pump();

      expect(steps, [LoginTabletSteps.employees]);
    });

    testWidgets('sem liberação não mostra a lista de pontos offline',
        (tester) async {
      await _installContainer();
      await _pumpStep(tester);

      expect(find.text('login_tablet_condo_sync_view'), findsNothing);
    });

    testWidgets('com liberação abre a lista de pontos offline', (tester) async {
      await _installContainer(showSyncList: true);
      final steps = await _pumpStep(tester);

      expect(find.text('login_tablet_condo_sync_view'), findsOneWidget);

      await tester.tap(find.text('login_tablet_condo_sync_view'));
      await tester.pump();

      expect(steps, [LoginTabletSteps.listOfflinePoints]);
    });

    testWidgets('sincronizar dispara o envio dos pontos pendentes',
        (tester) async {
      await _installContainer();
      await _pumpStep(tester);

      await tester.tap(find.text('login_tablet_condo_sync'));
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      expect(
        _scope.bloc.state,
        isNot(isA<AuthenticationTabletInitialState>()),
      );
    });

    testWidgets('atalho de voltar ao login não aparece em produção',
        (tester) async {
      await _installContainer(production: true);
      await _pumpStep(tester);

      expect(find.text('login_tablet_condo_back'), findsNothing);
    });

    testWidgets('atalho de voltar ao login aparece fora de produção',
        (tester) async {
      await _installContainer();
      await _pumpStep(tester);

      expect(find.text('login_tablet_condo_back'), findsOneWidget);
    });
  });
}
