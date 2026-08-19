import 'dart:async';

import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/core/widgets/afastamento_dialog.dart';
import 'package:colaborador/core/widgets/device_type_error_dialog.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point_register_failure.dart';
import 'package:colaborador/feature/sync_digital_points/presentation/bloc/sync_digital_points_bloc.dart';
import 'package:colaborador/feature/sync_digital_points/presentation/bloc/sync_digital_points_event.dart';
import 'package:colaborador/feature/sync_digital_points/presentation/bloc/sync_digital_points_state.dart';
import 'package:colaborador/feature/sync_digital_points/presentation/widget/sync_digital_points_dialog.dart';
import 'package:colaborador/feature/sync_digital_points/presentation/widget/sync_failed_widget.dart';
import 'package:colaborador/feature/sync_digital_points/presentation/widget/sync_success_widget.dart';
import 'package:colaborador/feature/sync_digital_points/presentation/widget/sync_widget.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_application_container.dart';

class _FakeSyncBloc extends Fake implements SyncDigitalPointsBloc {
  _FakeSyncBloc(this._state);

  final SyncDigitalPointsState _state;
  final events = <SyncDigitalPointsEvent>[];
  final _controller = StreamController<SyncDigitalPointsState>.broadcast();

  @override
  SyncDigitalPointsState get state => _state;

  @override
  Stream<SyncDigitalPointsState> get stream => _controller.stream;

  @override
  void add(SyncDigitalPointsEvent event) => events.add(event);

  Future<void> dispose() => _controller.close();
}

late _FakeSyncBloc _bloc;

Future<void> _installContainer(SyncDigitalPointsState state) async {
  final locator = ApplicationContainer.instance().locator;
  if (locator.isRegistered<Environment>()) {
    await locator.reset(dispose: true);
  }
  _bloc = _FakeSyncBloc(state);
  locator.registerSingleton<Environment>(TestEnvironment());
  locator.registerSingleton<SyncDigitalPointsBloc>(_bloc);
}

Future<void> _pumpDialog(
  WidgetTester tester, {
  List<DigitalPointEntity> points = const [],
}) async {
  await pumpApp(
    tester,
    SyncDigitalPointsDialogWidget(digitalPoints: points),
    localized: true,
    wrapInScaffold: false,
    shrinkWrap: false,
    settle: false,
    surface: const Size(420, 800),
  );
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  tearDown(() async {
    await _bloc.dispose();
    await resetTestApplicationContainer();
  });

  group('SyncDigitalPointsDialogWidget', () {
    testWidgets('estado inicial oferece a sincronização dos pontos',
        (tester) async {
      await _installContainer(const SyncDigitalPointsLoadedState());
      await _pumpDialog(tester, points: [testPoint()]);

      expect(find.byType(SyncWidget), findsOneWidget);
    });

    testWidgets('sincronizando mostra o indicador', (tester) async {
      await _installContainer(const SyncDigitalPointsLoadingState());
      await _pumpDialog(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(SyncWidget), findsNothing);
    });

    testWidgets('sucesso mostra a confirmação', (tester) async {
      await _installContainer(const SyncDigitalPointsSuccessState());
      await _pumpDialog(tester);

      expect(find.byType(SyncSuccessWidget), findsOneWidget);
    });

    testWidgets('falha lista os pontos não enviados', (tester) async {
      await _installContainer(
        SyncDigitalPointsFailedState(failedDigitalPoints: [testPoint()]),
      );
      await _pumpDialog(tester);

      expect(find.byType(SyncFailedWidget), findsOneWidget);
    });

    testWidgets('afastamento troca o diálogo pelo aviso próprio',
        (tester) async {
      await _installContainer(
        const SyncDigitalPointsFailedState(
          failedDigitalPoints: [],
          code: DigitalPointRegisterFailure.onWorkLeaveNotAccepted,
          message: 'afastado',
        ),
      );
      await _pumpDialog(tester);

      expect(find.byType(AfastamentoDialog), findsOneWidget);
      expect(find.byType(SyncFailedWidget), findsNothing);
    });

    testWidgets('device bloqueado mostra o aviso de dispositivo',
        (tester) async {
      await _installContainer(
        const SyncDigitalPointsBlockedState(onlyPhone: true),
      );
      await _pumpDialog(tester);

      final dialog = tester.widget<DeviceTypeDialog>(
        find.byType(DeviceTypeDialog),
      );
      expect(dialog.onlyPhone, isTrue);
      expect(dialog.onlyTablet, isFalse);
    });
  });
}
