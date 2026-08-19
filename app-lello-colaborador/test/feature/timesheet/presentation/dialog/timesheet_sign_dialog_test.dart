import 'dart:async';

import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_assign_dialog/bloc/timesheet_sign_bloc.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_assign_dialog/bloc/timesheet_sign_state.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_assign_dialog/page/timesheet_sign_dialog.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_assign_dialog/widget/timesheet_sign_failed_body.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_assign_dialog/widget/timesheet_sign_fill_body.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_assign_dialog/widget/timesheet_sign_loading_body.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_assign_dialog/widget/timesheet_sign_success_body.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_application_container.dart';

class _FakeSignBloc extends Fake implements TimesheetSignBloc {
  _FakeSignBloc(this._state);

  final TimesheetSignState _state;
  final _controller = StreamController<TimesheetSignState>.broadcast();
  final signedPeriods = <DateTime>[];

  @override
  TimesheetSignState get state => _state;

  @override
  Stream<TimesheetSignState> get stream => _controller.stream;

  @override
  void timesheetSign(DateTime period) => signedPeriods.add(period);

  @override
  Future<void> close() async {}

  Future<void> dispose() => _controller.close();
}

late _FakeSignBloc _bloc;

Future<void> _install(TimesheetSignState state) async {
  final locator = ApplicationContainer.instance().locator;
  if (locator.isRegistered<Environment>()) {
    await locator.reset(dispose: true);
  }
  _bloc = _FakeSignBloc(state);
  locator.registerSingleton<Environment>(TestEnvironment());
  locator.registerSingleton<TimesheetSignBloc>(_bloc);
}

Future<void> _pumpDialog(WidgetTester tester) async {
  await pumpApp(
    tester,
    TimesheetSignDialogBody(period: DateTime(2026, 1, 31)),
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

  group('TimesheetSignDialogBody', () {
    testWidgets('estado inicial convida a assinar a folha', (tester) async {
      await _install(const TimesheetSignInitialState());
      await _pumpDialog(tester);

      expect(find.byType(TimesheetSignFillBody), findsOneWidget);
      expect(find.text('timesheet_sign_title'), findsOneWidget);
    });

    testWidgets('confirmar dispara a assinatura do período', (tester) async {
      await _install(const TimesheetSignInitialState());
      await _pumpDialog(tester);

      await tester.tap(find.text('TIMESHEET_SIGN_OK'));
      await tester.pump();

      expect(_bloc.signedPeriods, [DateTime(2026, 1, 31)]);
    });

    testWidgets('assinando mostra o corpo de loading', (tester) async {
      await _install(const TimesheetSignLoadingState());
      await _pumpDialog(tester);

      expect(find.byType(TimesheetSignLoadingBody), findsOneWidget);
    });

    testWidgets('sucesso mostra a confirmação', (tester) async {
      await _install(const TimesheetSignSuccessState());
      await _pumpDialog(tester);

      expect(find.byType(TimesheetSignSuccessBody), findsOneWidget);
      expect(find.text('timesheet_sign_success'), findsOneWidget);
    });

    testWidgets('falha permite tentar assinar novamente', (tester) async {
      await _install(const TimesheetSignFailedState());
      await _pumpDialog(tester);

      expect(find.byType(TimesheetSignFailedBody), findsOneWidget);
    });
  });
}
